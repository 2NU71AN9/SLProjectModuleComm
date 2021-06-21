//
//  BaseViewModel.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import RxSwift

/**
 ViewModel base类
 根据命名规则(xxxViewController xxxViewModel)可自动初始化并被控制器持有
 */
class BaseViewModel: NSObject {

    public let bag = DisposeBag()
    /// 刷新数据
    public let refreshSubject = PublishSubject<Bool>()
    /// 加载更多数据
    public let loadMoreSubject = PublishSubject<Bool>()
    /// 网络请求结束, error代表是否成功, Int是分页接口返回的数据个数, 非分页接口填0
    public let loadDataComplete = PublishSubject<(SLError?, Int)>()
    /// 分页接口请求页数
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
    /// 状态绑定
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
    /// 清理数据源
    @objc func dataSourceClean() {
        
    }
}
