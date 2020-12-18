//
//  BaseViewModel.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewModel: NSObject, DataSourceCleanProtocol {

    public let bag = DisposeBag()
    public let refreshSubject = PublishSubject<Bool>()
    public let loadMoreSubject = PublishSubject<Bool>()

    public var page = 1

    required override init() {
        super.init()
        bind()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BaseViewModel {
    
    @objc func bind() {
        refreshSubject.asObservable().subscribeTo { [weak self] in
            self?.refreshData()
        }.disposed(by: bag)
        loadMoreSubject.asObservable().subscribeTo { [weak self] in
            self?.loadMoreData()
        }.disposed(by: bag)
    }
    
    @objc func viewDidLoad() {
        refreshData()
    }

    /// 刷新
    @objc func refreshData() {
        page = 1
        dataSourceClean()
        loadData()
    }
    /// 加载
    @objc func loadMoreData() {
        page += 1
        loadData()
    }
    /// 网络请求
    @objc func loadData() {

    }
}

protocol DataSourceCleanProtocol {
    func dataSourceClean()
}

extension DataSourceCleanProtocol {
    func dataSourceClean() {}
}
