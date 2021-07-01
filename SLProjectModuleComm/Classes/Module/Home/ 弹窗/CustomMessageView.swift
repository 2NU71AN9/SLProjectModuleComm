//
//  CustomMessageView.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/1.
//

import UIKit
import SwiftMessages

public class CustomMessageView: MessageView {
    
    public var title: String? {
        didSet {
            customTitleLabel.isHidden = title == nil || title?.count == 0
            customTitleLabel.text = title
        }
    }
    public var desc: String? {
        didSet {
            descLabel.isHidden = desc == nil || desc?.count == 0
            descLabel.text = desc
        }
    }
    public var cancelTitle: String? {
        didSet {
            cancelBtn.isHidden = cancelTitle == nil || cancelTitle?.count == 0
            cancelBtn.setTitle(cancelTitle, for: .normal)
        }
    }
    public var confirmTitle: String? {
        didSet {
            confirmBtn.isHidden = confirmTitle == nil || confirmTitle?.count == 0
            confirmBtn.setTitle(confirmTitle, for: .normal)
        }
    }
    public var cancelEvent: (() -> Void)?
    public var confrimEvent: (() -> Void)?
    
    @IBOutlet weak var customTitleLabel: UILabel! {
        didSet {
            customTitleLabel.isHidden = title == nil || title?.count == 0
        }
    }
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            descLabel.isHidden = desc == nil || desc?.count == 0
        }
    }
    @IBOutlet weak var cancelBtn: UIButton! {
        didSet {
            cancelBtn.isHidden = cancelTitle == nil || cancelTitle?.count == 0
        }
    }
    @IBOutlet weak var confirmBtn: UIButton! {
        didSet {
            confirmBtn.isHidden = confirmTitle == nil || confirmTitle?.count == 0
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        SwiftMessages.hide()
        cancelEvent?()
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        SwiftMessages.hide()
        confrimEvent?()
    }
    
    public static func loadView(title: String?, desc: String?, cancelTitle: String?, confirmTitle: String?, cancel: (() -> Void)?, confirm: (() -> Void)?) -> CustomMessageView {
        let view = CustomMessageView.sl.loadNib()?.base
        view?.configureDropShadow()
        view?.title = title
        view?.desc = desc
        view?.cancelTitle = cancelTitle
        view?.confirmTitle = confirmTitle
        view?.cancelEvent = cancel
        view?.confrimEvent = confirm
        return view ?? CustomMessageView()
    }
}
