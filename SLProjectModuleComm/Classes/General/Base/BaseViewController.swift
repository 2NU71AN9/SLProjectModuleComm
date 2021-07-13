//
//  BaseViewController.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import RxSwift
import SLIKit

/**
 base类
 可监听登录状态和网络状态切换不同显示页面, 子类可重写相关方法实现自己的页面
 提供自定义导航栏显示
 */
class BaseViewController: GeneralViewController {

    private(set) lazy var naviBar: CommNavigationBar = {
        let bar = CommNavigationBar.loadView()
        bar.viewController = self
        return bar
    }()
    
    // 登录成功后会重置
    private(set) var bag = DisposeBag()
    // 不会重置
    let bagStay = DisposeBag()
    /// 导航栏是否隐藏, 默认否
    var naviBarHidden = false {
        didSet {
            naviBar.isHidden = naviBarHidden
            additionalSafeAreaInsets.top = naviBarHidden ? 0 : NavigationBarHeight
        }
    }
    /// 访客页面
    private var visitorPage: SLVisitorViewController?
    /// 无网络页面
    private var noNetworkPage: SLNoNetworkViewController?
    /// 当前显示的页面
    private var vcPageStatus: ViewControllerPageStatus = .mainPage
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("😂😂😂😂😂😂\(type(of: self))已释放😂😂😂😂😂😂")
    }
}

// MARK: - life circle
extension BaseViewController {
    
    final override func loadView() {
        super.loadView()
        bag = DisposeBag()
        contentView?.parentVC = self
        userBind()
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = R.color.view_background()
        view.addSubview(naviBar)
        /// 修改safeArea顶部的缩进
        additionalSafeAreaInsets.top = naviBarHidden ? 0 : NavigationBarHeight
        
        /// 根据登录状态和网络状态显示不同页面
        AccountServicer.service.isLogin ? setMasterView() : setVisitorPage()
        if SLNetworkListenManager.shared.networkStatus == .noNet { setNoNetworkPage() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        naviBar.setBackItemShow()
    }
}

extension BaseViewController {
    /// 正常登录 viewDidLoad
    @objc func setMasterView() {
        vcPageStatus = .mainPage
        bind()
        contentView?.viewDidLoad()
        viewModel?.viewDidLoad()
    }

    /**
     访客模式
     不需要访客模式重写此方法
     override func setVisitorPage() {
         setMasterView()
     }
     */
    @objc func setVisitorPage() {
        guard vcPageStatus != .visitorPage else { return }
        vcPageStatus = .visitorPage
        naviBar.title = "未登录"
        visitorPage = SLVisitorViewController()
        guard let visitorPage = visitorPage else { return }
        addChild(visitorPage)
        visitorPage.didMove(toParent: self)
        view.addSubview(visitorPage.view)
        visitorPage.view.frame = view.bounds
    }
    
    /**
     无网络页面
     不需要无网络页面重写此方法
     override func setNoNetworkPage() { }
     */
    @objc func setNoNetworkPage() {
        guard vcPageStatus != .noNetworkPage else { return }
        vcPageStatus = .noNetworkPage
        noNetworkPage = SLNoNetworkViewController()
        guard let noNetworkPage = noNetworkPage else { return }
        addChild(noNetworkPage)
        noNetworkPage.didMove(toParent: self)
        view.addSubview(noNetworkPage.view)
        noNetworkPage.view.frame = view.bounds
        noNetworkPage.refreshEvent = { [weak self] in
            self?.noNetworkPageRefreshAction()
        }
    }

    /// 数据绑定
    @objc func bind() {
        if let viewModel = viewModel {
            contentView?.refreshEvent.bind(to: viewModel.refreshSubject).disposed(by: bag)
            contentView?.loadMoreEvent.bind(to: viewModel.loadMoreSubject).disposed(by: bag)
        }
    }
    
    /// 无网络页面点击重新加载
    @objc func noNetworkPageRefreshAction() {
        viewModel?.refreshData()
    }
}

// MARK: - private methods
extension BaseViewController {
    /// 监听登录状态和网络状态
    private func userBind() {
        AccountServicer.service.loginSuccessSubject
            .subscribe { [weak self] (_) in
                self?.loginSuccess()
            }.disposed(by: bag)
        AccountServicer.service.haveToLogoutSubject
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] (_) in
                self?.setVisitorPage()
            }).disposed(by: bag)
        SLNetworkListenManager.shared.networkChangedSubject
            .skip(1)
            .subscribe(onNext: { [weak self] (status) in
                self?.networkStatusChanged(status)
            }).disposed(by: bag)
    }
    
    /// 登录成功, 刷新整个页面
    private func loginSuccess() {
        bag = DisposeBag()
        removeVisitorPage()
        userBind()
        viewDidLoad()
        viewWillAppear(true)
        viewDidAppear(true)
    }
    
    private func removeVisitorPage() {
        visitorPage?.willMove(toParent: nil)
        visitorPage?.view.removeFromSuperview()
        visitorPage?.removeFromParent()
        visitorPage = nil
        vcPageStatus = noNetworkPage == nil ? .mainPage : .noNetworkPage
    }
    
    private func removeNonetworkPage() {
        noNetworkPage?.willMove(toParent: nil)
        noNetworkPage?.view.removeFromSuperview()
        noNetworkPage?.removeFromParent()
        noNetworkPage = nil
        vcPageStatus = visitorPage == nil ? .mainPage : .visitorPage
    }
    
    /// 网络状态改变
    @objc public func networkStatusChanged(_ status: SLNetworkStatus) {
        switch status {
        case .wifi, .wwan:
            removeNonetworkPage()
        case .noNet:
            setNoNetworkPage()
        }
    }
}

/// 控制器当前显示的页面
enum ViewControllerPageStatus {
    case mainPage
    case visitorPage
    case noNetworkPage
}
