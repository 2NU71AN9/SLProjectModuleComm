//
//  SLLoginViewController.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/12.
//

import UIKit

class SLLoginViewController: BaseViewController {
    
}

extension SLLoginViewController {
    
    override func setMasterView() {
        super.setMasterView()
        title = "登录"
        
    }
    
    override func setVisitorPage() {
        setMasterView()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        loginSuccess()
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
            UIApplication.shared.keyWindow?.rootViewController = SLTabBar.customStyle()
        }
    }
}
