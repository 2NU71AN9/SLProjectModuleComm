//
//  Color.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

public enum ColorBox: String {
    case prime
    case view_background
    case view_able1
    case view_able_no1
    case text_gray1 // 越大颜色越深
    case text_gray2
    case text_gray3
    case text_gray4
    case text_gray5
    case view_gray1 // 越大颜色越深
    case view_gray2
    case view_gray3
    case view_gray4
    case view_gray5
    
    var color: UIColor {
        UIColor(named: rawValue) ?? .white
    }
}
