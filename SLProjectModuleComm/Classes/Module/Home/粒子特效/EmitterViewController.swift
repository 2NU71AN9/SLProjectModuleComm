//
//  EmitterViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/8.
//

import UIKit
import SLIKit

class EmitterViewController: BaseViewController {
    
    @IBAction func btn1Click(_ sender: Any) {
        let vc = Emitter1ViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn2Click(_ sender: Any) {
        let vc = Emitter2ViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - LifeCyle
extension EmitterViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.home_emitter.text
    }
}
