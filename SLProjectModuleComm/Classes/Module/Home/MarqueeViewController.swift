//
//  MarqueeViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/30.
//

import UIKit
import MarqueeLabel

class MarqueeViewController: BaseViewController {
    
    @IBOutlet weak var label1: MarqueeLabel! {
        didSet {
            label1.type = .left
        }
    }
    @IBOutlet weak var label2: MarqueeLabel! {
        didSet {
            label2.type = .leftRight
        }
    }
    @IBOutlet weak var label3: MarqueeLabel! {
        didSet {
            label3.type = .continuous
        }
    }
    @IBOutlet weak var label4: MarqueeLabel! {
        didSet {
            label4.type = .continuousReverse
        }
    }
}

// MARK: - LifeCyle
extension MarqueeViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "跑马灯"
    }
}
