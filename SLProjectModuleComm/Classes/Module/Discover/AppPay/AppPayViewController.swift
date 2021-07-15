//
//  AppPayViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/9.
//

import UIKit

class AppPayViewController: BaseViewController {

    /**
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         WechatManager.shared.regist("", universalLink: "")
         return true
     }
     
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        PayManager.shared.processingResults(url)
        return true
     }
     */
}

// MARK: - LifeCyle
extension AppPayViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.discover_wechatPayAndAliPay.text
        
        // 不应该设置某个类未代理, 应该设置全局代理, 全局接收支付结果通知
        PayManager.shared.delegate = self
        
        // 微信支付
        WechatManager.shared.pay(PayWechatModel())
        // 支付宝支付
        AliManager.shared.pay(PayAliModel())
    }
}

/// 支付结果
extension AppPayViewController: PayResultProtocol {
    func paySuccess() {
        
    }
    
    func payFailure() {
        
    }
    
    func unKnow() {
        
    }
}
