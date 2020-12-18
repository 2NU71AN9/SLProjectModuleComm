//
//  SLVisitorViewController.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/12.
//

import UIKit

class SLVisitorViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: visitorPageImage)
        }
    }
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            descLabel.text = visitorPageDesc
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        AccountServicer.service.goToLogin()
    }
}
