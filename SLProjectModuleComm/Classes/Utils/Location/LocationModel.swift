//
//  LocationModel.swift
//  PGJManager-iOS
//
//  Created by Kevin on 2019/1/11.
//  Copyright © 2019 fg. All rights reserved.
//

import UIKit
import HandyJSON
import CoreLocation

class LocationModel: BaseModel {
    var location: CLLocation?
    var placemark: CLPlacemark?

//    var gaoDeLocation: CLLocation? {
//        if let coordinate = location?.coordinate {
//            let coor = AMapCoordinateConvert(coordinate, .GPS)
//            return CLLocation(latitude: coor.latitude, longitude: coor.longitude)
//        }
//        return nil
//    }
}

extension LocationModel {
    /// 地址
    var addressDesc: String {
        placemark?.locality ?? placemark?.name ?? placemark?.country ?? defaultCity
    }
    /// 经度
    var longitude: Double {
        location?.coordinate.longitude ?? defaultLongitude
    }
    /// 纬度
    var latitude: Double {
        location?.coordinate.latitude ?? defaultLatitude
    }
}
