//
//  HXPPImageCell.swift
//  DAOAProject
//
//  Created by 孙梁 on 2021/4/8.
//

import UIKit
import HXPhotoPicker
import RxCocoa
import RxSwift
import SLIKit

class HXPhotoPickerTableCellModel {
    
    let endSelectedPhotosCountSubject = BehaviorRelay<Int>(value: 0)
    let endSelectedPhotosject = BehaviorRelay<[HXPhotoModel]>(value: [])
    var photoViewHeight: CGFloat = ((SL.SCREEN_WIDTH - 30) - 3 * (3 - 1)) / 3
    
    var endSelectedPhotos = [HXPhotoModel]() {
        didSet {
            endSelectedPhotosCountSubject.accept(endSelectedPhotos.count)
            endSelectedPhotosject.accept(endSelectedPhotos)
        }
    }
    
    var hashCodes: [String]? = [] {
        didSet {
            hashCodes?.removeAll { $0.count <= 0 }
//            let photos = hashCodes?.compactMap { hashCode -> HXPhotoModel? in
//                let url = URL(string: FGDataManager.shared.qiNiuPrefix~~ + hashCode)
//                let model = HXPhotoModel(imageURL: url)
//                model?.networkPhotoUrl = url
//                model?.qiNiuToken = QiniuToken(token: hashCode, hashCodeName: hashCode, originalFilename: "")
//                return model
//                } ?? []
//            if photos.count > 0 {
//                endSelectedPhotos += photos
//            }
        }
    }
    
    func clear() {
        endSelectedPhotos.removeAll()
    }
}

class HXPPImageCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var photoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var photoView: HXPhotoView! {
        didSet {
            photoView.collectionView.bounces = false
            photoView.delegate = self
            photoView.spacing = 3.0
        }
    }
    
    var photoViewModel = HXPhotoPickerTableCellModel() {
        didSet {
            photoViewManager.change(afterSelectedArray: photoViewModel.endSelectedPhotos)
            photoViewManager.change(afterSelectedPhotoArray: photoViewModel.endSelectedPhotos)
            photoView.manager = photoViewManager
            photoView.refreshView()
            
            // 计算photoView的高度
            let selectedPhotosCount = photoViewModel.endSelectedPhotos.count
            // 行数
            var rows: CGFloat = 1.0
            if selectedPhotosCount < photoMaxNum {
                // 当选择的图片小于最大值时
                if selectedPhotosCount % 3 == 0 {
                    rows = CGFloat(selectedPhotosCount / 3 + 1)
                } else {
                    rows = ceil(CGFloat(selectedPhotosCount) / 3.0)
                }
            } else {
                rows = ceil(CGFloat(selectedPhotosCount) / 3.0)
            }
            
            photoViewHeight.constant = rows * defaultPhotoViewHeight + (rows - 1) * 3.0
        }
    }
    
    /// 只是展示图片
    var onlyShow = false {
        didSet {
            countLabel.isHidden = onlyShow
            photoView.showAddCell = !onlyShow
            photoView.editEnabled = !onlyShow
            photoView.hideDeleteButton = onlyShow
        }
    }
    
    var photoMinNum: Int = 0 {
        didSet {
            countLabel.text = "至少\(photoMinNum)张,至多\(photoMaxNum)张"
        }
    }
    // 最大选择数量
    var photoMaxNum: Int = 9 {
        didSet {
            countLabel.text = photoMinNum > 0
                ? "至少\(photoMinNum)张,至多\(photoMaxNum)张"
                : "至多\(photoMaxNum)张"
            photoViewManager.configuration.photoMaxNum = UInt(photoMaxNum)
        }
    }
    
    var hxPhotoViewChangeHeightClosure: (() -> Void)?
    
    lazy var photoViewManager: HXPhotoManager = {
        let type = HXPhotoManagerSelectedType.photo
        let manager = HXPhotoManager(type: type)!
        // 选择照片列表界面是否添加相机
        manager.configuration.openCamera = true
        // 是否隐藏原图按钮
        manager.configuration.hideOriginalBtn = true
        // 是否隐藏编辑按钮
        manager.configuration.photoCanEdit = true
        // 是否按日期分隔照片
        manager.configuration.showDateSectionHeader = false
        // 是否照片视频同时选择
        manager.configuration.selectTogether = false
        // 最多可选择照片数
        manager.configuration.photoMaxNum = 9
        // 拍照保存到相册
        manager.configuration.saveSystemAblum = true
        manager.configuration.clarityScale = 5.0
        manager.configuration.movableCropBox = true
        manager.configuration.movableCropBoxEditSize = true
        manager.configuration.movableCropBoxCustomRatio = CGPoint.zero
        return manager
    }()
    
    private var defaultPhotoViewHeight: CGFloat = ((SL.SCREEN_WIDTH - 30) - 3 * (3 - 1)) / 3
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoViewManager.configuration.movableCropBoxCustomRatio = CGPoint.zero
    }
}

extension HXPPImageCell: HXPhotoViewDelegate {
    func photoViewChangeComplete(_ photoView: HXPhotoView, allAssetList: [PHAsset], photoAssets: [PHAsset], videoAssets: [PHAsset], original isOriginal: Bool) {
        photoViewModel.endSelectedPhotos = photoViewManager.afterSelectedPhotoArray() as? [HXPhotoModel] ?? []
    }
    func photoView(_ photoView: HXPhotoView, updateFrame frame: CGRect) {
        hxPhotoViewChangeHeightClosure?()
    }
}
