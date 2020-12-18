//
//  UMEventService.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/16.
//

import UIKit

/**
 eventId或者key请使用英文、数字、下划线、中划线及加号进行定义，使用其中一种或者几种都可以，不能以“数字”开头，避免使用中文
 counter、durations、id、ts、du、token、device_name、device_model 、device_brand、country、city、channel、province、appkey、app_version、access、launch、pre_app_version、terminate、no_first_pay、is_newpayer、first_pay_at、first_pay_level、first_pay_source、first_pay_user_level、first_pay_versio是保留字段，不能作为eventId 及key的名称
 */

public enum UMEventService {
    case profileSignIn(userId: String)
    case someThing_1
    case someThing_2(key1: String, key2: String)
    case someThing_3(key1: String, key2: String, counter: Int)
}

extension UMEventService: UMEventType {
    
    var eventId: String? {
        switch self {
        case .someThing_1:
            return "someThing_1"
        case .someThing_2:
            return "someThing_2"
        case .someThing_3:
            return "someThing_3"
        default:
            return nil
        }
    }
    
    var primaryKey: String? {
        nil
    }
    
    var label: String? {
        nil
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .someThing_2(let key1, let key2):
            return ["key1": key1, "key2": key2]
        case .someThing_3(let key1, let key2, _):
            return ["key1": key1, "key2": key2]
        default:
            return nil
        }
    }
    
    var counter: Int? {
        switch self {
        case .someThing_3(_, _, let counter):
            return counter
        default:
            return nil
        }
    }
    
    var durations: Int? {
        nil
    }
    
    var method: UMEventMethod {
        .event
    }
}
