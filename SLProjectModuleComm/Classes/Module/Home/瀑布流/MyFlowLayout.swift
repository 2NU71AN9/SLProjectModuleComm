//
//  MyFlowLayout.swift
//  CustomFlowLayout
//
//  Created by 孙梁 on 2020/12/7.
//

import UIKit

class MyFlowLayout: UICollectionViewFlowLayout {
    
    var itemHeightArr: [CGFloat] = []
    var attributesArr: [UICollectionViewLayoutAttributes] = []
    
}

extension MyFlowLayout {
    func flowLayoutWithItemWidth(_ itemWidth: CGFloat, _ itemHeightArray: [CGFloat]) {
        itemSize = CGSize(width: itemWidth, height: 0)
        itemHeightArr = itemHeightArray
        collectionView?.reloadData()
    }
    
    override func prepare() {
        super.prepare()
        guard itemHeightArr.count > 0 else { return }
        let itemInRow = (collectionViewContentSize.width - sectionInset.left - sectionInset.right + minimumInteritemSpacing) / (itemSize.width + minimumInteritemSpacing)
        var columnLengthArr = [CGFloat](repeating: 0, count: Int(itemInRow))
        var tempArr: [UICollectionViewLayoutAttributes] = []
        for (index, value) in itemHeightArr.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            guard let attris = layoutAttributesForItem(at: indexPath) else { return }
            var recFrame = attris.frame
            recFrame.size.height = value
            var shortNum = 0
            var shortLength = columnLengthArr[shortNum]
            for (index, value) in columnLengthArr.enumerated() {
                if value < shortLength {
                    shortNum = index
                    shortLength = value
                }
            }
            recFrame.origin.x = sectionInset.left + (itemSize.width + minimumInteritemSpacing) * CGFloat(shortNum)
            recFrame.origin.y = shortLength + minimumLineSpacing
            columnLengthArr[shortNum] = recFrame.maxY
            attris.frame = recFrame
            tempArr.append(attris)
        }
        attributesArr = tempArr
        
        var longNum = 0
        var longLength = columnLengthArr[longNum]
        for (index, value) in columnLengthArr.enumerated() {
            if value > longLength {
                longNum = index
                longLength = value
            }
        }
        let nRows = (CGFloat(itemHeightArr.count) + itemInRow - 1) / itemInRow
        itemSize = CGSize(width: itemSize.width, height: (longLength + minimumLineSpacing) / nRows - minimumLineSpacing)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        attributesArr
    }
}
