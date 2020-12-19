//
//  ViewLifeProtocol.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

protocol ViewLifeProtocol {
    /// init时调用
    func config()
    func viewDidLoad()
}

extension ViewLifeProtocol where Self: UIView {
    func config() {
        backgroundColor = ColorBox.view_background.color
    }
    func viewDidLoad() {}
}
