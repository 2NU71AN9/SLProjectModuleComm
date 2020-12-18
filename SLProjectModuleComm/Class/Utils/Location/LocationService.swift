//
//  LocationService.swift
//  FgIphone
//
//  Created by Chu Guimin on 2018/5/24.
//  Copyright © 2018年 fg. All rights reserved.
//

import UIKit
import CoreLocation
import RxCocoa

final class LocationService: NSObject {

    let locationSubject = BehaviorRelay<(Error?, LocationModel?)>(value: (nil, nil))
    var afterUpdatedLocationAction: ((LocationModel?) -> Void)?
    var currentLocation: CLLocation?
    var address: String?
    var altitude: String?

    static let shared = LocationService()
    private let geocoder = CLGeocoder()
    private lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.desiredAccuracy = kCLLocationAccuracyBest // 精确的读取位置信息，消耗电量较多
        manager.activityType = .fitness //  此设置会智能调节：例如当你过马路或者停止的时候，它会智能的更改配置帮用户节省电量
        manager.distanceFilter = 10.0   // 重新定位的最小变化距离。不影响电量，位移信息不是一条直线而是有很多锯齿，高精度的 distanceFilter 可以减少锯齿，给你一个更精确地轨迹，但是，太高的精度值会让你的轨迹像素化(看到很多马赛克)，所以10m是一个相对比较合适的值
//        manager.requestAlwaysAuthorization()
        //        manager.pausesLocationUpdatesAutomatically = false
//        manager.allowsBackgroundLocationUpdates = true

        return manager
    }()

    class func turnOn() {
        if CLLocationManager.locationServicesEnabled() {
            print("begin updating location")
            shared.locationManager.startUpdatingLocation()
        }
    }
    class func turnOff() {
        shared.locationManager.stopUpdatingLocation()
    }

    class func requestLocationOnce(complete: ((LocationModel?) -> Void)?) {
        shared.locationManager.requestLocation()
        shared.afterUpdatedLocationAction = complete
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loModel = LocationModel()
        guard let newLocation = locations.last else { return }
        loModel.location = newLocation

        // 尽量减少对服务器的请求和反向查询
        if let oldLocation = currentLocation {
            let distance = newLocation.distance(from: oldLocation)
            if distance < 1000 { return }
        }

        print(String(format: "海拔：%.0fM", newLocation.altitude))
        altitude = String(format: "%.0fM", newLocation.altitude)
        currentLocation = newLocation

        geocoder.reverseGeocodeLocation(newLocation) { [weak self] (placemarks, error) in
            DispatchQueue.global().sync { [weak self] in
                if error != nil {
                    print("self reverse geocode fail: \(String(describing: error?.localizedDescription))")
                    self?.locationSubject.accept((error, nil))
                    self?.afterUpdatedLocationAction?(nil)
                } else {
                    LocationService.turnOff()
                    if let placemarks = placemarks {
                        if let firstPlacemark = placemarks.first {
                            loModel.placemark = firstPlacemark
                            self?.address = firstPlacemark.locality ?? (firstPlacemark.name ?? firstPlacemark.country)
                            // 地理位置更改后调用
                            self?.locationSubject.accept((nil, loModel))
                            self?.afterUpdatedLocationAction?(loModel)
                        }
                    }
                }
            }
        }
    }
}
