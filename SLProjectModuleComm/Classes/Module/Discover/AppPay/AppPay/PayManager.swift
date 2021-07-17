//
//  PayManager.swift
//  Artist
//
//  Created by 孙梁 on 2020/2/17.
//  Copyright © 2020 2UN7. All rights reserved.
//

import UIKit
import SLIKit

public class PayManager: NSObject {
    @objc static let shared = PayManager()
    private override init() { super.init() }

    public weak var delegate: PayResultProtocol?

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
        SLHUD.message(title: nil, desc: "支付成功")
        delegate?.paySuccess()
    }
    func payFailure() {
        SLHUD.message(title: nil, desc: "支付失败, 请重新支付")
        delegate?.payFailure()
    }
    func unKnow() {
        SLHUD.message(title: nil, desc: "请关闭APP并重新打开获取支付结果")
        delegate?.unKnow()
    }
}
