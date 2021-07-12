//
//  SocketViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/12.
//

import UIKit

class SocketViewController: BaseViewController {
    private var socket = SocketHandler(.home)
}

// MARK: - LifeCyle
extension SocketViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "Socket长连接"
        
        socket.connect()
            .receiveText { str in
                print(str)
            }
            .receiveData { data in
                print(data)
            }
    }
}

// MARK: - Privater Methods
extension SocketViewController {
    override func bind() {
        super.bind()
    }
}
