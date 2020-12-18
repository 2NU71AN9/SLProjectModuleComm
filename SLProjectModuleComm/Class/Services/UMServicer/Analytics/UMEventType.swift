//
//  UMEventType.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/16.
//

import UIKit

protocol UMEventType {
    var eventId: String? { get }
    var primaryKey: String? { get }
    var label: String? { get }
    var parameters: [String: Any]? { get }
    var counter: Int? { get }
    var durations: Int? { get }
    var method: UMEventMethod { get }
}

enum UMEventMethod {
    case event
    case beginEvent
    case endEvent
}
