//
//  JGEventType.swift
//  SLJGServicer
//
//  Created by 孙梁 on 2021/1/8.
//

import UIKit

public enum JGEventType {
    /**
     登录事件
     success: 是否成功
     method: 登录方式
     extra: 不能包含login_method login_success
     */
    case login(success: Bool, method: String, extra: [String: String]?)
    /**
     注册事件
     success: 是否成功
     method: 注册方式
     extra: 不能包含register_method register_success
     */
    case regist(success: Bool, method: String, extra: [String: String]?)
    /**
     购买事件
     goodsID: 商品id
     goodsName: 名称
     price: 价格
     success: 购买成功
     goodsType: 商品类型
     quantity: 商品数量
     extra: 不能包含以下key
         purchase_goods_id
         purchase_goods_name
         purchase_price
         purchase_currency
         purchase_goods_type
         purchase_quantity
         purchase_success
     */
    case purchase(goodsID: String?, goodsName: String?, price: CGFloat, success: Bool, goodsType: String?, quantity: Int?, extra: [String: String]?)
    /**
     浏览事件
     contentID: 浏览内容id
     name: 内容名称
     type: 内容类型
     duration: 浏览时长
     extra: 不能包含以下key
         browse_content_id
         browse_name
         browse_type
         browse_duration
     */
    case browse(contentID: String?, name: String, type: String?, duration: CGFloat?, extra: [String: String]?)
    /**
     自定义计数事件, 先去极光注册事件
     eventID: 事件ID
     extra: 不能包含event_id
     */
    case count(eventID: String, extra: [String: String]?)
    /**
     自定义计算事件, 先去极光注册事件
     eventID: 事件ID
     value: 事件的值
     extra: 不能包含以下key
        event_id
        event_value
     */
    case calculate(eventId: String, value: CGFloat, extra: [String: String]?)
}

public protocol JGEventService {
    var eventObject: JANALYTICSEventObject { get }
}

extension JGEventType: JGEventService {
    public var eventObject: JANALYTICSEventObject {
        switch self {
        case .regist(let success, let method, let extra):
            let event = JANALYTICSRegisterEvent()
            event.success = success
            event.method = method
            event.extra = extra ?? [:]
            return event
        case .login(let success, let method, let extra):
            let event = JANALYTICSLoginEvent()
            event.success = success
            event.method = method
            event.extra = extra ?? [:]
            return event
        case .purchase(let goodsID, let goodsName, let price, let success, let goodsType, let quantity, let extra):
            let event = JANALYTICSPurchaseEvent()
            event.goodsID = goodsID ?? ""
            event.goodsName = goodsName ?? ""
            event.price = price
            event.success = success
            event.goodsType = goodsType ?? ""
            event.quantity = quantity ?? 0
            event.currency = .currencyCNY
            event.extra = extra ?? [:]
            return event
        case .browse(let contentID, let name, let type, let duration, let extra):
            let event = JANALYTICSBrowseEvent()
            event.contentID = contentID ?? ""
            event.name = name
            event.type = type ?? ""
            event.duration = duration ?? 0
            event.extra = extra ?? [:]
            return event
        case .count(let eventID, let extra):
            let event = JANALYTICSCountEvent()
            event.eventID = eventID
            event.extra = extra ?? [:]
            return event
        case .calculate(let eventId, let value, let extra):
            let event = JANALYTICSCalculateEvent()
            event.eventID = eventId
            event.value = value
            event.extra = extra ?? [:]
            return event
        }
    }
}
