//
//  Transition2ViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/7.
//

import UIKit

class Transition2ViewController: BaseViewController {

    @IBOutlet weak var topView: UIView! {
        didSet {
            topView.heroID = "showBtn2"
        }
    }
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.hero.modifiers = [.translate(y: 500), .useGlobalCoordinateSpace]
        }
    }
}

// MARK: - LifeCyle
extension Transition2ViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "转场动画详情页"
    }
}

// MARK: - Privater Methods
extension Transition2ViewController {
    override func bind() {
        super.bind()
    }
}

// MARK: - Event
extension Transition2ViewController {
    
}
