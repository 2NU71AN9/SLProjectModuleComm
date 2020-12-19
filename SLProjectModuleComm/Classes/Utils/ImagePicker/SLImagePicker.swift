//
//  SLImagePicker.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/9/8.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import HXPhotoPicker
import SLSupportLibrary

class SLImagePicker: NSObject {

    class func selectPortrait(_ complete: @escaping (HXPhotoModel?) -> Void) {
        let configuration = HXPhotoConfiguration()
        configuration.openCamera = true
        configuration.editAssetSaveSystemAblum = false
        configuration.singleSelected = true
        configuration.singleJumpEdit = true
        configuration.clarityScale = 5.0
        configuration.photoEditConfigur.aspectRatio = .type_1x1
        guard let photoManager = HXPhotoManager(type: HXPhotoManagerSelectedType.photo) else {
            return
        }
        photoManager.configuration = configuration
        cur_visible_vc?.hx_presentSelectPhotoController(with: photoManager, didDone: { (_, photoList, _, _, _, _) in
            complete(photoList?.first)
        }, cancel: { (_, _) in

        })
    }

    class func selectPortrait(_ complete: @escaping (UIImage?) -> Void) {
        let configuration = HXPhotoConfiguration()
        configuration.openCamera = true
        configuration.editAssetSaveSystemAblum = false
        configuration.singleSelected = true
        configuration.singleJumpEdit = true
        configuration.clarityScale = 5.0
        configuration.photoEditConfigur.aspectRatio = .type_1x1
        guard let photoManager = HXPhotoManager(type: HXPhotoManagerSelectedType.photo) else {
            return
        }
        photoManager.configuration = configuration
        cur_visible_vc?.hx_presentSelectPhotoController(with: photoManager, didDone: { (_, photoList, _, _, _, _) in
            photoList?.first?.requestFinalImage { (image) in
                complete(image)
            }
        }, cancel: { (_, _) in

        })
    }

    class func selectImage(_ complete: @escaping (UIImage?) -> Void) {
        let configuration = HXPhotoConfiguration()
        configuration.openCamera = true
        configuration.editAssetSaveSystemAblum = false
        configuration.singleSelected = true
        configuration.singleJumpEdit = true
        configuration.clarityScale = 5.0
        configuration.photoEditConfigur.aspectRatio = .type_Custom
        guard let photoManager = HXPhotoManager(type: HXPhotoManagerSelectedType.photo) else {
            return
        }
        photoManager.configuration = configuration
        cur_visible_vc?.hx_presentSelectPhotoController(with: photoManager, didDone: { (_, photoList, _, _, _, _) in
            photoList?.first?.requestFinalImage { (image) in
                complete(image)
            }
        }, cancel: { (_, _) in

        })
    }
}
