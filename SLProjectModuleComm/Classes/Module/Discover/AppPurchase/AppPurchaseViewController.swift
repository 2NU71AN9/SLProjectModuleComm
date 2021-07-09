//
//  AppPurchaseViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/9.
//

import UIKit
import SLIKit

class AppPurchaseViewController: BaseViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    @IBAction func btnClick(_ sender: UIButton) {
        AppPurchaseManager.shared.purchaseProduct("") { product, error in
            SLHUD.showToast(product != nil ? "购买成功" : "购买失败")
        }
    }
}

// MARK: - LifeCyle
extension AppPurchaseViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "App内购"
        
        AppPurchaseManager.shared.getProductList(ids: ["jb01", "jb02"]) { _, _ in
            
        }
    }
}

// MARK: - Privater Methods
extension AppPurchaseViewController {
    override func bind() {
        super.bind()
    }
}

// MARK: - Event
extension AppPurchaseViewController {
    
}
