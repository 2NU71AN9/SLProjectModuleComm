//
//  BaseView.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import RxSwift

class BaseView: UIView, ViewLifeProtocol {

    let bag = DisposeBag()
    let refreshEvent = PublishSubject<Bool>()
    let loadMoreEvent = PublishSubject<Bool>()

    weak var parentVC: BaseViewController?

    var weakself: BaseView? {
        weak var weakself = self
        return weakself
    }

    public required init() {
        super.init(frame: CGRect.zero)
        config()
        bind()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    func bind() {
        
    }

    func viewDidLoad() {

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
