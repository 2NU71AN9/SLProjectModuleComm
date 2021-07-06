//
//  DrawerLeftViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/6.
//

import UIKit

class DrawerLeftViewController: BaseViewController {
    
    @IBAction func pushAction(_ sender: UIButton) {
        let vc = DrawerInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func presentAction(_ sender: UIButton) {
        let vc = DrawerInfoViewController()
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - LifeCyle
extension DrawerLeftViewController {
    override func setMasterView() {
        super.setMasterView()
        naviBarHidden = true
    }
}
