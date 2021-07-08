//
//  PayManager.swift
//  Artist
//
//  Created by 孙梁 on 2020/2/17.
//  Copyright © 2020 2UN7. All rights reserved.
//

import UIKit
import PKHUD

public class PayManager: NSObject {
    @objc static let shared = PayManager()
    private override init() { super.init() }

    public var delegate: PayResultProtocol?

    @objc public func processingResults(_ url: URL) {
        if url.host == "safepay" {
            AliManager.shared.processingResults(url)
        } else if url.host == "pay" {
            WXApi.handleOpen(url, delegate: WechatManager.shared)
        }
    }
}

extension PayManager {
    func paySuccess() {
        HUD.flash(.labeledError(title: nil, subtitle: "支付成功"), delay: 2)
        delegate?.paySuccess()
    }
    func payFailure() {
        HUD.flash(.labeledError(title: nil, subtitle: "支付失败, 请重新支付"), delay: 2)
        delegate?.payFailure()
    }
    func unKnow() {
        HUD.flash(.labeledError(title: nil, subtitle: "请关闭APP并重新打开获取支付结果"), delay: 2)
        delegate?.unKnow()
    }
}
