//
//  APIService.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/11.
//

import UIKit
import Moya
import SLIKit

public enum APIService {
    /// 登录
    case login(account: String, password: String)
    /// 下载
    case downloadFile(_ url: String)
    
    // 默认下载保存地址
    static let kDefaultDownloadDir: URL = {
        let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
    }()
}

extension APIService: TargetType {

    static let kDebugBaseURL = kReleaseBaseURL
    static let kReleaseBaseURL = "http://qhjj.maitexun.cn/api.html"

    public var baseURL: URL {
        var urlStr = ""
        switch self {
        default:
            #if DEBUG
            urlStr = APIService.kDebugBaseURL
            #else
            urlStr = APIService.kReleaseBaseURL
            #endif
        }
        return URL(string: urlStr + path)!
    }

    public var path: String { "" }

    public var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }

    public var sampleData: Data { "".data(using: .utf8) ?? Data() }

    public var task: Task {
        print("""
            #############↓请求参数↓#################
            \(baseURL)
            \(parameters)
            ######################################
            """)
        var para = parameters
        para["token"] = AccountServicer.service.token
        switch self {
        case .downloadFile:
            return .downloadDestination(downloadDestination)
        case .login:
            return .requestCompositeData(bodyData: Data(), urlParameters: para)
//        case .uploadImage(let images):
//            return .uploadMultipart(images.compactMap {$0.formData})
        default:
            return .requestParameters(parameters: para, encoding: JSONEncoding.default)
        }
    }

    public var headers: [String: String]? {
        let token = AccountServicer.service.token ?? ""
        return ["Authorization": !token.isEmpty ? "Bearer " + token : "",
//                "Content-Type": "application/x-www-form-urlencoded"
                "Content-Type": "application/json; charset=utf-8"
        ]
    }
    
    /// 下载后的保存路径
    var localLocation: URL {
        switch self {
        case .downloadFile(let url):
            let name = url.components(separatedBy: "/").last ?? ""
            return Self.kDefaultDownloadDir.appendingPathComponent(name)
        default:
            return URL(fileURLWithPath: "")
        }
    }
    // 定义下载的DownloadDestination(不改变文件名，同名文件不会覆盖)
    var downloadDestination: DownloadDestination {
        { _, _ in
            return (localLocation, [.removePreviousFile, .createIntermediateDirectories])
        }
    }

    /// 参数
    public var parameters: [String: Any] {
        switch self {
        case .login(let account, let password):
            return ["mobile": account, "password": password]
        default:
            return [:]
        }
    }

    /// 网络请求时是否显示loading...
    public var showProgress: Bool {
        true
    }

    public var responsePath: String? {
        nil
    }
}
