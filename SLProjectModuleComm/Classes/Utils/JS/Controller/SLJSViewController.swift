//
//  SLJSViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/13.
//

import UIKit
import WebKit
import SLIKit
import RxSwift

class SLJSViewController: UIViewController {

    lazy var bridge: WKWebViewJavascriptBridge = {
        let bridge = WKWebViewJavascriptBridge(webView: webView)
        return bridge
    }()
    
    private(set) lazy var naviBar: CommNavigationBar = {
        let bar = CommNavigationBar.loadView()
        bar.viewController = self
        bar.backEvent = { [weak self] in
            self?.pop()
        }
        return bar
    }()
    
    private lazy var webView: SLJSWebView =  {
        let webView = SLJSWebView()
        webView.titleSubject = { [weak self] title in
            self?.title = title
        }
        webView.handleUrl = { [weak self] url in
            self?.handleUrl(url)
        }
        return webView
    }()

    /// url
    @objc var url: String?

    /// 返回时是否需要刷新界面
    @objc var haveToRefresh: ((Bool) -> Void)?

    let bag = DisposeBag()

    @objc init(_ url: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    init(_ api: JSAPI) {
        super.init(nibName: nil, bundle: nil)
        url = api.completeUrl
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        print("SLJSViewController已释放")
    }
}

// MARK: - LifeCyle
extension SLJSViewController: RegistHandlersProtocol, InteractionProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "加载中..."
        navigationController?.navigationBar.isHidden = true
        view.addSubview(naviBar)
        additionalSafeAreaInsets.top = NavigationBarHeight
        view.addSubview(webView)
        registJSCallNavite()
        loadUrl()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Privater Methods
extension SLJSViewController {
    private func loadUrl() {
        guard let urlStr = url, let url = URL(string: urlStr) else { return }
        webView.request(with: url)
    }
    
    private func reload() {
        webView.reload()
    }

    private func switchUrl(_ url: String?) {
        self.url = url
        loadUrl()
    }

    private func pop() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            dissmiss()
        }
    }

    func dissmiss() {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else if navigationController?.presentingViewController != nil {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
