//
//  SLLoginViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/21.
//

import UIKit

class SLLoginViewController: BaseViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func loginAction(_ sender: UIButton) {
        loginSuccess()
    }
}

extension SLLoginViewController {
    
    override func setMasterView() {
        super.setMasterView()
        title = "登录"
    }
    
    override func setVisitorPage() {
        setMasterView()
    }
}

// MARK: - private methods
extension SLLoginViewController {
    
    private func loginSuccess() {
        // 保存用户信息或token
        AccountServicer.service.saveToken("123")
        // 一定要调这句
        AccountServicer.service.loginSuccess()
        dismiss()
    }
    
    private func dismiss() {
        if navigationController?.presentingViewController != nil && presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else {
            UIApplication.shared.windows.last?.rootViewController = SLTabBar.customStyle()
        }
    }
}
