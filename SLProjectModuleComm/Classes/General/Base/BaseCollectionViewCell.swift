//
//  BaseCollectionViewCell.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/14.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    let bag = DisposeBag()
    var resetBag = DisposeBag() // 每次复用会重置

    override func prepareForReuse() {
        super.prepareForReuse()
        resetBag = DisposeBag()
    }
}
