//
//  WechatManager.swift
//  Artist
//
//  Created by 孙梁 on 2020/2/15.
//  Copyright © 2020 2UN7. All rights reserved.
//

import UIKit
import PKHUD

public class WechatManager: NSObject {
    @objc static let shared = WechatManager()
    private override init() { super.init() }

    @objc public func regist(_ appId: String, universalLink: String) {
        WXApi.registerApp(appId, universalLink: universalLink)
    }

    @objc func pay(_ model: PayWechatModel?) {
        guard let model = model else { return }
        let req = PayReq()
        req.partnerId = model.partnerid ?? ""
        req.prepayId = model.prepayid ?? ""
        req.nonceStr = model.noncestr ?? ""
        req.timeStamp = model.timestamp
        req.package = model.package ?? ""
        req.sign = model.sign ?? ""
        WXApi.send(req, completion: nil)
    }
}

extension WechatManager: WXApiDelegate {
    public func onReq(_ req: BaseReq) {
        print(req)
    }
    public func onResp(_ resp: BaseResp) {
        if resp.isKind(of: PayResp.self) {
            switch resp.errCode {
            case WXSuccess.rawValue:
                PayManager.shared.paySuccess()
            default:
                PayManager.shared.payFailure()
            }
        }
    }
}
