//
//  WaterfallFlowViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit

class WaterfallFlowViewController: BaseViewController {
    
    private lazy var layout: MyFlowLayout = {
        let layout = MyFlowLayout()
        layout.flowLayoutWithItemWidth(80, itemHeightArr)
        var nCountCell = (self.view.bounds.width - 10) / (layout.itemSize.width + 10)
        // 平均后的间距
        var fSpacing = (self.view.bounds.width - layout.itemSize.width * nCountCell) / (nCountCell + 1)
        layout.minimumInteritemSpacing = fSpacing
        layout.minimumLineSpacing = fSpacing
        layout.sectionInset = UIEdgeInsets(top: fSpacing, left: fSpacing, bottom: fSpacing, right: fSpacing)
        return layout
    }()
    
    private lazy var collectView: UICollectionView = {
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    
    private lazy var itemHeightArr: [CGFloat] = {
        var array: [CGFloat] = []
        for _ in 0 ..< 60 {
            array.append(CGFloat(40 + arc4random() % 40))
        }
        return array
    }()
}

// MARK: - LifeCyle
extension WaterfallFlowViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "瀑布流"
        view.addSubview(collectView)
    }
}

extension WaterfallFlowViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemHeightArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = R.color.prime()
        var label = cell.viewWithTag(10) as? UILabel
        if label == nil {
            label = UILabel()
            label?.textAlignment = .center
            label?.adjustsFontSizeToFitWidth = true
            label?.tag = 10
            label?.font = UIFont.systemFont(ofSize: 80)
            cell.addSubview(label!)
        }
        label?.frame = cell.bounds
        label?.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row + 1)
    }
}
