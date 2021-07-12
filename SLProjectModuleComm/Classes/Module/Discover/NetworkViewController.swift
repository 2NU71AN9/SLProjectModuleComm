//
//  NetworkViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/12.
//

import UIKit

class NetworkViewController: BaseViewController {

}

// MARK: - LifeCyle
extension NetworkViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "网络请求"
    }
    
    override func setVisitorPage() {
        setMasterView()
    }
}

// MARK: - Privater Methods
extension NetworkViewController {
    override func bind() {
        super.bind()
    }
    
    /// 返回数据为字典
    private func request1() {
        NetworkHandler.request(.login(account: "", password: ""))
            .mapToModel(SLUserModel.self) // 字典转数据模型
            .subscribe { model in
                
            } onError: { error in
                
            }.disposed(by: bag)
    }
    /// 返回数据为字典数组
    private func request2() {
        NetworkHandler.request(.login(account: "", password: ""))
            .mapToModels(SLUserModel.self) // 数组转数据模型
            .subscribe { models in
                
            } onError: { error in
                
            }.disposed(by: bag)
    }
    /// 成功/失败
    private func request3() {
        NetworkHandler.request(.login(account: "", password: ""))
            .isSuccess { nr in
                
            }.isFailure { nr in
                
            }.subscribe()
            .disposed(by: bag)
    }
    /// 下载
    private func request4() {
        NetworkHandler.download(.downloadFile("")) { _ in
            
        }.subscribe { url in
            
        } onError: { error in
            
        }.disposed(by: bag)
    }
}
