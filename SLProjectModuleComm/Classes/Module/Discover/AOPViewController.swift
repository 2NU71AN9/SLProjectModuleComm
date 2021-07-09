//
//  AOPViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/9.
//

import UIKit
import Aspects

class AOPViewController: BaseViewController {
    
    @IBOutlet weak var label: UILabel!
    
    private var text: String = "" {
        didSet {
            label.text = text
        }
    }
}

// MARK: - LifeCyle
extension AOPViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "AOP"
    }
}

// MARK: - Privater Methods
extension AOPViewController {
    override func bind() {
        super.bind()
        intercepter()
        eat()
    }
    
    private func intercepter() {
        let before: @convention(block) (Any?) -> Void = { info in
            if let aspectInfo = info as? AspectInfo,
               let controller = aspectInfo.instance() as? AOPViewController {
                controller.cook()
            }
        }
        do {
            try aspect_hook(NSSelectorFromString("eat"), with: .positionBefore, usingBlock: unsafeBitCast(before, to: Self.self))
        } catch {
            print(error)
        }
        
        let after: @convention(block) (Any?) -> Void = { info in
            if let aspectInfo = info as? AspectInfo,
               let controller = aspectInfo.instance() as? AOPViewController {
                controller.wash()
            }
        }
        do {
            try aspect_hook(NSSelectorFromString("eat"), with: [], usingBlock: unsafeBitCast(after, to: Self.self))
        } catch {
            print(error)
        }
    }
}

extension AOPViewController {
    private func cook() {
        text += "\n做饭......"
    }
    @objc private func eat() {
        text += "\n吃饭......"
    }
    private func wash() {
        text += "\n洗碗......"
    }
}
