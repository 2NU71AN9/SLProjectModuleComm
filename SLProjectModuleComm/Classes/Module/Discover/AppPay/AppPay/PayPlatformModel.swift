//
//  PayPlatformModel.swift
//  Artist
//
//  Created by 孙梁 on 2020/2/15.
//  Copyright © 2020 2UN7. All rights reserved.
//

import UIKit
import HandyJSON

public class PayPlatformModel: NSObject, HandyJSON {
    public var payment_platform = 0
    public var prepare_id: String?
    public var ali_param: PayAliModel?
    public var we_chat_param: PayWechatModel?

    required public override init() {
        super.init()
    }
}

public class PayWechatModel: NSObject, HandyJSON {
    public var partnerid: String?
    public var prepayid: String?
    public var noncestr: String?
    public var package: String?
    public var sign: String?
    public var timestamp: UInt32 = 0
    public var appid: String?

    required public override init() {
        super.init()
    }
}

public class PayAliModel: NSObject, HandyJSON {
    public var seller: String?
    public var time_expire: String?
    public var private_key_pck8: String?
    public var product_name: String?
    public var notify_url: String?
    public var trade_no: String?
    public var partner: String?
    public var private_key: String?
    public var app_id: String?
    public var amount: String?

    required public override init() {
        super.init()
    }
}
