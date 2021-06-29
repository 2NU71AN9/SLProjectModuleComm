//
//  ImagePicker1ViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/29.
//

import UIKit
import SLIKit
import JXSegmentedView

class ImagePicker1ViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func btn1Action(_ sender: UIButton) {
        SL.pickerImage?.maxNum(1).aspectRatio(.type_Custom).show { [weak self] models in
            self?.imageView.image = models?.first?.thumbPhoto ?? models?.first?.previewPhoto
        }
    }
    
    @IBAction func btn2Action(_ sender: UIButton) {
        SL.pickerImage?.selectPortrait { [weak self] image, _ in
            self?.imageView.image = image
        }
    }
}

// MARK: - LifeCyle
extension ImagePicker1ViewController {
    override func setMasterView() {
        super.setMasterView()
        naviBarHidden = true
    }
}

// MARK: - JXPagingViewListViewDelegate
extension ImagePicker1ViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView { view }
}
