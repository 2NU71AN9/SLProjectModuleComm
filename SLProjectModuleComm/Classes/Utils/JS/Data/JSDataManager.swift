//
//  JSDataManager.swift
//  FBMerchant
//
//  Created by 孙梁 on 2019/5/30.
//  Copyright © 2019 cn. All rights reserved.
//

import UIKit
import YYCache
import RxSwift

class JSDataManager {

    static let shared = JSDataManager()
    private init() { }

    /// 存取数据
    let cache = YYCache(name: "cache")
}

extension JSDataManager {
    func save(key: String?, value: String?, foever: Bool = false, complete: ((Bool) -> Void)?) {
        var varValue = value
        if varValue == nil { varValue = "" }
        guard let key = key, let value = varValue else {
            complete?(false)
            return
        }
        if foever {
            cache?.diskCache.setObject(value as NSCoding, forKey: key) {
                complete?(true)
            }
        } else {
            cache?.memoryCache.setObject(value as NSCoding, forKey: key)
            complete?(true)
        }

    }
    func delete(key: String?, complete: ((Bool) -> Void)?) {
        guard let key = key else {
            complete?(false)
            return
        }
        cache?.removeObject(forKey: key) { (_) in
            complete?(true)
        }
    }
    func valueFor(key: String?) -> String? {
        if let key = key,
            let value = cache?.object(forKey: key) as? String {
            return value
        }
        return nil
    }
}
