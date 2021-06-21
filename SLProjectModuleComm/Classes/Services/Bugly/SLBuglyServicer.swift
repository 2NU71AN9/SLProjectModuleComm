//
//  SLBuglyServicer.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/18.
//

import UIKit
import Bugly

/// bugly相关
class SLBuglyServicer: NSObject {

    static let shared = SLBuglyServicer()
    
    func config(_ appId: String) {
        let config = BuglyConfig()
        #if DEBUG
        config.debugMode = true
        #else
        config.debugMode = false
        #endif
        Bugly.start(withAppId: appId, config: config)
    }
    
    // 设置用户标识
    func setUserId(_ userId: String) {
        Bugly.setUserIdentifier(userId)
    }
    // 设置标签
    func setTag(_ tag: Int) {
        Bugly.setTag(UInt(tag))
    }
}
