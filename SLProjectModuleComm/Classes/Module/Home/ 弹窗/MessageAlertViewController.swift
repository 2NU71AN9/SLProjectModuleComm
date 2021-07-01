//
//  MessageAlertViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/1.
//

import UIKit
import SwiftMessages

class MessageAlertViewController: BaseViewController {
    @IBAction func style1Action(_ sender: UIButton) {
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: "Error", body: "Something is horribly wrong!")
        error.button?.setTitle("Stop", for: .normal)
        SwiftMessages.show(view: error)
    }
    @IBAction func style2Action(_ sender: UIButton) {
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
        warning.configureContent(title: "Warning", body: "Consider yourself warned.", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
    @IBAction func style3Action(_ sender: UIButton) {
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: "Success", body: "Something good happened!")
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .center
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: successConfig, view: success)
    }
    @IBAction func style4Action(_ sender: UIButton) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.button?.isHidden = true
        info.configureContent(title: "Info", body: "This is a very lengthy and informative info message that wraps across multiple lines and grows in height as needed.")
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .bottom
        infoConfig.duration = .seconds(seconds: 0.25)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    @IBAction func style5Action(_ sender: UIButton) {
        let status = MessageView.viewFromNib(layout: .statusLine)
        status.backgroundView.backgroundColor = UIColor.purple
        status.bodyLabel?.textColor = UIColor.white
        status.configureContent(body: "A tiny line of text covering the status bar.")
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: statusConfig, view: status)
    }
    @IBAction func customViewAction(_ sender: UIButton) {
        let view = CustomMessageView.loadView(title: "标题", desc: "详细内容", cancelTitle: "取消", confirmTitle: "确定") {
            print("取消")
        } confirm: {
            print("确定")
        }
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
}

// MARK: - LifeCyle
extension MessageAlertViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "弹窗"
    }
    
    override func setVisitorPage() {
        setMasterView()
    }
}

// MARK: - Privater Methods
extension MessageAlertViewController {
    override func bind() {
        super.bind()
    }
}

// MARK: - Event
extension MessageAlertViewController {
    
}
