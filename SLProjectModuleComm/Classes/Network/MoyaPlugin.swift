//
//  MoyaPlugin.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/11.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON
import SVProgressHUD
import PKHUD

/// Moya插件: 网络请求时显示loading...
internal final class ShowProgress: PluginType {

    /// 在发送之前调用来修改请求
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.timeoutInterval = 20 // 超时时间
        return request
    }

    /// 在通过网络发送请求(或存根)之前立即调用
    func willSend(_ request: RequestType, target: TargetType) {
        guard let target = target as? APIService else { return }
        /// 判断是否需要显示
        if target.showProgress {
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
        } else {
            DispatchQueue.main.async {
                SVProgressHUD.show(UIImage(), status: nil)
            }
        }
    }

    /// 在收到响应之后调用，但是在MoyaProvider调用它的完成处理程序之前调用
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }

    /// 调用以在完成之前修改结果
    //    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {}
}

/// Moya插件: 判断网络状态
internal final class CheckNetStatus: PluginType {
    /// 在通过网络发送请求(或存根)之前立即调用
    func willSend(_ request: RequestType, target: TargetType) {
        if NetReachabilityManager.shared.cur_status.value == .notReachable ||
            NetReachabilityManager.shared.cur_status.value == .unknown {
            NetworkHandler.APIProvider.session.cancelAllRequests()
            DispatchQueue.main.async {
                HUD.flash(.label("网络错误,请检查网络设置"), delay: 2)
            }
        }
    }
}

/// Moya插件: 网络请求时显示loading...
internal final class ShowCoverProgress: PluginType {

    static let kRequestTargetBegin = PublishSubject<APIService>()
    static let kRequestTargetEnd = PublishSubject<APIService>()

    /// 在通过网络发送请求(或存根)之前立即调用
    func willSend(_ request: RequestType, target: TargetType) {
        guard let target = target as? APIService else { return }
        Self.kRequestTargetBegin.onNext(target)
    }

    /// 在收到响应之后调用，但是在MoyaProvider调用它的完成处理程序之前调用
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let target = target as? APIService else { return }
        Self.kRequestTargetEnd.onNext(target)
    }
}

/// Moya插件: 控制台打印网络请求信息
internal final class Print: PluginType {
    /// 在通过网络发送请求(或存根)之前立即调用
    func willSend(_ request: RequestType, target: TargetType) {
        guard let target = target as? APIService else { return }
        print("""
            #############↓网络请求参数↓#################
            \(target.baseURL)\(target.path)
            \(target.parameters)
            #############↑网络请求参数↑#################
            """)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let target = target as? APIService else { return }
        print("#############↓网络请求数据↓#################")
        switch result {
        case .success(let jsonValue):
            if let jsonStr = try? jsonValue.mapJSON() {
                print(String(format: "%@%@==>%@", target.baseURL.absoluteString, target.path, JSON(jsonStr).description))
            } else {
                print(String(format: "%@%@==>数据错误", target.baseURL.absoluteString, target.path))
            }
        case .failure(let error):
            print(String(format: "%@%@==>%@", target.baseURL.absoluteString, target.path, error.errorDescription ?? "请求失败"))
        }
        print("#############↑网络请求数据↑#################")
    }
}
