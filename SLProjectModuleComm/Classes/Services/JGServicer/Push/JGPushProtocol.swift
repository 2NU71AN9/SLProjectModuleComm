//
//  JGPushProtocol.swift
//  SLJGServicer
//
//  Created by 孙梁 on 2021/1/9.
//

import UIKit

public protocol JGPushProtocol {
    var pushService: JPUSHService.Type { get }
    
    func registPush(appKey: String, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Self
    func registDeviceToken(_ deviceToken: Data?)
    /**
     设置手机号码，可实现“推送不到短信到”的通知方式，提高推送达到率
     传 nil 或空串则为解除号码绑定操作
     */
    func setPhone(_ phone: String?, complete: ((Bool) -> Void)?)
    /// 跳转设置页面
    func openSettingsForNotification()
    /// 设置角标
    func setBadge(_ num: Int)
    
    /// 可添加标签与别名,地理位置统计,地理围栏等接口
}

public extension JGPushProtocol where Self: SLJGServicer {
    
    var pushService: JPUSHService.Type { JPUSHService.self }
    
    @discardableResult
    func registPush(appKey: String, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Self {
        let entity = JPUSHRegisterEntity()
        if #available(iOS 12.0, *) {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue | JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
        } else {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue)
        }
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        var production = true
        #if DEBUG
        production = false
        JPUSHService.setDebugMode()
        #else
        JPUSHService.setLogOFF()
        #endif
        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: "App Store", apsForProduction: production)
        
        /// 获取自定义消息推送内容
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCustomMessage(_:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        /// 应用程序成功注册到 JPush 服务器
        NotificationCenter.default.addObserver(self, selector: #selector(didRegisterNotification), name: NSNotification.Name.jpfNetworkDidRegister, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRegisterNotification), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
        return self
    }
    
    func registDeviceToken(_ deviceToken: Data?) {
//        let devieTokenString = deviceToken?.reduce("", { $0 + String(format: "%02x", $1) })
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func setPhone(_ phone: String?, complete: ((Bool) -> Void)?) {
        JPUSHService.setMobileNumber(phone) { (error) in
            complete?(error == nil)
        }
    }
    
    func openSettingsForNotification() {
        JPUSHService.openSettings { (_) in
            
        }
    }
    
    func setBadge(_ num: Int) {
        JPUSHService.setBadge(num)
        UIApplication.shared.applicationIconBadgeNumber = num
    }
}
