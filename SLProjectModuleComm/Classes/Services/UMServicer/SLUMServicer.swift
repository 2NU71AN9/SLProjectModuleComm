//
//  SLUMServicer.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/16.
//

import UIKit

class SLUMServicer: NSObject, UMAnalyticsProtocol, UMShareProtocol, UMPushProtocol {
    
    static let shared = SLUMServicer()
    
    /// 注册友盟
    /// - Parameter appKey: AppKey
    func config(_ appKey: String, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        UMConfigure.initWithAppkey(appKey, channel: nil)
        #if DEBUG
        UMConfigure.setLogEnabled(true)
        UMCommonLogManager.setUp()
        #else
        UMConfigure.setLogEnabled(false)
        #endif
        
        confitAnalyticsSettings()
        confitShareSettings()
        confitPushSettings(launchOptions)
    }
}

extension SLUMServicer {
    @objc func handleOpenURL(url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        UMSocialManager.default()?.handleOpen(url, options: options) ?? false
    }

    @objc func handleUniversalLink(activity: NSUserActivity) -> Bool {
        UMSocialManager.default()?.handleUniversalLink(activity, options: nil) ?? false
    }
}

extension SLUMServicer: UNUserNotificationCenterDelegate {
    /// 处理前台收到通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            // 应用处于前台时的远程推送接受
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(userInfo)
        } else {
            // 应用处于前台时的本地推送接受
            print("应用处于前台时的本地推送接受")
        }
        completionHandler(.badge)
    }

    /// 处理后台点击通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            // 应用处于后台时的远程推送接受
            UMessage.didReceiveRemoteNotification(userInfo)
        } else {
            // 应用处于后台时的本地推送接受
            print("应用处于后台时的本地推送接受")
        }
    }
}
