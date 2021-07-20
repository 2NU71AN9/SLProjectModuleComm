//
//  VideoPlayerCell.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/20.
//

import UIKit
import SLIKit

class VideoPlayerCell: UITableViewCell {
    
    var playVideoAtIndexPath: ((IndexPath) -> Void)?
    
    @IBOutlet weak var contentImageView: UIImageView! {
        didSet {
            contentImageView.tag = kPlayerViewTag
            contentImageView.sl.addTarget(self, action: #selector(playAction))
        }
    }
    @IBOutlet weak var label: UILabel!
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var model: VideoModel? {
        didSet {
            guard let model = model else { return }
            contentImageView.kf.setImage(with: URL(string: model.thumbnail_url~~))
            label.text = model.title
        }
    }
    
    @objc private func playAction() {
        playVideoAtIndexPath?(indexPath)
    }
}
