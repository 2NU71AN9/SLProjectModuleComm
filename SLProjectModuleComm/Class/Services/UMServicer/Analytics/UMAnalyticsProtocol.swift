//
//  UMAnalyticsProtocol.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/16.
//

import UIKit

protocol UMAnalyticsProtocol {
    func confitAnalyticsSettings()
    
    /// 添加事件
    /// SLUMServicer.shared.addEvent(.profileSignIn(userId: "123123123123"))
    /// SLUMServicer.shared.addEvent(.someThing_2(key1: "key1", key2: "key2"))
    /// SLUMServicer.shared.addEvent(.someThing_3(key1: "key1", key2: "key2", counter: 10))
    /// - Parameter event: event
    func addEvent(_ event: UMEventService)
}

extension UMAnalyticsProtocol where Self: SLUMServicer {
    func confitAnalyticsSettings() {
        // 开启统计
        UMConfigure.setAnalyticsEnabled(true)
        // 自动采集页面信息
        MobClick.setAutoPageEnabled(true)
    }
    
    func addEvent(_ event: UMEventService) {
        switch (event, event.method) {
        case (.profileSignIn(let userId), _):
            MobClick.profileSignIn(withPUID: userId)
        case (_, .event):
            if let parameters = event.parameters, let durations = event.durations {
                MobClick.event(event.eventId, attributes: parameters, durations: Int32(durations))
            } else if let counter = event.counter {
                MobClick.event(event.eventId, attributes: event.parameters, counter: Int32(counter))
            } else if let durations = event.durations {
                MobClick.event(event.eventId, label: event.label, durations: Int32(durations))
            } else if let parameters = event.parameters {
                MobClick.event(event.eventId, attributes: parameters)
            } else {
                MobClick.event(event.eventId, label: event.label)
            }
        case (_, .beginEvent):
            if let parameters = event.parameters {
                MobClick.beginEvent(event.eventId, primarykey: event.primaryKey, attributes: parameters)
            } else {
                MobClick.beginEvent(event.eventId, label: event.label)
            }
        case (_, .endEvent):
            if let primarykey = event.primaryKey {
                MobClick.endEvent(event.eventId, primarykey: primarykey)
            } else {
                MobClick.endEvent(event.eventId, label: event.label)
            }
        }
    }
}
