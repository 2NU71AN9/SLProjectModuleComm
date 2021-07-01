//
//  CommNavigationBar.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import SLIKit
import RxSwift

/// 自定义导航栏
class CommNavigationBar: UIView {
    /// 导航栏高度
    static var kBarHeight = NavigationBarHeight
    
    /// 返回点击, 为nil时会按照原有栈返回
    var backEvent: (() -> Void)?
    /// 右侧按钮1, 2, 3点击
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
    
    /// 右侧按钮1, 2, 3图片
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
    
    /// 右侧按钮1, 2, 3文字
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

    /// 控制器
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
    @IBOutlet public weak var backBtn: UIButton!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var item1: UIButton!
    @IBOutlet public weak var item2: UIButton!
    @IBOutlet public weak var item3: UIButton!
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
    /// 交换方法, 使导航栏始终在最上层, 不被后加的view遮挡
    private static func exchangeMethod() {
        if exchanged { return }
        exchanged = true
        RunTime.exchangeMethod(selector: #selector(UIView.addSubview(_:)),
                               replace: #selector(UIView.sl_addSubview(_:)),
                               class: UIView.self)
    }
    
    /// 创建导航栏
    static func loadView() -> CommNavigationBar {
        exchangeMethod()
        let view = CommNavigationBar.sl.loadNib()?.base
        view?.layer.zPosition = naviBar_zPosition
        return view ?? CommNavigationBar()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        snp.sl.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
    }
    
    /// 是否显示返回按钮
    private func setBackItemShow() {
        guard let viewController = viewController else { return }
        guard let navigationController = viewController.navigationController else {
            backBtn.isHidden = viewController.presentingViewController == nil
            backBtn.setImage(R.image.navi_close(), for: .normal)
            return
        }
        backBtn.setImage(navigationController.viewControllers.count <= 1 && viewController.presentingViewController != nil ? R.image.navi_close() : R.image.navi_back(), for: .normal)
        backBtn.isHidden = navigationController.viewControllers.count <= 1 && viewController.presentingViewController == nil
    }
    
    /// 根据页面结构使用不同方式返回
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
    /// 使导航栏始终在最上层, 不被后加的view遮挡
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
