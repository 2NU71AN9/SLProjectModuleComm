//
//  Ex_Label.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/9/7.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SLIKit

extension Reactive where Base: UILabel {
    var counting: Binder<(String, Bool)> {
        Binder(base) { (label, value) in
            label.text = value.0
            label.isUserInteractionEnabled = value.1
            label.backgroundColor = value.1 ? R.color.view_able1()~~ : R.color.view_able_no1()~~
            label.textColor = .white
        }
    }
}
