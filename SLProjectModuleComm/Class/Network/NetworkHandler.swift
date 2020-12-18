//
//  NetworkHandler.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/11.
//

import UIKit
import Moya
import HandyJSON
import RxSwift
import SwiftyJSON
import Alamofire

class NetworkHandler: NSObject {

    static let APIProvider = MoyaProvider<APIService>(plugins: [ShowProgress(), CheckNetStatus()])

    public static func request(_ target: APIService) -> Observable<NetworkResponse> {
        Observable<NetworkResponse>.create { (obsever) -> Disposable in
            APIProvider.request(target) { (result) in
                switch result {
                case .success(let jsonValue):
                    if let jsonStr = try? jsonValue.mapJSON(),
                        var response = NetworkResponse.deserialize(from: JSON(jsonStr).dictionaryObject) {
                        #if DEBUG
                        print(String(format: "%@==>%@", target.path, JSON(jsonStr).description))
                        #endif
                        target.responsePath?.components(separatedBy: ".").forEach { (str) in
                            if let result = response.result as? [String: Any] {
                                response.result = result[str]
                            }
                        }
                        obsever.onNext(response)
                        obsever.onCompleted()
                    } else {

                        #if DEBUG
                        print(target.path + "==>数据错误")
                        #endif

                        obsever.onNext(NetworkResponse(code: 300, message: "数据错误", data: nil))
                        obsever.onCompleted()
                    }

                case .failure(let error):

                    #if DEBUG
                    print(error.errorDescription ?? "请求失败")
                    #endif

                    obsever.onNext(NetworkResponse(code: 300, message: error.errorDescription, data: nil))
                    obsever.onCompleted()
                }
            }
            return Disposables.create()
        }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
}
