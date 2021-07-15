//
//  FaceIDViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/30.
//

import UIKit
import SLIKit

class FaceIDViewController: BaseViewController {
    
    private let manager = SLFaceIDWithTouchIDManager()
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func click(_ sender: UIButton) {
        manager.evaluate(canPassword: true) { [weak self] success, error in
            if success {
                self?.label.text = "验证成功"
            } else {
                self?.label.text = error?.descText
            }
        }
    }
}

// MARK: - LifeCyle
extension FaceIDViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.home_faceId_TouchID.text
        if let error = manager.isValid() {
            label.text = error.descText
        }
    }
}
