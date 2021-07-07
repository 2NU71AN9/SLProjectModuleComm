//
//  StarViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/7.
//

import UIKit
import Cosmos

class StarViewController: BaseViewController {
    
    @IBOutlet weak var starView1: CosmosView!
    @IBOutlet weak var starView2: CosmosView!
    @IBOutlet weak var starView3: CosmosView!
    @IBOutlet weak var starView4: CosmosView!
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderAction(_ sender: UISlider) {
        setRating()
    }
}

// MARK: - LifeCyle
extension StarViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "星星评分"
        setRating()
    }
    
    private func setRating() {
        starView1.rating = Double(slider.value) * Double(starView1.settings.totalStars)
        starView1.text = String(format: "%.1f", starView1.rating)
        starView2.rating = Double(slider.value) * Double(starView2.settings.totalStars)
        starView3.rating = Double(slider.value) * Double(starView3.settings.totalStars)
        starView4.rating = Double(slider.value) * Double(starView4.settings.totalStars)
    }
}
