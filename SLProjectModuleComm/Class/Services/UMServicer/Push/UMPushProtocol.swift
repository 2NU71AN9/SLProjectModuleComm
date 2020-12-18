//
//  UMPushProtocol.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/17.
//

import UIKit

protocol UMPushProtocol {
    func confitPushSettings(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func registDeviceToken(_ deviceToken: Data?)
    
    /// 添加标签
    func addTags(_ tag: [String])
    /// 删除标签
    func deleteTags(_ tag: [String])
    /// 绑定别名
    func addAlias(_ name: String, type: String)
    /// 重置别名
    func setAlias(_ name: String, type: String)
    /// 移除别名
    func removeAlias(_ name: String, type: String)
}

extension UMPushProtocol where Self: SLUMServicer {
    func confitPushSettings(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = UMessageRegisterEntity()
        entity.types = Int(UMessageAuthorizationOptions.badge.rawValue | UMessageAuthorizationOptions.sound.rawValue | UMessageAuthorizationOptions.alert.rawValue)
        UNUserNotificationCenter.current().delegate = self
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, _) in
            print(granted)
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        // 设置是否允许SDK当应用在前台运行收到Push时弹出Alert框
        UMessage.setAutoAlert(false)
    }
    
    func registDeviceToken(_ deviceToken: Data?) {
//        let devieTokenString = deviceToken?.reduce("", { $0 + String(format: "%02x", $1) })
        UMessage.registerDeviceToken(deviceToken)
    }
    
    func addTags(_ tag: [String]) {
        UMessage.addTags(tag) { (_, _, error) in
            if let error = error { print(error) }
        }
    }
    func deleteTags(_ tag: [String]) {
        UMessage.deleteTags(tag) { (_, _, error) in
            if let error = error { print(error) }
        }
    }
    func addAlias(_ name: String, type: String) {
        UMessage.addAlias(name, type: type) { (_, error) in
            if let error = error { print(error) }
        }
    }
    func setAlias(_ name: String, type: String) {
        UMessage.setAlias(name, type: type) { (_, error) in
            if let error = error { print(error) }
        }
    }
    func removeAlias(_ name: String, type: String) {
        UMessage.removeAlias(name, type: type) { (_, error) in
            if let error = error { print(error) }
        }
    }
}
