//
//  SLJSWebView.swift
//  PGJManager-iOS
//
//  Created by 孙梁 on 2018/12/24.
//  Copyright © 2018 fg. All rights reserved.
//

import UIKit
import WebKit

class SLJSWebView: WKWebView {

    public var titleSubject: ((String?) -> Void)?
    public var handleUrl: ((URL?) -> Void)?
    
    public private(set) var requestUrl: URL?
    
    private lazy var progress: UIProgressView = {
        let view = UIProgressView()
        view.tintColor = .blue
        view.trackTintColor = .clear
        view.setProgress(0.1, animated: true)
        view.alpha = 0
        return view
    }()
    
    private lazy var debugLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.backgroundColor = .clear
        label.textColor = .orange
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(debugClick))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    private var config = WKWebViewConfiguration().then {
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content','width=device-width,initial-scale=1.0');document.getElementsByTagName('head')[0].appendChild(meta);var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].setAttribute('width', '100%');imgs[i].style.height='auto';}"
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        $0.userContentController = wkUController
    }
    
    public init(_ url: URL?) {
        super.init(frame: CGRect.zero, configuration: config)
        self.requestUrl = url
        setup()
    }
    public init() {
        super.init(frame: CGRect.zero, configuration: config)
        setup()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        navigationDelegate = self
//        customUserAgent = "comm-ios"
        allowsBackForwardNavigationGestures = false // 是否侧滑返回
        addSubview(progress)
        #if DEBUG
        addSubview(debugLabel)
        #endif
        addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        progress.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(safeAreaInsets.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        #if DEBUG
        debugLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(safeAreaInsets.top)
            make.left.right.equalToSuperview()
        }
        #endif
    }
    
    deinit {
        removeObserver(self, forKeyPath: "estimatedProgress")
        removeObserver(self, forKeyPath: "title")
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", let _ = object as? WKWebView {
            progress.alpha = 1
            progress.setProgress(Float(estimatedProgress), animated: true)
            if estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { [weak self] in
                    self?.progress.alpha = 0
                }) { [weak self] (_) in
                    self?.progress.setProgress(0, animated: true)
                }
            }
        } else if keyPath == "title", let _ = object as? WKWebView {
            titleSubject?(title)
        }
    }
}

// MARK: - WKNavigationDelegate
extension SLJSWebView: WKNavigationDelegate {
    /// wkwebview信任https接口
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // 判断是否是信任服务器证书
        if challenge.protectionSpace.authenticationMethod
            == NSURLAuthenticationMethodServerTrust {
            // 告诉服务器，客户端信任证书
            // 创建凭据对象
            let card = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            // 告诉服务器信任证书
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, card)
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webViewDidStartLoad")
        debugLabel.text = webView.url?.absoluteString
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webViewDidFinishLoad")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.scheme == "tel" {
            // DispatchQueue.main.async {
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            // }
        } else if navigationAction.request.url?.scheme == "sms" {
            // 短信的处理
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else if navigationAction.request.url?.scheme == "mailto" {
            // 邮件的处理
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else if webView.url?.absoluteString.hasPrefix("https://itunes.apple.com") ?? false,
            webView.url?.absoluteString.hasPrefix("http://itunes.apple.com") ?? false,
            let url = navigationAction.request.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else if navigationAction.request.url?.absoluteString.hasPrefix("hios") ?? false {
            handleUrl?(navigationAction.request.url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

extension SLJSWebView {
    public func request() {
        guard let url = requestUrl else { return }
        load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10))
    }
    
    public func request(with url: URL?) {
        requestUrl = url
        request()
    }
}

// MARK: - Event
extension SLJSWebView {
     @objc private func debugClick() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = debugLabel.text
    }
}
