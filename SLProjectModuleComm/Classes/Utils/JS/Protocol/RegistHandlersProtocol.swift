//
//  RegistHandlersProtocol.swift
//  FBMerchant
//
//  Created by 孙梁 on 2019/5/29.
//  Copyright © 2019 cn. All rights reserved.
//

import UIKit
import HandyJSON
import SLIKit

protocol RegistHandlersProtocol {
    /// JS调用native
    func registJSCallNavite()

    /// native调用JS
    /// 返回上一页
    func nativeBackClick()

    typealias Handler = WKWebViewJavascriptBridgeBase.Handler
    typealias Callback = WKWebViewJavascriptBridgeBase.Callback
}

extension RegistHandlersProtocol where Self: SLJSViewController {
    /// JS调用native
    func registJSCallNavite() {
        bridge.register(.openNativeByPageName) { [weak self] (parameters, callback) in
            self?.openNativeByPageName(parameters, callback: callback)
        }
        bridge.register(.setPageConfiger) { [weak self] (parameters, callback) in
            self?.setPageConfiger(parameters, callback: callback)
        }
        bridge.register(.htmlGoBack) { [weak self] (parameters, callback) in
            self?.htmlGoBack(parameters, callback: callback)
        }
        bridge.register(.storeDataToLoacl) { [weak self] (parameters, callback) in
            self?.storeDataToLoacl(parameters, callback: callback)
        }
        bridge.register(.deleteDataToLocal) { [weak self] (parameters, callback) in
            self?.deleteDataToLocal(parameters, callback: callback)
        }
        bridge.register(.requestDataFromLoacl) { [weak self] (parameters, callback) in
            self?.requestDataFromLoacl(parameters, callback: callback)
        }
        bridge.register(.getAppToken) { [weak self] (parameters, callback) in
            self?.getAppToken(parameters, callback: callback)
        }
        bridge.register(.saveImg) { [weak self] (parameters, callback) in
            self?.saveImg(parameters, callback: callback)
        }
        bridge.register(.share) { [weak self] (parameters, callback) in
            self?.share(parameters, callback: callback)
        }
        bridge.register(.logout) { [weak self] (parameters, callback) in
            self?.logout(parameters, callback: callback)
        }
        bridge.register(.talkWithIM) { [weak self] (parameters, callback) in
            self?.talkWithIM(parameters, callback: callback)
        }
        bridge.register(.wechatPay) { [weak self] (parameters, callback) in
            self?.wechatPay(parameters, callback: callback)
        }
        bridge.register(.getEnumDesc) { [weak self] (parameters, callback) in
            self?.getEnumDesc(parameters, callback: callback)
        }
    }
}

/// JS调用native
extension RegistHandlersProtocol where Self: SLJSViewController {
    /// 跳转原生页面
    private func openNativeByPageName(_ paramters: [String: Any]?, callback: Callback?) {
//        if let pageName = paramters?["pageName"] as? String,
//            let vc = pageName.fg_2VC as? FGJSNaviViewController {
//            vc.jsParameters = paramters?["parameters"] as? [String : Any]
//            vc.jsCallback = callback
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
    /// 页面设置
    private func setPageConfiger(_ paramters: [String: Any]?, callback: Callback?) {
        guard let model = PageConfigerElement.deserialize(from: paramters) else { return }

    }
    /// 返回上一页
    private func htmlGoBack(_ paramters: [String: Any]?, callback: Callback?) {
        guard let model = GoBackElement.deserialize(from: paramters) else { return }
        if !model.isNativePop { return }
        if model.popToRoot {
            dissmiss()
        } else {
            haveToRefresh?(model.haveToRefresh)
            dissmiss()
        }
    }
    /// 存数据
    private func storeDataToLoacl(_ paramters: [String: Any]?, callback: Callback?) {
        guard let model = StoreDataToLoaclElement.deserialize(from: paramters) else {
            callback?(["status": 1])
            return
        }
        JSDataManager.shared.save(key: model.keyStr, value: model.valueStr, foever: model.isFoever) { (isSuccess) in
            callback?(["status": isSuccess ? 0 : 1])
        }
    }
    /// 删数据
    private func deleteDataToLocal(_ paramters: [String: Any]?, callback: Callback?) {
        JSDataManager.shared.delete(key: paramters?["keyStr"] as? String) { (isSuccess) in
            callback?(["status": isSuccess ? 0 : 1])
        }
    }
    /// 取数据
    private func requestDataFromLoacl(_ paramters: [String: Any]?, callback: Callback?) {
        if let value = JSDataManager.shared.valueFor(key: paramters?["keyStr"] as? String) {
            callback?(["data": value, "status": 0])
        } else {
            callback?(["data": "", "status": 1])
        }
    }
    /// 给web传token
    private func getAppToken(_ paramters: [String: Any]?, callback: Callback?) {
        print("JS:取token")
        callback?(["token": AccountServicer.service.token])
    }
    /// 保存图片
    private func saveImg(_ paramters: [String: Any]?, callback: Callback?) {
//        if let imgData = paramters?["img"] as? String,
//            let img = imgData.string2Image() {
//            img.save2PhotoAlbum()
//        }
    }
    /// 分享
    private func share(_ paramters: [String: Any]?, callback: Callback?) {
        // FIXME: - 分享
    }
    /// 退出登录
    private func logout(_ paramters: [String: Any]?, callback: Callback?) {
//        UserDataManager.shared.logout()
    }
    /// IM聊天
    private func talkWithIM(_ paramters: [String: Any]?, callback: Callback?) {

    }
    /// 微信支付
    private func wechatPay(_ paramters: [String: Any]?, callback: Callback?) {
        // FIXME: - 微信支付
    }
    /// 取枚举
    private func getEnumDesc(_ paramters: [String: Any]?, callback: Callback?) {
//        guard let key = paramters?["enumName"] as? String,
//            let enums = FGDataManager.shared.getEnumWithKey(key) else {
//            callback?(nil)
//            return
//        }
//        var dict: [String: Any] = [:]
//        for item in enums {
//            if let key = item["val"] as? String,
//                let value = item["desc"] as? String {
//                dict[key] = value
//            }
//        }
//        callback?(dict)
    }
}

/// native调用JS
extension RegistHandlersProtocol where Self: SLJSViewController {
    /// 返回上一页
    func nativeBackClick() {
        bridge.call(.nativeBackClick, data: nil, callback: nil)
    }
}
