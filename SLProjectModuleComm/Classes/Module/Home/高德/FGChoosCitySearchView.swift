//
//  FGChoosCitySearchView.swift
//  FBMerchant
//
//  Created by Kevin on 2019/7/1.
//  Copyright © 2019 cn. All rights reserved.
//

import UIKit
import RxSwift

class FGChoosCitySearchView: UIView {

    var chooseCityCallback: (() -> Void)?
    var chooseAddressCallback: (() -> Void)?
    var cancelCallback: (() -> Void)?
    
    var city: String? {
        didSet {
            chooseCityBtn.setTitle(city, for: .normal)
        }
    }
    
    let bag = DisposeBag()
    
    @IBOutlet weak var chooseCityBtn: UIButton!
    @IBOutlet weak var searchView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(searchAction))
            searchView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func chooseCityAction(_ sender: Any) {
        chooseCityCallback?()
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        cancelCallback?()
    }
    
    @objc private func searchAction() {
        chooseAddressCallback?()
    }
    
    static func loadView() -> FGChoosCitySearchView {
        let view = FGChoosCitySearchView.sl.loadNib()?.base
        return view ?? FGChoosCitySearchView()
    }
}
