//
//  API.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/11.
//

import UIKit
import HandyJSON
import PKHUD

/// 网络请求返回数据结构
public struct NetworkResponse: HandyJSON {
    var status: Bool = false
    var code: Int = 1000
    var message: String?
    var result: Any?

    public init() {
        self.init(code: 1000, message: nil, data: nil)
    }
    public init(code: Int, message: String?, data: Any?) {
        self.code = code
        self.message = message
        self.result = data
    }
    public mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.message <-- "msg"
        mapper <<<
        self.result <-- "data"
    }
    public mutating func didFinishMapping() {
        if status == true { code = 0 } else if status == false, let result = result as? Int { code = result } else { code = 300 }
    }
}

/// 各code代表什么
public enum HttpCode: Int {
    case success = 0 // 成功
    case logout = 14007 // token过期
    case requestFailed = 1000 // 网络请求失败
    case failed = 300 // 失败
    case noDataOrDataParsingFailed = 301 // 无数据或解析失败

    var logoutCode: [Int] { [rawValue, 14006] }
}

public enum SLError: Swift.Error {
    case requestFailed(message: String?) // 网络请求失败
    case noDataOrDataParsingFailed(message: String?) // 无返回数据或数据解析失败
    case failed(code: Int?, message: String?) // 失败
    case error(Error?)
}

// MARK: - 输出error详细信息
extension SLError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestFailed(let error):
            #if DEBUG
            DispatchQueue.main.async {
                HUD.flash(.label(String(describing: error)), delay: 1.5)
            }
            #endif
            return String(describing: error)
        case .noDataOrDataParsingFailed(let error):
            #if DEBUG
            DispatchQueue.main.async {
                HUD.flash(.label(String(describing: error)), delay: 1.5)
            }
            #endif
            return String(describing: error)
        case .failed(let code, let message):
            if HttpCode.logout.logoutCode.contains(code ?? 0) {
                AccountServicer.service.logout()
            } else {
                #if DEBUG
                DispatchQueue.main.async {
                    HUD.flash(.label(String(format: "%d\n%@", code ?? 300, message ?? "")), delay: 1.5)
                }
                #else
                DispatchQueue.main.async {
                    HUD.flash(.label(String(format: "%@", message ?? "")), delay: 1.5)
                }
                #endif
            }
            return String(format: "%d\n%@", code ?? 300, message ?? "")
        case .error(let error):
            #if DEBUG
            DispatchQueue.main.async {
                HUD.flash(.label(String(describing: error)), delay: 1.5)
            }
            #endif
            return error.debugDescription
        }
    }
}
