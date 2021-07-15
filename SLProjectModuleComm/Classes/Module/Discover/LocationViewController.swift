//
//  LocationViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/7.
//

import UIKit
import SLIKit

class LocationViewController: BaseViewController {
    
    @IBOutlet weak var label: UILabel!
    
    private var location: Location? {
        didSet {
            guard let location = location else {
                label.text = "定位失败"
                return
            }
            label.text = """
            经度: \(location.longitude)
            纬度: \(location.latitude)
            地址: \(location.addressDesc ?? "")
            """
        }
    }
    
    deinit {
        SL.location.stop()
    }
}

// MARK: - LifeCyle
extension LocationViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.discover_location.text
        SL.location.minMeter(1).start(true).complete { [weak self] location in
            self?.location = location
        }
    }
}
