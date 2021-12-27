//
//  GCDViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/13.
//

import UIKit

class GCDViewController: BaseViewController {
    /// 主线程队列
    let mainQueue = DispatchQueue.main
    /// 全局并发队列
    let globalQueue = DispatchQueue.global()
    /// 串行队列
    let serial = DispatchQueue(label: "serial")
    /// 并行队列
    let concurrent = DispatchQueue(label: "concurrent", attributes: .concurrent)
    
    /// 异步执行回主线程
    @IBAction func btn1Action(_ sender: UIButton) {
        globalQueue.async {
            print("异步执行 --- \(Thread.current)")
            DispatchQueue.main.async {
                print("回主线程 --- \(Thread.current)")
            }
        }
    }
    /// 延时执行
    @IBAction func btn2Action(_ sender: UIButton) {
        globalQueue.asyncAfter(deadline: .now() + 2) {
            print("延时2秒")
        }
    }
    /// 异步串行
    @IBAction func btn3Action(_ sender: UIButton) {
        serial.async {
            Thread.sleep(forTimeInterval: 3)
            print("1 --- ", Thread.current)
        }
        serial.async {
            Thread.sleep(forTimeInterval: 1)
            print("2 --- ", Thread.current)
        }
        serial.async {
            Thread.sleep(forTimeInterval: 2)
            print("3 --- ", Thread.current)
        }
    }
    /// 异步并行
    @IBAction func btn4Action(_ sender: UIButton) {
        concurrent.async {
            Thread.sleep(forTimeInterval: 3)
            print("1 --- ", Thread.current)
        }
        concurrent.async {
            Thread.sleep(forTimeInterval: 1)
            print("2 --- ", Thread.current)
        }
        concurrent.async {
            Thread.sleep(forTimeInterval: 2)
            print("3 --- ", Thread.current)
        }
    }
    /// 异步多任务
    @IBAction func btn5Action(_ sender: UIButton) {
        let group = DispatchGroup()
        for i in 0 ..< 4 {
            group.enter()
            globalQueue.async {
                /// 耗时操作
                Thread.sleep(forTimeInterval: 2)
                print("任务\(i)完成", Thread.current)
                group.leave()
            }
        }
        /// 所有任务完成后回主线程
        group.notify(queue: .main) {
            print("任务全部完毕", Thread.current)
        }
    }
    /// 栅栏函数：前面的任务执行结束后它才执行，而且它后面的任务等它执行完成之后才会执行
    @IBAction func btn6Action(_ sender: UIButton) {
        let group = DispatchGroup()
        concurrent.async(group: group) {
            print("1 ---- ", Thread.current)
        }
        concurrent.async(group: group) {
            print("2 ---- ", Thread.current)
        }
        concurrent.async(group: group, flags: .barrier) {
            Thread.sleep(forTimeInterval: 2)
            print("4 ----", Thread.current)
        }
        concurrent.async(group: group) {
            print("3 ---- ", Thread.current)
        }
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        
    }
    override func method(for aSelector: Selector!) -> IMP! {
        
    }
    
}

// MARK: - LifeCyle
extension GCDViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.discover_GCD.text
    }
}
