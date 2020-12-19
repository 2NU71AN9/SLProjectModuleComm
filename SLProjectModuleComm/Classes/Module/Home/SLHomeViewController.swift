//
//  SLHomeViewController.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/15.
//

import UIKit

class SLHomeViewController: BaseViewController {

}

// MARK: - LifeCyle
extension SLHomeViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "标题"
        naviBar.item1Title = "点击"
        naviBar.item1Event = { [weak self] in
            self?.click()
        }
    }
    
    private func click() {
        
    }
}
