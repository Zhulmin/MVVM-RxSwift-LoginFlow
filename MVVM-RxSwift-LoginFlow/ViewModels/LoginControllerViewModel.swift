//
//  LoginControllerViewModel.swift
//  MVVM-RxSwift-LoginFlow
//
//  Created by Alexey Savchenko on 6/19/18.
//  Copyright © 2018 Alexey Savchenko. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginControllerViewModel: ViewModelProtocol {
    
    struct Input {
        
        //方法一:
        // 这里可以只使用Observer,暴露出去
        // 里面再定义PublishSubject为私有变量,把PublishSubject赋值给这个Observer
        
        //内部变量
//        private let email =  PublishSubject<String>()
        
        //暴露出去
//        public let emailOberver = email.asOberver()
        
        // 使用PublishSubject是因为:
        // 1.需要在外面为Observer,绑定UI事件
        // 2.在里面Obervable, 被观察, 获取到参数值
        // 把两个融合在一起了
        
        var email = PublishSubject<String>()
        let password = PublishSubject<String>()
        let signInDidTap = PublishSubject<Void>()
        
        
                
        //let loadListTrigger :  Observable<String>

        
        //暴露出去Observer,发起请求, 内部Observable,监听发起网络请求

        let loadListTrigger =  PublishSubject<String>()
        
    }
    struct Output {
        
        let userListObservable = BehaviorRelay<[User]>.init(value: [])

        //
        let loginResultObservable = PublishSubject<User>()
    
        let errorsObservable = PublishSubject<Error>()
    }
    
    
    // MARK: - Public properties
    let input: Input
    let output: Output
    
    private let disposeBag = DisposeBag()
    
    private var credentialsObservable: Observable<Credentials> {
        return Observable.combineLatest(input.email, input.password) { (email, password) in
            return Credentials(email: email, password: password)
        }
    }
    
    // MARK: - Init and deinit
    init(_ loginService: LoginServiceProtocol) {
        
       
        input = Input()
        
        output = Output()
        
        
        // 如果input中之定义了Observer
        // 这里需要创建局部变量, 并赋值给Observer (input初始化方法中)
//        let loadData = PublishSubject<String>()
        
    
        input.loadListTrigger.flatMapLatest({userId in
            
            //如果使用Relay, 这里不用加.materialize()
            return loginService.fetchuUserList(with: userId)
            
        }).subscribe(onNext:{[weak self] users in
            
            let old = self?.output.userListObservable.value
            self?.output.userListObservable.accept(old! + users)
            
        }).disposed(by: disposeBag)
        
        
        input.signInDidTap
            .withLatestFrom(credentialsObservable)
            .flatMapLatest { credentials in
                
                return loginService.signIn(with: credentials).materialize()
            }
            .subscribe(onNext: { [weak self] event in
                
                switch event {
                case .next(let user):
                    
                    self?.output.loginResultObservable.onNext(user)
                case .error(let error):
                    self?.output.errorsObservable.onNext(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("\(self) dealloc")
    }
}
