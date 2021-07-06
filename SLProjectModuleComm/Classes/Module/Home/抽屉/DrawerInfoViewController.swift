//
//  DrawerInfoViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/6.
//

import UIKit

class DrawerInfoViewController: BaseViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - LifeCyle
extension DrawerInfoViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "新页面"
    }
}
