//
//  PayResultProtocol.swift
//  SLAppPay
//
//  Created by 孙梁 on 2020/8/10.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

public protocol PayResultProtocol: NSObjectProtocol {
    func paySuccess()
    func payFailure()
    func unKnow()
}
