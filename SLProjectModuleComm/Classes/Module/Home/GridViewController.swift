//
//  GridViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/5.
//

import UIKit
import TTGTagCollectionView

class GridViewController: BaseViewController {

    @IBOutlet weak var tagView1: TTGTextTagCollectionView!
    @IBOutlet weak var tagView2: TTGTextTagCollectionView!
    
    private lazy var tags: [TTGTextTag] = {
        let strings = ["AutoLayout", "dynamically", "calculates", "the", "size", "and", "position",
                       "of", "all", "the", "views", "in", "your", "view", "hierarchy", "based",
                       "on", "constraints", "placed", "on", "those", "views"]
        return strings.compactMap { text -> TTGTextTag in
            let content = TTGTextTagStringContent.init(text: text)
            content.textColor = UIColor.black
            content.textFont = UIFont.boldSystemFont(ofSize: 20)

            let normalStyle = TTGTextTagStyle.init()
            normalStyle.backgroundColor = UIColor.white
            normalStyle.extraSpace = CGSize.init(width: 8, height: 8)

            let selectedStyle = TTGTextTagStyle.init()
            selectedStyle.backgroundColor = UIColor.green
            selectedStyle.extraSpace = CGSize.init(width: 8, height: 8)

            let tag = TTGTextTag()
            tag.content = content
            tag.style = normalStyle
            tag.selectedStyle = selectedStyle
            return tag
        }
    }()
}

// MARK: - LifeCyle
extension GridViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "GridView"
        tagView1.add(tags)
        tagView1.reload()
        tagView2.add(tags)
        tagView2.reload()
    }
}
