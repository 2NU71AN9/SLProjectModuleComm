//
//  FGSearchHeaderView.swift
//  FBMerchant
//
//  Created by Kevin on 2019/7/1.
//  Copyright © 2019 cn. All rights reserved.
//

import UIKit
import RxSwift
import SLIKit

class FGSearchHeaderView: UIView {

    let searchSubject = PublishSubject<String>()
    var cancelCallback: (() -> Void)?

    private let bag = DisposeBag()
    @IBOutlet weak var searchTF: UITextField! {
        didSet {
            searchTF.rx.text.orEmpty
                .distinctUntilChanged()
                .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                .bind(to: searchSubject)
                .disposed(by: bag)
        }
    }
    @IBOutlet weak var cancelBtn: UIButton!
    @IBAction func cancelAction(_ sender: Any) {
        cancelCallback?()
    }
    
    static func loadView() -> FGSearchHeaderView {
        let view = FGSearchHeaderView.sl.loadNib()?.base
        return view ?? FGSearchHeaderView()
    }
}
