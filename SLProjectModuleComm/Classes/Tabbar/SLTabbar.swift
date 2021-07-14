//
//  SLTabbar.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/12.
//

import UIKit
import RxSwift
import ESTabBarController_swift
import pop
import SLIKit
import Haptica

class SLESTabBarController: ESTabBarController {
    private let bag = DisposeBag()
    required init() {
        super.init(nibName: nil, bundle: nil)
        AccountServicer.service.haveToLogoutSubject
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] (_) in
                let vc = BaseNavigationController(rootViewController: SLLoginViewController())
//                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true) {
                    AccountServicer.service.haveToLogoutSubject.accept(PublishSubject<Bool>())
                }
            }).disposed(by: bag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SLTabBar {
    static func customStyle() -> ESTabBarController {
        let tabBarController = SLESTabBarController()
//        tabBarController.tabBar.isTranslucent = false
//        tabBarController.tabBar.shadowImage = UIImage()
//        tabBarController.tabBar.backgroundImage = UIImage() // 会失去毛玻璃效果

        let vc1 = SLHomeViewController()
        let vc2 = SLDiscoverViewController()
        let vc3 = SLMineViewController()

        let navi1 = BaseNavigationController(rootViewController: vc1)
        let navi2 = BaseNavigationController(rootViewController: vc2)
        let navi3 = BaseNavigationController(rootViewController: vc3)

        vc1.tabBarItem = ESTabBarItem(CustomBasicContentView(), title: SLLocalText.tab_home.text, image: R.image.tab1_normal(), selectedImage: R.image.tab1_selected())
        vc2.tabBarItem = ESTabBarItem(CustomBasicContentView(), title: SLLocalText.tab_discover.text, image: R.image.tab2_normal(), selectedImage: R.image.tab2_selected())
        vc3.tabBarItem = ESTabBarItem(CustomBasicContentView(), title: SLLocalText.tab_my.text, image: R.image.tab3_normal(), selectedImage: R.image.tab3_selected())
        tabBarController.viewControllers = [navi1, navi2, navi3]
        return tabBarController
    }
}

class CustomBasicContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        highlightTextColor = R.color.prime()~~
//        textColor = .systemYellow
        renderingMode = .automatic
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        super.selectAnimation(animated: animated, completion: completion)
        Haptic.impact(.light).generate()
    }
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        super.reselectAnimation(animated: animated, completion: completion)
        Haptic.impact(.light).generate()
    }
}
