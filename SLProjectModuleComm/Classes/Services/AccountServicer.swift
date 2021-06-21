//
//  AccountServicer.swift
//  LiveTeacher
//
//  Created by 孙梁 on 2020/7/21.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// 用户登录相关信息管理
class AccountServicer: NSObject {
    @objc static let service = AccountServicer()
    /**
     初始化
     UserDefaults获取保存的用户信息和token
     */
    private override init() {
        super.init()
        if let dict = UserDefaults.standard.value(forKey: userDateStandKey) as? [String: Any] {
            userDate = SLUserModel.deserialize(from: dict)
        }
        if let token = UserDefaults.standard.value(forKey: tokenStandKey) as? String {
            self.token = token
        }
    }
    /// 是否登录
    @objc var isLogin: Bool { !(token?.isEmpty ?? true) }
    /// token
    @objc private(set) var token: String?
    /// 用户信息
    private(set) var userDate: SLUserModel?
    /// 登录信息
    private(set) var robotServiceUrl: String?

    // 登录成功后发出通知(只用监听), 发通知调用loginSuccess()
    let loginSuccessSubject = PublishSubject<Bool>()
    // 退出成功后发出通知(只用监听) 是否要重新刷新界面
    let haveToLogoutSubject = BehaviorRelay<PublishSubject<Bool>>(value: PublishSubject<Bool>())
    // 用户信息更新了
    let userDataUpdataSubject = PublishSubject<SLUserModel>()
}

extension AccountServicer {
    /// 用户登出, 清除登录信息和用户信息, 重新刷新页面
    @objc func logout() {
        if isLogin == false {
            goToLogin()
        } else {
            cleanUserDate()
            goToLogin()
        }
    }
    
    /// 登录成功
    @objc func loginSuccess() {
        loginSuccessSubject.onNext(true)
    }

    /// 清除用户信息
    @objc func cleanUserDate() {
        userDate = nil
        token = nil
        UserDefaults.standard.removeObject(forKey: userDateStandKey)
        UserDefaults.standard.removeObject(forKey: tokenStandKey)
    }

    /// 前往登陆页, 不清除登录信息和用户信息, 不会重新刷新页面
    @objc func goToLogin() {
        haveToLogoutSubject.value.onNext(false)
        haveToLogoutSubject.value.onCompleted()
    }

    /// 保存用户信息
    @objc func saveUserDate(_ model: SLUserModel?) {
        guard let model = model, let json = model.toJSON() else { return }
        userDate = model
        UserDefaults.standard.setValue(json, forKey: userDateStandKey)
    }

    /// 保存token
    @objc func saveToken(_ token: String) {
        self.token = token
        UserDefaults.standard.setValue(token, forKey: tokenStandKey)
    }

    /// 获取用户信息
    @objc func loadUserData() {
        // TODO: - loadUserData
//        _ = NetworkHandler.request(.userInfo)
//            .mapToModel(NYUserModel.self)
//            .subscribe(onNext: { [weak self] (model) in
//                self?.refreshUserDate(model)
//                self?.userDataUpdata.onNext(model)
//            })
    }
}
