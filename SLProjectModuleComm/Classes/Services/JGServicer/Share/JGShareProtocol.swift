//
//  JGShareProtocol.swift
//  SLJGServicer
//
//  Created by 孙梁 on 2021/1/8.
//

import UIKit
import SLIKit

public protocol JGShareProtocol {
    /// 注册, universalLink必须与微信开放平台设置的一样
    func registShare(appKey: String, universalLink: String, wechatAppId: String, wechatAppSecret: String) -> Self
    /// 获取用户在第三方平台的用户 ID、头像等资料完成账号体系的构建
    func getSocialUserInfo(platform: JSHAREPlatform, complete: @escaping ((JSHARESocialUserInfo?) -> Void))
    /// 分享
    func shareText(_ text: String?, complete: ((Bool) -> Void)?)
    func shareImage(_ image: Any?, complete: ((Bool) -> Void)?)
    func shareUrl(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?)
    func shareVideo(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?)
    func shareAudio(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?)
    // type 0正式版，1开发版，2体验版。默认0，正式版
    func shareMiniApp(title: String, text: String?, url: String, userName: String, path: String, type: Int?, image: Any?, complete: ((Bool) -> Void)?)
    /// 可以添加各种分享内容的方法
}

public extension JGShareProtocol where Self: SLJGServicer {
    @discardableResult
    func registShare(appKey: String, universalLink: String, wechatAppId: String, wechatAppSecret: String) -> Self {
        let config = JSHARELaunchConfig()
        config.appKey = appKey
        config.channel = "App Store"
        config.isProduction = true
        #if DEBUG
        config.isProduction = false
        #endif
        config.weChatAppId = wechatAppId
        config.weChatAppSecret = wechatAppSecret
        config.jChatProAuth = ""
        config.universalLink = universalLink
        JSHAREService.setup(with: config)
        #if DEBUG
        JSHAREService.setDebug(true)
        #endif
        return self
    }
    
    func getSocialUserInfo(platform: JSHAREPlatform, complete: @escaping ((JSHARESocialUserInfo?) -> Void)) {
        JSHAREService.getSocialUserInfo(platform) { (userinfo, _) in
            complete(userinfo)
        }
    }
    
    func shareText(_ text: String?, complete: ((Bool) -> Void)?) {
        guard let text = text else { return }
        let message = JSHAREMessage()
        message.text = text
        message.mediaType = .text
        share(message, complete: complete)
    }
    func shareImage(_ image: Any?, complete: ((Bool) -> Void)?) {
        guard let image = image2Data(image) else { return }
        let message = JSHAREMessage()
        message.image = image
        message.mediaType = .image
        share(message, complete: complete)
    }
    func shareUrl(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?) {
        let message = JSHAREMessage()
        message.url = url
        message.title = title
        message.text = text
        message.image = image2Data(image)
        message.mediaType = .link
        share(message, complete: complete)
    }
    func shareVideo(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?) {
        let message = JSHAREMessage()
        message.url = url
        message.title = title
        message.text = text
        message.image = image2Data(image)
        message.mediaType = .video
        share(message, complete: complete)
    }
    func shareAudio(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?) {
        let message = JSHAREMessage()
        message.url = url
        message.title = title
        message.text = text
        message.image = image2Data(image)
        message.mediaType = .audio
        share(message, complete: complete)
    }
    func shareMiniApp(title: String, text: String?, url: String, userName: String, path: String, type: Int?, image: Any?, complete: ((Bool) -> Void)?) {
        guard let image = image2Data(image) else { return }
        let message = JSHAREMessage()
        message.mediaType = .miniProgram
        message.title = title
        message.text = text
        message.url = url
        message.userName = userName
        message.path = path
        message.miniProgramType = Int32(type ?? 0)
        message.image = image
        message.platform = .wechatSession
        share(message, complete: complete)
    }
    
    private func share(_ message: JSHAREMessage, complete: ((Bool) -> Void)?) {
        
        func share() {
            JSHAREService.share(message) { (state, _) in
                SLHUD.message(desc: state == .success ? "分享成功" : "分享失败")
                complete?(state == .success)
            }
        }
        
        if message.platform.rawValue != 0 {
            share()
        } else {
            JGSharePlatformPicker { platform in
                message.platform = platform
                share()
            }.show()
        }
    }
    
    private func image2Data(_ image: Any?) -> Data? {
        guard let image = image else { return nil }
        if let image = image as? UIImage {
            return image.pngData() ?? image.jpegData(compressionQuality: 1.0)
        } else if let image = image as? String, let imageUrl = URL(string: image) {
            return try? Data(contentsOf: imageUrl)
        } else if let image = image as? URL {
            return try? Data(contentsOf: image)
        }
        return nil
    }
}
