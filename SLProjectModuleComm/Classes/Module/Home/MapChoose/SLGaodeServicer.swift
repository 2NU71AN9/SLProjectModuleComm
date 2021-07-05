//
//  SLGaodeServicer.swift
//  DAOAProject
//
//  Created by 孙梁 on 2020/12/28.
//

import UIKit
import AMapFoundationKit
import AMapLocationKit
import RxSwift

/// 高德相关
class SLGaodeServicer: NSObject {
    
    static let shared = SLGaodeServicer()
    private override init() {
        super.init()
    }
    
    let locationManager = AMapLocationManager()
    /// 定位到的位置
    let locationSubject = PublishSubject<(CLLocation, AMapLocationReGeocode?)>()
    
    /// 注册
    func regist(_ appKey: String) {
        AMapServices.shared()?.enableHTTPS = true
        AMapServices.shared()?.apiKey = appKey
        locationManager.delegate = self
        // 定位最小更新距离 m
        locationManager.distanceFilter = 5
        // 是否返回逆地理信息
        locationManager.locatingWithReGeocode = true
        locationManager.startUpdatingLocation()
    }
    
    // 开始持续定位
    func startLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // 停止持续定位
    func stopLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension SLGaodeServicer: AMapLocationManagerDelegate {
    /// 只返回经纬度
//    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
//        locationSubject.onNext(location)
//    }
    
    /// 可以在回调位置的同时回调逆地理编码信息, 和上面的回调方法只能2选1
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        locationSubject.onNext((location, reGeocode))
    }
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
}
