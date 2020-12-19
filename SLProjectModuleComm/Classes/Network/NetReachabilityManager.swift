//
//  NetReachabilityManager.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/11.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

enum NetworkReachabilityStatus {
    case unknown
    case notReachable
    case cellular
    case WiFi

    var statusStr: String {
        switch self {
        case .unknown:
            return "未识别的网络"
        case .notReachable:
            return "不可用的网络(未连接)"
        case .cellular:
            return "数据"
        case .WiFi:
            return "WiFi"
        }
    }
}

class NetReachabilityManager: NSObject {

    /// 当前网络状态
    let cur_status = BehaviorRelay<NetworkReachabilityStatus>(value: .WiFi)

    static let shared = NetReachabilityManager()

    private let netManager = NetworkReachabilityManager()

    func listen() {
        let manager = NetworkReachabilityManager()
        manager?.startListening { [weak self] status in
            switch status {
            case .unknown:
                self?.cur_status.accept(.unknown)
            case .notReachable:
                self?.cur_status.accept(.notReachable)
            case .reachable:
                if manager?.isReachableOnCellular ?? false {
                    self?.cur_status.accept(.cellular)
                } else if manager?.isReachableOnEthernetOrWiFi ?? false {
                    self?.cur_status.accept(.WiFi)
                }
            }
        }
    }
}
