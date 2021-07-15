//
//  PopMenuCustomViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/1.
//

import UIKit
import PopMenu

class PopMenuCustomViewController: BaseViewController {
    
    private lazy var item1 = UIKeyCommand(title: "第一个",
                                          action: #selector(item1Action),
                                          input: "a",
                                          modifierFlags: .command)

    private lazy var item2 = UIKeyCommand(title: "第二个",
                                          action: #selector(item2Action),
                                          input: "b",
                                          modifierFlags: .command)
    
    private lazy var item3 = UIKeyCommand(title: "第三个",
                                          action: #selector(item3Action),
                                          input: "c",
                                          modifierFlags: .command)

    private lazy var item4 = UIKeyCommand(title: "第四个",
                                          action: #selector(item4Action),
                                          input: "d",
                                          modifierFlags: .command)
    
    @IBOutlet weak var popBtn: UIButton!
    @IBOutlet weak var sysBtn1: UIButton! {
        didSet {
            if #available(iOS 14.0, *) {
                sysBtn1.showsMenuAsPrimaryAction = true
                let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [item3, item4])
                sysBtn1.menu = UIMenu(title: "这是标题", image: nil, identifier: nil, options: .displayInline, children: [item1, item2, menu])
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @IBOutlet weak var sysBtn2: UIButton! {
        didSet {
            if #available(iOS 14.0, *) {
                sysBtn2.showsMenuAsPrimaryAction = true
                sysBtn2.menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [item1, item2, item3, item4])
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBAction func popBtnAction(_ sender: UIButton) {
        showMenu2()
    }
    @IBAction func sysBtn1Action(_ sender: UIButton) {
        
    }
    @IBAction func sysBtn2Action(_ sender: UIButton) {
        
    }
}

// MARK: - LifeCyle
extension PopMenuCustomViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.home_popMenu.text
        naviBar.item1Title = "点击"
        naviBar.item1Event = { [weak self] in
            self?.showMenu1()
        }
    }
    
    override func setVisitorPage() {
        setMasterView()
    }
}

// MARK: - Event
extension PopMenuCustomViewController {
    private func showMenu1() {
        let menu = PopMenuViewController(sourceView: naviBar.item1,
                                         actions: [], appearance: nil)
        let action1 = PopMenuDefaultAction(title: "标题1", image: R.image.cry100(), color: .red) { _ in
            print("标题1")
        }
        action1.imageRenderingMode = .alwaysOriginal
        menu.addAction(action1)
        
        let action2 = PopMenuDefaultAction(title: "标题2", image: R.image.cry100(), color: .yellow) { _ in
            print("标题2")
        }
        action2.imageRenderingMode = .alwaysOriginal
        menu.addAction(action2)
        
        let action3 = PopMenuDefaultAction(title: "标题3", image: R.image.cry100(), color: .orange) { _ in
            print("标题3")
        }
        action3.imageRenderingMode = .alwaysOriginal
        menu.addAction(action3)
        
        present(menu, animated: true, completion: nil)
    }
    
    private func showMenu2() {
        let action1 = PopMenuDefaultAction(title: "标题1", image: R.image.cry100(), color: .red) { _ in
            print("标题1")
        }
        action1.imageRenderingMode = .alwaysOriginal
        
        let action2 = PopMenuDefaultAction(title: "标题2", image: R.image.cry100(), color: .yellow) { _ in
            print("标题2")
        }
        action2.imageRenderingMode = .alwaysOriginal
        
        let action3 = PopMenuDefaultAction(title: "标题3", image: R.image.cry100(), color: .orange) { _ in
            print("标题3")
        }
        action3.imageRenderingMode = .alwaysOriginal
        
        PopMenuManager.default.actions = [action1, action2, action3]
        PopMenuManager.default.present(sourceView: popBtn)
    }
    
    @objc private func item1Action() {
        
    }
    @objc private func item2Action() {
        
    }
    @objc private func item3Action() {
        
    }
    @objc private func item4Action() {
        
    }
}
