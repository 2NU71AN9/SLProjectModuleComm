//
//  DrawerViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/6.
//

import UIKit
import SideMenu
class DrawerViewController: BaseViewController {
    
    private lazy var leftMenu: SideMenuNavigationController = {
        let vc = DrawerLeftViewController()
        let presentationStyle: SideMenuPresentationStyle = .menuSlideIn
        presentationStyle.backgroundColor = .clear // UIColor(patternImage: R.image.cry100()!)
        presentationStyle.menuStartAlpha = 1
        presentationStyle.presentingEndAlpha = 0.5

        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(view.frame.width, view.frame.height) * 0.7
        settings.blurEffectStyle = .regular
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.settings = settings
        return menu
    }()
    private lazy var rightMenu: SideMenuNavigationController = {
        let vc = DrawerLeftViewController()
        let presentationStyle: SideMenuPresentationStyle = .viewSlideOutMenuIn
        presentationStyle.backgroundColor = .clear // .clear 可解决push时的闪烁问题
        presentationStyle.menuStartAlpha = 1
        presentationStyle.presentingEndAlpha = 0.5

        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(view.frame.width, view.frame.height) * 0.7
        settings.blurEffectStyle = nil
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.settings = settings
        return menu
    }()
    
    @IBAction func leftAction(_ sender: UIButton) {
        present(leftMenu, animated: true, completion: nil)
    }
    @IBAction func rightAction(_ sender: UIButton) {
        present(rightMenu, animated: true, completion: nil)
    }
}

// MARK: - LifeCyle
extension DrawerViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "抽屉"
        
        SideMenuManager.default.leftMenuNavigationController = leftMenu
        SideMenuManager.default.rightMenuNavigationController = rightMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
}
