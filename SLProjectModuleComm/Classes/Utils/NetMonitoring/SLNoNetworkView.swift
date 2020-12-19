//
//  SLNoNetworkView.swift
//  FZXLive
//
//  Created by 孙梁 on 2020/8/14.
//  Copyright © 2020 znclass. All rights reserved.
//

import UIKit
import SnapKit

class SLNoNetworkView: UIView {

    @objc public var refreshEvent: (() -> Void)?

    @objc static func loadView(_ refreshEvent: (() -> Void)?) -> SLNoNetworkView {
        let view = Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as? SLNoNetworkView
        view?.refreshEvent = refreshEvent
        return view ?? SLNoNetworkView()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            snp.sl_makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalToSuperview()
            }
        } else {
            snp.removeConstraints()
        }
    }

    @IBAction func setBtn(_ sender: Any) {
        if let url = URL(string: "App-Prefs:root") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func refreshBtn(_ sender: Any) {
        refreshEvent?()
    }
}
