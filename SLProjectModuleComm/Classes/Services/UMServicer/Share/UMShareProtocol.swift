//
//  UMShareProtocol.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/17.
//

import UIKit
import SLSupportLibrary
import PKHUD

protocol UMShareProtocol {
    func confitShareSettings()
    
    func shareText(_ text: String, success: (() -> Void)?, failure: (() -> Void)?)
    func shareMiniApp(path: String?, success: (() -> Void)?, failure: (() -> Void)?)
    // 可以添加其他分享内容
}

extension UMShareProtocol where Self: SLUMServicer {
    func confitShareSettings() {
        UMSocialGlobal.shareInstance()?.isUsingWaterMark = true // 水印
        UMSocialGlobal.shareInstance()?.isUsingHttpsWhenShareContent = false // 可以分享http图片
        UMSocialGlobal.shareInstance()?.universalLinkDic = [UMSocialPlatformType.wechatSession: universalLink]
        /*设置小程序回调app的回调*/
        UMSocialManager.default()?.setLauchFrom(.wechatSession) { (userInfoResponse, _) in
            print("setLauchFromPlatform:userInfoResponse:\(String(describing: userInfoResponse))")
        }
        
        // 设置分享面板
        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: AppID_wechat, appSecret: AppSecret_wechat, redirectURL: "")
        UMSocialManager.default()?.removePlatformProvider(with: .wechatFavorite)
        
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.shareContainerBackgroundColor = ColorBox.text_gray1.color
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.isShareContainerHaveGradient = false
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.shareContainerCornerRadius = 20
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.shareContainerMarginTop = 20
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.shareContainerMarginBottom = 20
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewBackgroundColor = .clear
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewPageBGColor = .clear
        UMSocialShareUIConfig.shareInstance()?.shareTitleViewConfig.isShow = false
        UMSocialShareUIConfig.shareInstance()?.sharePageControlConfig.isShow = false
        UMSocialShareUIConfig.shareInstance()?.shareCancelControlConfig.isShow = false
    }
    
    func shareText(_ text: String, success: (() -> Void)?, failure: (() -> Void)?) {
        UMSocialUIManager.showShareMenuViewInWindow { (platform, _) in
            let messageObject = UMSocialMessageObject()
            let shareMessage = UMShareObject.shareObject(withTitle: text, descr: nil, thumImage: nil)
            messageObject.shareObject = shareMessage
            UMSocialManager.default()?.share(to: platform, messageObject: messageObject, currentViewController: cur_visible_vc) { (_, error) in
                if error == nil {
                    HUD.flash(.label("分享成功"), delay: 1.5, completion: nil)
                    success?()
                } else {
                    HUD.flash(.label("分享失败"), delay: 1.5, completion: nil)
                    failure?()
                }
            }
        }
    }
    
    func shareMiniApp(path: String?, success: (() -> Void)?, failure: (() -> Void)?) {
        let messageObject = UMSocialMessageObject()
        let shareMessage = UMShareMiniProgramObject.shareObject(withTitle: "", descr: "", thumImage: nil) as? UMShareMiniProgramObject
        shareMessage?.webpageUrl = MiniApp_webpageUrl
        shareMessage?.userName = MiniApp_userName
        shareMessage?.path = path
        shareMessage?.miniProgramType = .release
        messageObject.shareObject = shareMessage
        UMSocialManager.default()?.share(to: .wechatSession, messageObject: messageObject, currentViewController: cur_visible_vc) { (_, error) in
            if error == nil {
                HUD.flash(.label("分享成功"), delay: 1.5, completion: nil)
                success?()
            } else {
                HUD.flash(.label("分享失败"), delay: 1.5, completion: nil)
                failure?()
            }
        }
    }
}
