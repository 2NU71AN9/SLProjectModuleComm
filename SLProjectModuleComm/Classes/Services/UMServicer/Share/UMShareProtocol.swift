//
//  UMShareProtocol.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/17.
//

import UIKit
import SLIKit
import PKHUD

protocol UMShareProtocol {
    func registShare(wechatAppId: String, wechatAppSecret: String, universalLink: String) -> Self
    
    func shareText(_ text: String?, complete: ((Bool) -> Void)?)
    func shareImage(_ image: Any?, complete: ((Bool) -> Void)?)
    func shareUrl(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?)
    func shareVideo(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?)
    func shareAudio(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?)
    func shareMiniApp(title: String, text: String?, url: String, userName: String, path: String, type: UShareWXMiniProgramType, image: Any?, complete: ((Bool) -> Void)?)
    // 可以添加其他分享内容
}

extension UMShareProtocol where Self: SLUMServicer {
    
    @discardableResult
    func registShare(wechatAppId: String, wechatAppSecret: String, universalLink: String) -> Self {
        UMSocialGlobal.shareInstance()?.isUsingWaterMark = false // 水印
        UMSocialGlobal.shareInstance()?.isUsingHttpsWhenShareContent = false // 可以分享http图片
        UMSocialGlobal.shareInstance()?.universalLinkDic = [UMSocialPlatformType.wechatSession.rawValue: universalLink]
        
        UMSocialManager.default()?.openLog(true)
        /*设置小程序回调app的回调*/
        UMSocialManager.default()?.setLauchFrom(.wechatSession) { (userInfoResponse, _) in
            print("setLauchFromPlatform:userInfoResponse:\(String(describing: userInfoResponse))")
        }
        
        // 设置分享面板
        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: wechatAppId, appSecret: wechatAppSecret, redirectURL: "")
        UMSocialManager.default()?.removePlatformProvider(with: .wechatFavorite)
        
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.shareContainerBackgroundColor = UIColor(named: "text_gray1")
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.isShareContainerHaveGradient = false
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.shareContainerCornerRadius = 20
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.shareContainerMarginTop = 20
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.shareContainerMarginBottom = 20
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewBackgroundColor = .clear
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewPageBGColor = .clear
        UMSocialShareUIConfig.shareInstance()?.shareTitleViewConfig.isShow = false
        UMSocialShareUIConfig.shareInstance()?.sharePageControlConfig.isShow = false
        UMSocialShareUIConfig.shareInstance()?.shareCancelControlConfig.isShow = false
        return self
    }
    
    func shareText(_ text: String?, complete: ((Bool) -> Void)?) {
        guard let text = text else { return }
        UMSocialUIManager.showShareMenuViewInWindow { (platform, _) in
            let message = UMSocialMessageObject()
            message.text = text
            UMSocialManager.default()?.share(to: platform, messageObject: message, currentViewController: SL.visibleVC) { (_, error) in
                HUD.flash(.label(error == nil ? "分享成功" : "分享失败"), delay: 1.5, completion: nil)
                complete?(error == nil)
            }
        }
    }
    func shareImage(_ image: Any?, complete: ((Bool) -> Void)?) {
        guard let image = image else { return }
        UMSocialUIManager.showShareMenuViewInWindow { (platform, _) in
            let message = UMSocialMessageObject()
            let object = UMShareImageObject()
            object.shareImage = image
            message.shareObject = object
            UMSocialManager.default()?.share(to: platform, messageObject: message, currentViewController: SL.visibleVC) { (_, error) in
                HUD.flash(.label(error == nil ? "分享成功" : "分享失败"), delay: 1.5, completion: nil)
                complete?(error == nil)
            }
        }
    }
    func shareUrl(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?) {
        UMSocialUIManager.showShareMenuViewInWindow { (platform, _) in
            let message = UMSocialMessageObject()
            let object = UMShareWebpageObject()
            object.webpageUrl = url
            object.title = title
            object.descr = text
            object.thumbImage = image
            message.shareObject = object
            UMSocialManager.default()?.share(to: platform, messageObject: message, currentViewController: SL.visibleVC) { (_, error) in
                HUD.flash(.label(error == nil ? "分享成功" : "分享失败"), delay: 1.5, completion: nil)
                complete?(error == nil)
            }
        }
    }
    func shareVideo(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?) {
        UMSocialUIManager.showShareMenuViewInWindow { (platform, _) in
            let message = UMSocialMessageObject()
            let object = UMShareVideoObject()
            object.videoUrl = url
            object.title = title
            object.descr = text
            object.thumbImage = image
            message.shareObject = object
            UMSocialManager.default()?.share(to: platform, messageObject: message, currentViewController: SL.visibleVC) { (_, error) in
                HUD.flash(.label(error == nil ? "分享成功" : "分享失败"), delay: 1.5, completion: nil)
                complete?(error == nil)
            }
        }
    }
    func shareAudio(_ url: String, title: String?, text: String?, image: Any?, complete: ((Bool) -> Void)?) {
        UMSocialUIManager.showShareMenuViewInWindow { (platform, _) in
            let message = UMSocialMessageObject()
            let object = UMShareMusicObject()
            object.musicUrl = url
            object.title = title
            object.descr = text
            object.thumbImage = image
            message.shareObject = object
            UMSocialManager.default()?.share(to: platform, messageObject: message, currentViewController: SL.visibleVC) { (_, error) in
                HUD.flash(.label(error == nil ? "分享成功" : "分享失败"), delay: 1.5, completion: nil)
                complete?(error == nil)
            }
        }
    }
    // type 0正式版，1开发版，2体验版。默认0，正式版
    func shareMiniApp(title: String, text: String?, url: String, userName: String, path: String, type: UShareWXMiniProgramType, image: Any?, complete: ((Bool) -> Void)?) {
        let messageObject = UMSocialMessageObject()
        let shareMessage = UMShareMiniProgramObject.shareObject(withTitle: title, descr: text, thumImage: image) as? UMShareMiniProgramObject
        shareMessage?.webpageUrl = url
        shareMessage?.userName = userName
        shareMessage?.path = path
        shareMessage?.miniProgramType = type
        messageObject.shareObject = shareMessage
        UMSocialManager.default()?.share(to: .wechatSession, messageObject: messageObject, currentViewController: SL.visibleVC) { (_, error) in
            HUD.flash(.label(error == nil ? "分享成功" : "分享失败"), delay: 1.5, completion: nil)
            complete?(error == nil)
        }
    }
}
