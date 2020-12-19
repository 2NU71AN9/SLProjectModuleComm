//
//  BaseTableViewCell.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/9/7.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {

    let bag = DisposeBag()
    var resetBag = DisposeBag() // 每次复用会重置

    override func prepareForReuse() {
        super.prepareForReuse()
        resetBag = DisposeBag()
    }
}
