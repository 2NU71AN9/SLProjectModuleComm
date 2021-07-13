//
//  JSElement.swift
//  PGJManager-iOS
//
//  Created by 孙梁 on 2019/1/5.
//  Copyright © 2019 fg. All rights reserved.
//

import UIKit
import HandyJSON

/// 前往web页面
struct OpenVCElement: HandyJSON {
    var url: String?

    var completeUrl: String? {
        guard let url = url else { return nil }
        if url.contains("index.html") { return url }
//        if url.contains("#") { return url.replace(of: "#", with: "/index.html#") }
//        if url.contains("?") { return url.replace(of: "?", with: "/index.html?") }
        return url
    }

    init(url: String) {
        self.url = url
    }
    init() {}
}

/// 前往Native页面
struct OpenNativeEmelent: HandyJSON {
    var pageName: String?
}

/// 页面配置
struct PageConfigerElement: HandyJSON {
    var stopNativeBack = 0
    var imageName: [String]?
    var rightItemText: String?

    // 是否拦截pop
    var interceptPop: Bool {
        stopNativeBack == 1
    }

    // 图片
    var rightItemImgs: [UIImage]? {
        imageName?.compactMap { (_) -> UIImage? in
            return nil
        }
    }

    var rightItemTexts: [String]? {
        imageName?.compactMap { (str) -> String? in
            switch str {
            case "editIcon":
                return "编辑"
            case "searchIcon":
                return "搜索"
            case "calander":
                return "日历"
            case "more":
                return "更多"
            case "share":
                return "分享"
            case "updateCard":
                return "修改"
            case "list":
                return "列表"
            default:
                return nil
            }
        }
    }

    var rightItemImage: UIImage? {
        guard let rightItemImgs = rightItemImgs else { return nil }
        if rightItemImgs.count == 1 {
            return rightItemImgs.first
        } else if rightItemImgs.count > 1 {
            return nil // 更多
        }
        return nil
    }

    var isMore: Bool {
        return (rightItemImgs?.count ?? 0) > 1
    }
}

/// 返回
struct GoBackElement: HandyJSON {
    var isNativePop = true //原生是否要返回
    var reload = 0 //1 返回需要刷新页面  2返回不需要刷新页面
    var close = 0

    var haveToRefresh: Bool {
        return reload == 1
    }

    var popToRoot: Bool {
        return close == 1
    }
}

/// 存数据
struct StoreDataToLoaclElement: HandyJSON {
    var keyStr: String? //存数据的key
    var valueStr: String? //存数据的value
    var foever = 0 // 0不持久化, 1持久化

    /// 是否持久化
    var isFoever: Bool {
        return foever == 1
    }
    /*
     返回:
     {
     status:0 // 0 成功  其他失败
     }
     */
}

/// 取数据
struct RequestDataFromLoaclElelemt: HandyJSON {
    var keystr: String? //取数据的key

    /*
     返回:
     {
     data:‘1’//返回数据json
     status:0 // 0 成功  其他失败
     }
     */
}

/// 分享
struct ShareElement: HandyJSON {
    var title: String?
    var url: String?
    var desc: String?
    var image: String?
    var momentsUrl: String? // 朋友圈
    var friendUrl: String? // 好友
}

/// 微信支付时穿的paymentShare
struct WXPaymentShare: HandyJSON {
    var totalAmount: Double = 0 //订单金额
    var isUseCard = 0
    var payCardId = 0
    var cardAmount: Double = 0
    var isUseVip = 0
    var vipLogId = 0
    var vipAmount: Double = 0
    var isUseCoupon = 0
    var couponId = 0
    var couponAmount: Double = 0
    var payAmount: Double = 0 //实际支付金额
}
