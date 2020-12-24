//
//  CommNavigationBar.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import SLSupportLibrary
import RxSwift

class CommNavigationBar: UIView {

    static var kBarHeight = NavigationBarHeight
    
    var backEvent: (() -> Void)?
    var item1Event: (() -> Void)?
    var item2Event: (() -> Void)?
    var item3Event: (() -> Void)?

    /// 是否有毛玻璃效果
    var effect: Bool = true {
        didSet {
            effectView.isTranslucent = effect
        }
    }
    /// 导航栏颜色, 不要通过backgroundColor设置
    var barColor: UIColor? {
        didSet {
            effect = false
            effectView.tintColor = barColor
        }
    }
    /// 标题
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var item1Image: UIImage? {
        didSet {
            item1.setImage(item1Image, for: .normal)
            item1.isHidden = item1Image == nil && item1Title?.isEmpty ?? true
        }
    }
    var item2Image: UIImage? {
        didSet {
            item2.setImage(item2Image, for: .normal)
            item2.isHidden = item2Image == nil && item2Title?.isEmpty ?? true
        }
    }
    var item3Image: UIImage? {
        didSet {
            item3.setImage(item3Image, for: .normal)
            item3.isHidden = item3Image == nil && item3Title?.isEmpty ?? true
        }
    }
    var item1Title: String? {
        didSet {
            item1.setTitle(item1Title, for: .normal)
            item1.isHidden = item1Image == nil && item1Title?.isEmpty ?? true
        }
    }
    var item2Title: String? {
        didSet {
            item2.setTitle(item2Title, for: .normal)
            item2.isHidden = item2Image == nil && item2Title?.isEmpty ?? true
        }
    }
    var item3Title: String? {
        didSet {
            item3.setTitle(item3Title, for: .normal)
            item3.isHidden = item3Image == nil && item3Title?.isEmpty ?? true
        }
    }

    weak var viewController: UIViewController? {
        didSet {
            setBackItemShow()
            title = viewController?.title
            viewController?.rx.observeWeakly(String.self, "title").subscribe(onNext: { [weak self] (title) in
                self?.title = title
            }).disposed(by: bag)
        }
    }

    @IBOutlet private weak var barHeight: NSLayoutConstraint! {
        didSet {
            barHeight.constant = Self.kBarHeight
        }
    }
    @IBOutlet private weak var barTopOffset: NSLayoutConstraint! {
        didSet {
            barTopOffset.constant = -Self.kBarHeight
        }
    }
    @IBOutlet private weak var effectView: UIToolbar!
    @IBOutlet private weak var titleContainerView: UIView!
    @IBOutlet private weak var backBtn: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var item1: UIButton!
    @IBOutlet private weak var item2: UIButton!
    @IBOutlet private weak var item3: UIButton!
    @IBOutlet private weak var itemContainerView: UIStackView!
        
    private let bag = DisposeBag()

    @IBAction private func backAction(_ sender: UIButton) {
        backEvent == nil ? dismiss() : backEvent?()
    }
    @IBAction private func item1Action(_ sender: UIButton) {
        item1Event?()
    }
    @IBAction private func item2Action(_ sender: UIButton) {
        item2Event?()
    }
    @IBAction private func item3Action(_ sender: UIButton) {
        item3Event?()
    }
}

extension CommNavigationBar {
    private static var exchanged = false // 是否已经进行过
    private static func exchangeMethod() {
        if exchanged { return }
        exchanged = true
        RunTime.exchangeMethod(selector: #selector(UIView.addSubview(_:)),
                               replace: #selector(UIView.sl_addSubview(_:)),
                               class: UIView.self)
    }
    
    static func loadView() -> CommNavigationBar {
        exchangeMethod()
        let view = CommNavigationBar.sl_loadNib() as? CommNavigationBar
        view?.layer.zPosition = naviBar_zPosition
        return view ?? CommNavigationBar()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        snp.sl_makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
    }
    
    private func setBackItemShow() {
        guard let viewController = viewController else { return }
        guard let navigationController = viewController.navigationController else {
            backBtn.isHidden = viewController.presentingViewController == nil
            return
        }
        backBtn.isHidden = navigationController.viewControllers.count <= 1
    }
    
    private func dismiss() {
        guard let viewController = viewController else { return }
        guard let navigationController = viewController.navigationController else {
            if viewController.presentingViewController != nil {
                viewController.dismiss(animated: true, completion: nil)
            }
            return
        }
        if navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else if navigationController.presentingViewController != nil {
            navigationController.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIView {
    @objc func sl_addSubview(_ subView: UIView) {
        sl_addSubview(subView)
        for view in subviews {
            if view.isKind(of: CommNavigationBar.self) {
                bringSubviewToFront(view)
                break
            }
        }
    }
}
