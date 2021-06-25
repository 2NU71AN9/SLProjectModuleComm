//
//  QRCodeViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/25.
//

import UIKit
import SLIKit

class QRCodeViewController: BaseViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBAction func editDidEnd(_ sender: UITextField) {
        guard let text = textField.text else {
            imageView1.image = nil
            imageView2.image = nil
            return
        }
        let image1 = SL.tools.makeQRCode(content: text, size: imageView1.frame.size, codeColor: .red, bgColor: .yellow, logo: R.image.cry100(), logoSize: CGSize(width: 30, height: 30))
        imageView1.image = image1
        
        let image2 = SL.tools.makeBarCode(content: text, size: imageView2.frame.size)
        imageView2.image = image2
    }
}

// MARK: - LifeCyle
extension QRCodeViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "生成二维码"
    }
}
