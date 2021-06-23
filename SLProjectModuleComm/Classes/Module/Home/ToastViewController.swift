//
//  ToastViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit
import PKHUD

class ToastViewController: BaseViewController {
    
    @IBAction func btn1Action(_ sender: UIButton) {
        HUD.flash(.label("提示内容..."), delay: 2.0)
    }
    @IBAction func btn2Action(_ sender: UIButton) {
        HUD.flash(.labeledSuccess(title: "成功", subtitle: "提交成功!"), delay: 2.0)
    }
    @IBAction func btn3Action(_ sender: UIButton) {
        HUD.flash(.labeledError(title: "失败", subtitle: "提交失败!"), delay: 2.0)
    }
    @IBAction func btn4Action(_ sender: UIButton) {
        HUD.show(.labeledProgress(title: "请求中", subtitle: "请稍候..."))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            HUD.flash(.labeledSuccess(title: "成功", subtitle: "提交成功!"), delay: 2.0)
        }
    }
    @IBAction func btn5Action(_ sender: UIButton) {
        HUD.flash(.labeledImage(image: R.image.cry100(), title: "成功", subtitle: "提交成功!"), delay: 2.0)
    }
}

// MARK: - LifeCyle
extension ToastViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "Toast"
    }
}
