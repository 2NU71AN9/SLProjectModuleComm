//
//  EmptyPageContentWebViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit
import JXSegmentedView
import WebKit

class EmptyPageContentWebViewController: BaseViewController {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()
}

// MARK: - LifeCyle
extension EmptyPageContentWebViewController {
    override func setMasterView() {
        super.setMasterView()
        naviBarHidden = true
        view.addSubview(webView)
        if let url = URL(string: "https://www.baidu2.com") {
            webView.sl_load(URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5))
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.snp.sl.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}

extension EmptyPageContentWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.showEmptyView()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.hideEmptyView()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.hideEmptyView()
    }
}

// MARK: - JXPagingViewListViewDelegate
extension EmptyPageContentWebViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView { view }
}
