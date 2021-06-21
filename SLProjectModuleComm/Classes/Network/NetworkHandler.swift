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
    
    /// 网络请求
    /// - Parameter target: API
    /// - Returns: 接口返回数据
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
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
        .observe(on: MainScheduler.instance)
    }
    
    /// 下载文件
    /// - Parameters:
    ///   - target: API
    ///   - progress: 进度
    public static func download(_ target: APIService, progress: ((Double) -> Void)? = nil) -> Observable<URL> {
        Observable<URL>.create { (obsever) -> Disposable in
            if FileManager.default.fileExists(atPath: target.localLocation.path) {
                obsever.onNext(target.localLocation)
                obsever.onCompleted()
            } else {
                APIProvider.request(target, progress: { pro in
                    progress?(pro.progress)
                }) { (result) in
                    switch result {
                    case .success:
                        obsever.onNext(target.localLocation)
                        print("下载成功==>" + target.localLocation.absoluteString)
                        obsever.onCompleted()
                    case .failure(let error):
                        #if DEBUG
                        print(error.errorDescription ?? "下载失败")
                        #endif
                        obsever.onError(error)
                        obsever.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
        .observe(on: MainScheduler.instance)
    }
}
