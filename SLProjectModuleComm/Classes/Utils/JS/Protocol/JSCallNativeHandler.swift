//
//  JSCallNativeHandler.swift
//  FBMerchant
//
//  Created by 孙梁 on 2019/5/29.
//  Copyright © 2019 cn. All rights reserved.
//

import UIKit

/// JS调native
enum JSCallNativeEnum: String {
    /// 跳转原生页面
    case openNativeByPageName = "openNativeByPageName"
    /// 页面设置
    case setPageConfiger = "setPageConfiger"
    /// 返回上一页
    case htmlGoBack = "htmlGoBack"
    /// 刷新页面
    case refreshPage = "refreshPage"
    /// 存数据
    case storeDataToLoacl = "storeDataToLocal"
    /// 删数据
    case deleteDataToLocal = "deleteDataToLocal"
    /// 取数据
    case requestDataFromLoacl = "requestDataFromLocal"
    /// 给web传token
    case getAppToken = "getAppToken"
    /// 保存图片
    case saveImg = "saveImg"
    /// 分享
    case share = "share"
    /// 退出登录
    case logout = "logout"
    /// IM聊天
    case talkWithIM = "talkWithIM"
    /// 微信支付
    case wechatPay = "wechatPay"
    /// 取枚举
    case getEnumDesc = "getEnumDesc"
}

extension WKWebViewJavascriptBridge {
    func register(_ handlerEnum: JSCallNativeEnum, handler: @escaping WKWebViewJavascriptBridgeBase.Handler) {
        register(handlerName: handlerEnum.rawValue) { (parameters, callback) in
            handler(parameters) { data in
                callback?(data)
            }
        }
//        register(handlerName: handlerEnum.rawValue, handler: handler)
    }
    func call(_ handlerEnum: NativeCallJSEnum, data: Any?, callback: WKWebViewJavascriptBridgeBase.Callback?) {
        call(handlerName: handlerEnum.rawValue, data: data, callback: callback)
    }
}
