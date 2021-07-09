//
//  StringInterpolationViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/9.
//

import UIKit
import SLIKit

class StringInterpolationViewController: BaseViewController {

    @IBOutlet weak var label: UILabel!
}

// MARK: - LifeCyle
extension StringInterpolationViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "字符串插值"
        let str: ColorString = "字符串插值: \(message: "这是红色", color: .red, font: label.font)\(message: "这是绿色", color: .green, font: label.font)\(message: "这是蓝色", color: .blue, font: label.font)"
        label.attributedText = str.value
    }
}
