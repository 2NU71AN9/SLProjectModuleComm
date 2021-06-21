//
//  UserLoginRetryServicer.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/1/15.
//

import UIKit
import RxSwift

class UserLoginRetryServicer: NSObject {
    /**
     进行某个操作前判断是否登录, 未登录跳转登录, 登录成功后自动进行改操作
     UserLoginRetryServicer.isLogin().subscribe(onNext: { [weak self] (_) in
         // ...
     }).disposed(by: bagStay)
     */
    static func isLogin() -> Observable<Bool> {
        let object = Observable<Bool>.create { (obsever) -> Disposable in
            if AccountServicer.service.isLogin {
                obsever.onNext(true)
                obsever.onCompleted()
            } else {
                obsever.onError(SLError.failed(code: HttpCode.logout.rawValue, message: "未登录"))
                obsever.onCompleted()
            }
            return Disposables.create()
        }.showError()
        return AccountServicer.service.loginSuccessSubject.filter { $0 } .take(1).flatMap { _ in object }
    }
}
