//
//  TapticViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit
import Haptica

class TapticViewController: BaseViewController {
    
    @IBAction func btn1Action(_ sender: UIButton) {
        Haptic.impact(.soft).generate()
    }
    @IBAction func btn2Action(_ sender: UIButton) {
        Haptic.impact(.light).generate()
    }
    @IBAction func btn3Action(_ sender: UIButton) {
        Haptic.impact(.medium).generate()
    }
    @IBAction func btn4Action(_ sender: UIButton) {
        Haptic.impact(.heavy).generate()
    }
    @IBAction func btn5Action(_ sender: UIButton) {
        Haptic.impact(.rigid).generate()
    }
    @IBAction func btn6Action(_ sender: UIButton) {
        Haptic.notification(.success).generate()
    }
    @IBAction func btn7Action(_ sender: UIButton) {
        Haptic.notification(.warning).generate()
    }
    @IBAction func btn8Action(_ sender: UIButton) {
        Haptic.notification(.error).generate()
    }
    @IBAction func btn9Action(_ sender: UIButton) {
        Haptic.play("..oO-Oo..", delay: 0.1)
    }

}
