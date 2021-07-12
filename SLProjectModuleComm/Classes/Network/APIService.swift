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
    /// 上传
    case uploadFile(_ data: Data)
    
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
        #if DEBUG
        urlStr = APIService.kDebugBaseURL
        #else
        urlStr = APIService.kReleaseBaseURL
        #endif
        return URL(string: urlStr) ?? URL(fileURLWithPath: "")
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
        switch self {
        case .downloadFile:
            return .downloadDestination(downloadDestination)
        case .login:
            return .requestCompositeData(bodyData: Data(), urlParameters: parameters)
//        case .uploadImage(let images):
//            return .uploadMultipart(images.compactMap {$0.formData})
        case .uploadFile(let data):
            return .uploadMultipart([MultipartFormData(provider: .data(data), name: "file", fileName: "123.images")])
        default:
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }

    public var headers: [String: String]? {
        let token = AccountServicer.service.token ?? ""
        let authorization = token.isEmpty ? "" : "Bearer " + token
        return ["Authorization": authorization,
//                "Content-Type": "application/x-www-form-urlencoded"
                "Content-Type": "application/json; charset=utf-8"
        ]
    }
    public var parameterEncoding: ParameterEncoding {
        switch self {
        default:
//            return URLEncoding.default // application/x-www-form-urlencoded
            return JSONEncoding.default // application/json; charset=utf-8
        }
    }

    /// 参数
    public var parameters: [String: Any] {
        var parameters: [String: Any] = [:]
        switch self {
        case .login(let account, let password):
            parameters = ["mobile": account, "password": password]
        default:
            break
        }
        for i in commParameters {
            parameters[i.key] = i.value
        }
        return parameters
    }
    
    /// 公共参数
    public var commParameters: [String: Any?] {
        ["token": AccountServicer.service.token]
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

    /// 网络请求时是否显示loading...
    public var showProgress: Bool {
        true
    }

    public var responsePath: String? {
        nil
    }
}
