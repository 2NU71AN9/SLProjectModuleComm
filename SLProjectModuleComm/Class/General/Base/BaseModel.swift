//
//  BaseModel.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import HandyJSON
import RxSwift

class BaseModel: NSObject, HandyJSON {
    let haveUploadEvent = PublishSubject<Bool>()
    let bag = DisposeBag()
    required override init() { }

    func copy<T: HandyJSON>(_ type: T.Type) -> T? {
        if let json = toJSON(),
            let model = T.deserialize(from: json) {
            return model
        }
        return nil
    }

    class func upload<T: BaseModel>(_ object: T?, from: T?) {
        guard var object = object, let from = from else { return }
        JSONDeserializer.update(object: &object, from: from.toJSON())
        object.haveUploadEvent.onNext(true)
    }

    func mapping(mapper: HelpingMapper) {

    }
    func didFinishMapping() {

    }
}
