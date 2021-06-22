//
//  SLJGServicer.swift
//  SLJGServicer
//
//  Created by 孙梁 on 2021/1/8.
//

import UIKit

/**
 添加URL Schemes jiguang jiguang-AppKey
 */
public class SLJGServicer: NSObject, JGAnalyticsProtocol, JGShareProtocol, JGPushProtocol {
    
    public static let shared = SLJGServicer()
    private override init() { super.init() }
    
    /// 注册极光
    /// - Parameter appKey: AppKey
    public func regist(_ appKey: String) -> SLJGServicer { self }
}

public extension SLJGServicer {
    @objc func handleOpenURL(url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        JANALYTICSService.handle(url) || JSHAREService.handleOpen(url)
    }
    @objc func handleUniversalLink(url: URL?) -> Bool {
        JSHAREService.handleOpen(url)
    }
}

// MARK: - 推送相关
extension SLJGServicer: JPUSHRegisterDelegate {
    /// 应用在前台时收到通知
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        if notification != nil,
           let trigger = notification.request.trigger,
           trigger.isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService.handleRemoteNotification(notification.request.content.userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    /// 点击通知进入
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        if let trigger = response.notification.request.trigger,
           trigger.isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService.handleRemoteNotification(response.notification.request.content.userInfo)
        }
        completionHandler()
    }
    
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        if notification != nil,
           let trigger = notification.request.trigger,
           trigger.isKind(of: UNPushNotificationTrigger.self) {
            //从通知界面直接进入应用
        } else {
            //从通知设置界面进入应用
        }
    }
    
    public func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
    }
}
// MARK: - 推送相关
public extension SLJGServicer {
    /// 获取自定义消息推送内容,不会有通知提醒, 只有在前端运行的时候才能收到自定义消息的推送。
    @objc func didReceiveCustomMessage(_ notification: Notification) {
        print(notification.userInfo!)
    }
    
    /**
     应用程序成功注册到 JPush 服务器
     集成了 JPush SDK 的应用程序在第一次成功注册到 JPush 服务器时，JPush 服务器会给客户端返回一个唯一的该设备的标识 - RegistrationID。JPush SDK 会以广播的形式发送 RegistrationID 到应用程序。
     应用程序可以把此 RegistrationID 保存以自己的应用服务器上，然后就可以根据 RegistrationID 来向设备推送消息或者通知。
     */
    @objc func didRegisterNotification() {
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            print("registrationID==>\(registrationID)")
        }
    }
}
