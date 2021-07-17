//
//  RxNetwork.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/11.
//

import UIKit
import RxSwift
import Alamofire
import HandyJSON
import SwiftyJSON

extension Observable where Element == NetworkResponse {

    public typealias Complete = ((Element) -> Void)?

    /// 转数据模型
    func mapToModel<T: HandyJSON>(_ modelType: T.Type) -> Observable<T> {
        map { response in
            if response.code == HttpCode.success.rawValue {
                /// 成功
                if response.result is [String: Any] {
                    /// 如果是字典
                    guard let model = T.deserialize(from: response.result as? [String: Any])
                        else {
                            throw SLError.noDataOrDataParsingFailed(message: "转模型失败")
                    }
                    return model
                } else {
                    throw SLError.noDataOrDataParsingFailed(message: "不是字典类型")
                }

            } else {
                /// 直接输出错误
                throw SLError.failed(code: response.code, message: response.message)
            }
        }
            .showError()
    }

    /// 转数据模型数组
    func mapToModels<T: HandyJSON>(_ modelType: T.Type) -> Observable<[T]> {
        map { response in
            if response.code == HttpCode.success.rawValue {
                /// 成功
                if response.result is [[String: Any]] {
                    /// 如果是数组
                    guard let models = [T].deserialize(from: response.result as? [[String: Any]]) as? [T]
                        else {
                            throw SLError.noDataOrDataParsingFailed(message: "转模型失败")
                    }
                    return models
                } else {
                    return []
//                    throw NWError.noDataOrDataParsingFailed(message: "不是数组类型")
                }
            } else {
                /// 直接输出错误
                throw SLError.failed(code: response.code, message: response.message)
            }
        }
            .showError()
    }

    /// 查看是成功, 过滤失败
    public func isSuccess(_ complete: Complete) -> Observable<Element> {
        map { response in
            if response.code == HttpCode.success.rawValue {
                DispatchQueue.main.async {
                    complete?(response)
                }
                return response
            } else {
                /// 直接输出错误
                throw SLError.failed(code: response.code, message: response.message)
            }
        }
            .showError()
    }

    /// 查看是失败, 过滤失败
    public func isFailure(_ complete: Complete) -> Observable<Element> {
        map { response in
            if response.code != HttpCode.success.rawValue {
                DispatchQueue.main.async {
                    complete?(response)
                }
                throw SLError.failed(code: response.code, message: response.message)
            } else {
                return response
            }
        }
            .showError()
    }
}

public extension Observable {
    /// 打印error
    func showError() -> Observable<Element> {
        self.do(onError: { (error) in
            print("\(error.localizedDescription)")
        })
    }
}

extension Observable where Element: HandyJSON {
    public func subscribeTo(_ complete: PublishSubject<(Element?, SLError?)>) -> Disposable {
        subscribe(onNext: { (element) in
            complete.onNext((element, nil))
        }, onError: { (error) in
            complete.onNext((nil, error as? SLError))
        })
    }
}
