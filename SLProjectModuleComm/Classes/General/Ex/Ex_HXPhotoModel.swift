//
//  Ex_HXPhotoModel.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/9/8.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import HXPhotoPicker

extension HXPhotoModel {
    static let kQiNiuImageKey = UnsafeRawPointer(bitPattern: "qnImageKey".hashValue)!
    static let kUploadingKey = UnsafeRawPointer(bitPattern: "uploadingKey".hashValue)!
    static let kFinalImageKey = UnsafeRawPointer(bitPattern: "finalImageKey".hashValue)!

//    var qiNiuImage: QiniuImage? {
//        get {
//            return objc_getAssociatedObject(self, HXPhotoModel.qiNiuImageKey) as? QiniuImage
//        }
//        set {
//            if let qnToken = newValue {
//                objc_setAssociatedObject(self, HXPhotoModel.qiNiuImageKey, qnToken, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
//    }

    var uploading: Bool {
        get {
            objc_getAssociatedObject(self, HXPhotoModel.kUploadingKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, HXPhotoModel.kUploadingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var finalImage: UIImage? {
        get {
            objc_getAssociatedObject(self, HXPhotoModel.kFinalImageKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, HXPhotoModel.kFinalImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func requestFinalImage(_ complete: @escaping (UIImage?) -> Void) {
        if let localIdentifier = localIdentifier, asset == nil {
            let options = PHFetchOptions()
            asset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: options).firstObject
        }
        if previewPhoto != nil {
            finalImage = previewPhoto
            complete(previewPhoto)
        } else if thumbPhoto != nil {
            finalImage = thumbPhoto
            complete(thumbPhoto)
        } else {
//            requestThumbImage(with: CGSize(width: 1080, height: 1920)) { [weak self] (image, model, info) in
//                self?.finalImage = image
//                complete(image)
//            }
        }
    }

    func PHAsset2Image(asset: PHAsset?) -> UIImage? {
        guard let asset = asset else { return nil }
        var image: UIImage?
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        // 按照PHImageRequestOptions指定的规则取出图片
        imageManager.requestImage(for: asset, targetSize: CGSize.init(width: 1080, height: 1920), contentMode: .aspectFill, options: imageRequestOption) { (result, _) -> Void in
            image = result
        }
        return image
    }
}
