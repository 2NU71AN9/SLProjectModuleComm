//
//  Enum.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/28.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

public enum FontPingFang: String {
    case 极细 = "PingFangSC-Ultralight"
    case 纤细 = "PingFangSC-Thin"
    case 细 = "PingFangSC-Light"
    case 常规 = "PingFangSC-Regular"
    case 中黑 = "PingFangSC-Medium"
    case 中粗 = "PingFangSC-Semibold"

    static func fontName(_ index: Int) -> FontPingFang {
        switch index {
        case 1:
            return .极细
        case 2:
            return .纤细
        case 3:
            return .细
        case 4:
            return .常规
        case 5:
            return .中黑
        case 6:
            return .中粗
        default:
            return .常规
        }
    }

    func size(_ size: CGFloat) -> UIFont? {
        UIFont(name: rawValue, size: size)
    }
}
