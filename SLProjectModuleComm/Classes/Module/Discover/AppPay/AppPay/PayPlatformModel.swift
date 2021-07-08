//
//  PayPlatformModel.swift
//  Artist
//
//  Created by 孙梁 on 2020/2/15.
//  Copyright © 2020 2UN7. All rights reserved.
//

import UIKit
import HandyJSON

class PayPlatformModel: NSObject, HandyJSON {
    var payment_platform = 0
    var prepare_id: String?
    var ali_param: PayAliModel?
    var we_chat_param: PayWechatModel?

    required override init() {
        super.init()
    }
}

class PayWechatModel: NSObject, HandyJSON {
    var partnerid: String?
    var prepayid: String?
    var noncestr: String?
    var package: String?
    var sign: String?
    var timestamp: UInt32 = 0
    var appid: String?

    required override init() {
        super.init()
    }
}
class PayAliModel: NSObject, HandyJSON {
    var seller: String?
    var time_expire: String?
    var private_key_pck8: String?
    var product_name: String?
    var notify_url: String?
    var trade_no: String?
    var partner: String?
    var private_key: String?
    var app_id: String?
    var amount: String?

    required override init() {
        super.init()
    }
}
