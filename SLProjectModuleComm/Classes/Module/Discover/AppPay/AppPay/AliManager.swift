//
//  AliManager.swift
//  Artist
//
//  Created by 孙梁 on 2020/2/17.
//  Copyright © 2020 2UN7. All rights reserved.
//

import UIKit

/// 找不到 openssl.h解决方法: Header Search Path 添加 openssl文件夹的上一层路径
class AliManager: NSObject {
    @objc static let shared = AliManager()
    private override init() { super.init()
        AlipaySDK.defaultService()
    }
}

extension AliManager {
    /// 跳转支付
    func pay(_ model: PayAliModel?) {
        guard let paymodel = model else { return }
        let order = APOrderInfo()
        order.app_id = paymodel.app_id
        order.method = "alipay.trade.app.pay"
        order.charset = "utf-8"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        order.timestamp = formatter.string(from: Date())
        order.version = "1.0"
        order.sign_type = "RSA2"
        order.biz_content = APBizContent()
        order.biz_content.body = paymodel.product_name
        order.biz_content.seller_id = paymodel.seller
        order.biz_content.subject = paymodel.product_name
        order.biz_content.out_trade_no = paymodel.trade_no
        order.biz_content.timeout_express = "30m" //超时时间设置
        order.biz_content.total_amount = paymodel.amount

        guard let orderInfo = order.orderInfoEncoded(false),
            let orderInfoEncoded = order.orderInfoEncoded(true) else { return }
        var signedString: String?
        let signer = APRSASigner(privateKey: paymodel.private_key_pck8)
        signedString = signer?.sign(orderInfo, withRSA2: true)
        if signedString != nil {
            let orderString = String(format: "%@&sign=%@", orderInfoEncoded, signedString!)
            AlipaySDK.defaultService()?.payOrder(orderString, fromScheme: "artist") { (_) in
            }
        }
    }
    /// 处理支付或者登录结果
    func processingResults(_ url: URL) {
        AlipaySDK.defaultService()?.processOrder(withPaymentResult: url) { [weak self] (dic) in
            self?.payResults(dic as? [String: Any])
        }
    }

    /// 支付结果
    private func payResults(_ dic: [String: Any]?) {
        guard let status = dic?["resultStatus"] as? String else { return }
        switch status {
        case "9000":
            PayManager.shared.paySuccess()
        case "8000", "6004":
            PayManager.shared.unKnow()
        default:
            PayManager.shared.payFailure()
        }
    }
}
