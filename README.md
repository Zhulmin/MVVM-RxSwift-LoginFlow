# MVVM-RxSwift-LoginFlow

Sample app for a blog post on Medium - https://medium.com/@caesarus1993/login-screen-implementation-using-mvvm-rxswift-efe832c687fa



1.定义Input和Output

2.viewModel中定义的需要在Controller中使用的Rx参数, 都为PublishSubject, 因为都是需要为被观察者, 处理事件, 又需要作为观察者, 触发事件.



3.在viewModel的Output中定义被观察者Observable, 作为处理异步事件的回调, Controller中只要处理事件

其实Controller中也有触发事件(发起网络请求), 但是网络请求返回的参数是不一样的 需要另外定义一个Observable, 

而网络请求定义的Trigger是PublishSubject, 因为在控制器中发起, 在viewModel中正式发起网络请求(监听)

