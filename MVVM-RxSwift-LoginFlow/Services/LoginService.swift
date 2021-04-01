//
//  LoginService.swift
//  MVVM-RxSwift-LoginFlow
//
//  Created by Alexey Savchenko on 6/19/18.
//  Copyright © 2018 Alexey Savchenko. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginServiceProtocol {
    func signIn(with credentials: Credentials) -> Observable<User>
    
    func fetchuUserList(with userId : String) -> Observable<[User]>
}

class LoginService: LoginServiceProtocol {
    func signIn(with credentials: Credentials) -> Observable<User> {
        return Observable.create { observer in
            /*
             Networking logic here.
            */
            observer.onNext(User()) // Simulation of successful user authentication.
            return Disposables.create()
        }
    }
    
    
    func fetchuUserList(with userId : String) -> Observable<[User]> {
        return Observable.create { observer in
            /*
             Networking logic here.
            */
            let users = [User()]
            observer.onNext(users) // Simulation of successful user authentication.
            return Disposables.create()
        }
    }
}
