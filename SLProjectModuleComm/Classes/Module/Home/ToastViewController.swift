//
//  ToastViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit
import SLIKit

class ToastViewController: BaseViewController {
    
    private var timer: Timer?
    
    @IBAction func btn1Action(_ sender: UIButton) {
        SLHUD.toast("提示内容提示内容提示内容提示内容提示内容提示内容提示内容提示内容")
    }
    @IBAction func btn2Action(_ sender: UIButton) {
        SLHUD.message(title: "标题", desc: "这是提示内容...")
    }
    @IBAction func btn3Action(_ sender: UIButton) {
        SLHUD.loading("加载中...")
        SL.delay(second: 2) {
            SLHUD.dismissLoadingOrProgress()
        }
    }
    @IBAction func btn4Action(_ sender: UIButton) {
        timer?.invalidate()
        timer = nil

        var intervalCount: CGFloat = 0.0
        SLHUD.progress(intervalCount / 100)

        timer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { [weak self] timer in
            intervalCount += 1
            if intervalCount == 100 {
                self?.timer?.invalidate()
                self?.timer = nil
            }
            SLHUD.progress(intervalCount / 100)
        }
    }
}

// MARK: - LifeCyle
extension ToastViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.home_toast.text
    }
}
