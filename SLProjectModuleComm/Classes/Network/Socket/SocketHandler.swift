//
//  SocketHandler.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/31.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import Starscream

public class SocketHandler: NSObject {

    public var textSubject: ((String) -> Void)?
    public var dataSubject: ((Data) -> Void)?

    private var api: SocketAPIService
    private var connectTimes = 0 // 重连次数
    private lazy var socket: WebSocket = {
        var str = String(format: "%@%@", api.baseURL, api.path)
        api.parameters.forEach { (key, value) in
            str += "&\(key)=\(value)"
        }
        let requset = URLRequest(url: URL(string: str) ?? URL(fileURLWithPath: ""))
        let socket = WebSocket(request: requset)
        socket.delegate = self
        return socket
    }()

    init(_ api: SocketAPIService) {
        self.api = api
        super.init()
    }

    deinit {
        socket.disconnect()
    }
}

extension SocketHandler: WebSocketDelegate {
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
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
        case .text(let text):
            print("收到消息==>\(text)")
            textSubject?(text)
        case .binary(let data):
            print("收到消息==>\(data)")
            dataSubject?(data)
        default:
            socket.forceDisconnect()
        }
    }
}

public extension SocketHandler {
    @discardableResult
    func connect() -> SocketHandler {
        socket.connect()
        return self
    }
    @discardableResult
    func disconnect() -> SocketHandler {
        socket.disconnect()
        return self
    }
    
    @discardableResult
    func receiveText(_ complete: @escaping (String) -> Void) -> SocketHandler {
        textSubject = complete
        return self
    }
    @discardableResult
    func receiveData(_ complete: @escaping (Data) -> Void) -> SocketHandler {
        dataSubject = complete
        return self
    }
}
