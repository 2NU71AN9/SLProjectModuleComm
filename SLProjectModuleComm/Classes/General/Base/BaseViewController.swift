//
//  BaseViewController.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import RxSwift
import SLSupportLibrary

class BaseViewController: GeneralViewController {

    private(set) lazy var naviBar: CommNavigationBar = {
        let bar = CommNavigationBar.loadView()
        bar.viewController = self
        return bar
    }()
    
    private(set) var bag = DisposeBag()
    
    var naviBarHidden = false {
        didSet {
            naviBar.isHidden = naviBarHidden
            additionalSafeAreaInsets.top = naviBarHidden ? 0 : NavigationBarHeight
        }
    }
    
    private var visitorPage: SLVisitorViewController?
    private var noNetworkPage: SLNoNetworkViewController?
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
        view.backgroundColor = ColorBox.view_background.color
        view.addSubview(naviBar)
        additionalSafeAreaInsets.top = naviBarHidden ? 0 : NavigationBarHeight
        AccountServicer.service.isLogin ? setMasterView() : setVisitorPage()
        if SLNetworkListenManager.shared.networkStatus == .noNet { setNoNetworkPage() }
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

    /// 访客模式
    /* 不需要访客模式重写此方法
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
    
    /// 无网络页面
    /* 不需要无网络页面重写此方法
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

    ///
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
    
    @objc private func networkStatusChanged(_ status: SLNetworkStatus) {
        switch status {
        case .wifi, .wwan:
            removeNonetworkPage()
        case .noNet:
            setNoNetworkPage()
        }
    }
}

enum ViewControllerPageStatus {
    case mainPage
    case visitorPage
    case noNetworkPage
}
