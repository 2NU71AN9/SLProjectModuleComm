//
//  Ex_Reactive.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/21.
//

import UIKit
import RxCocoa
import RxSwift
import SLIKit

/// Reactive扩展

extension Reactive where Base: UILabel {
    /// 倒计时用
    var counting: Binder<(String, Bool)> {
        Binder(base) { (label, value) in
            label.text = value.0
            label.isUserInteractionEnabled = value.1
            label.backgroundColor = value.1 ? R.color.view_able1()~~ : R.color.view_able_no1()~~
            label.textColor = .white
        }
    }
}

extension Reactive where Base: UIButton {
    /// 按钮是否可用
    var da_isEnabled: Binder<Bool> {
        Binder(base) { (btn, value) in
            btn.isEnabled = value
            btn.backgroundColor = value ? R.color.view_able1()~~ : R.color.view_able_no1()~~
        }
    }
}
