//
//  CustomNavigationViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/3.
//

import UIKit
import SLIKit

class CustomNavigationViewController: BaseViewController {

    @IBAction func sw1Click(_ sender: UISwitch) {
        naviBarHidden = !sender.isOn
    }
    @IBAction func sw2Click(_ sender: UISwitch) {
        naviBar.effect = sender.isOn
    }
    @IBAction func sw3Click(_ sender: UISwitch) {
        naviBar.item1Title = sender.isOn ? "按钮1" : nil
    }
    @IBAction func sw4Click(_ sender: UISwitch) {
        naviBar.item2Image = sender.isOn ? R.image.tab1_selected() : nil
    }
    @IBAction func sw5Click(_ sender: UISwitch) {
        naviBar.item3Title = sender.isOn ? "按钮3" : nil
    }
    @IBAction func btnClick(_ sender: UIButton) {
        naviBar.barColor = UIColor.sl.random
    }
}

// MARK: - LifeCyle
extension CustomNavigationViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.home_customNavigation.text
        naviBar.item1Title = "按钮1"
        naviBar.item2Image = R.image.tab1_selected()
        naviBar.item3Title = "按钮3"
        
        naviBar.item1Event = { SLHUD.message(title: nil, desc: "item1") }
        naviBar.item2Event = { SLHUD.message(title: nil, desc: "item2") }
        naviBar.item3Event = { SLHUD.message(title: nil, desc: "item3") }
    }
}
