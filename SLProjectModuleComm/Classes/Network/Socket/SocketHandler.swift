//
//  SocketHandler.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/31.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import Starscream
import RxSwift
import RxCocoa

class SocketHandler: NSObject {

    let textSubject = PublishSubject<String>()
    let dataSubject = PublishSubject<Data>()

    private var api: SocketAPIService
    private var connectTimes = 0 // 重连次数
    private lazy var socket: WebSocket = {
        var str = String(format: "%@%@", api.baseURL, api.path)
        api.parameters.forEach { (key, value) in
            str += "&\(key)=\(value)"
        }
        let requset = URLRequest(url: URL(string: str)!)
        let socket = WebSocket(request: requset)
        socket.delegate = self
        return socket
    }()

    init(_ api: SocketAPIService) {
        self.api = api
        super.init()
    }

    func connectText() -> Observable<String> {
        socket.connect()
        return textSubject
    }

    func connectData() -> Observable<Data> {
        socket.connect()
        return dataSubject
    }
}

extension SocketHandler: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let value):
            connectTimes = 0
            print("连接成功==>\(value)")
        case .disconnected(let str, let value):
            print("连接失败==>\(str)  \(value)")
            if connectTimes <= 5 {
                client.connect()
                connectTimes += 1
            }
//            textSubject.onError(JYError.requestFailed(message: "连接失败"))
//            dataSubject.onError(JYError.requestFailed(message: "连接失败"))
        case .text(let text):
            print(text)
            textSubject.onNext(text)
        case .binary(let data):
            print(data)
            dataSubject.onNext(data)
        default:
            socket.forceDisconnect()
        }
    }
}
