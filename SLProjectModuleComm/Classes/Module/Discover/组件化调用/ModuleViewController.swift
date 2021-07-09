//
//  ModuleViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/9.
//

import UIKit
import CTMediator

class ModuleViewController: BaseViewController {

    private var naviTitle: String?
    
    init(_ title: String?) {
        super.init(nibName: nil, bundle: nil)
        naviTitle = title
    }
    required convenience init() {
        self.init("")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCyle
extension ModuleViewController {
    override func setMasterView() {
        super.setMasterView()
        title = naviTitle
    }
    
    override func setVisitorPage() {
        setMasterView()
    }
}

// MARK: - Guide
extension CTMediator {
    func moduleVC(title: String) -> ModuleViewController? {
        performTarget("Module", action: "ModuleViewController", params: ["title": title], shouldCacheTarget: false) as? ModuleViewController
    }
}

@objc(Target_Module)
class Target_Module: NSObject {
    @objc func Action_ModuleViewController(_ params: [String: Any]?) -> UIViewController {
        ModuleViewController(params?["title"] as? String)
    }
}
