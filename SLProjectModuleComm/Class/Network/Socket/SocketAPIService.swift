//
//  SocketAPIService.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/31.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

enum SocketAPIService {
    case home
}

extension SocketAPIService {
    static let kDebugBaseURL = kReleaseBaseURL
    static let kReleaseBaseURL = "http://doc.znclass.com/"

    public var baseURL: String {
        var urlStr = ""
        switch self {
        default:
            #if DEBUG
            urlStr = APIService.kDebugBaseURL
            #else
            urlStr = APIService.kReleaseBaseURL
            #endif
        }
        return urlStr
    }

    public var path: String {
        switch self {
        case .home:
            return "teacher/login/token"
        }
    }

    /// 参数
    public var parameters: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }
}
