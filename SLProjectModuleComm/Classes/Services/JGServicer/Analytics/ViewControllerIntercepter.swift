//
//  ViewControllerIntercepter.swift
//  FZXLive
//
//  Created by 孙梁 on 2020/7/28.
//  Copyright © 2020 znclass. All rights reserved.
//

import UIKit
import Aspects

public class ViewControllerIntercepter: NSObject {
    static let shared = ViewControllerIntercepter()
    private override init() { super.init() }

    func intercepter() {
        viewDidAppearIntercepter()
        viewDidDisappearIntercepter()
    }

    /// 拦截viewDidAppear
    private func viewDidAppearIntercepter() {
        let block: @convention(block) (Any?) -> Void = { [weak self] info in
            if let aspectInfo = info as? AspectInfo,
               let controller = aspectInfo.instance() as? UIViewController {
                self?.viewWillAppear(controller)
            }
        }
        do {
            try UIViewController.aspect_hook(NSSelectorFromString("viewWillAppear:"), with: [], usingBlock: unsafeBitCast(block, to: AnyObject.self))
        } catch {
            print(error)
        }
    }

    /// 拦截viewDidDisappear
    private func viewDidDisappearIntercepter() {
        let block: @convention(block) (Any?) -> Void = { [weak self] info in
            if let aspectInfo = info as? AspectInfo,
               let controller = aspectInfo.instance() as? UIViewController {
                self?.viewWillDisappear(controller)
            }
        }
        do {
            try UIViewController.aspect_hook(NSSelectorFromString("viewWillDisappear:"), with: [], usingBlock: unsafeBitCast(block, to: AnyObject.self))
        } catch {
            print(error)
        }
    }
}

extension ViewControllerIntercepter: ViewControllerProtocol {
    private func viewWillAppear(_ controller: UIViewController) {
        if controller is UINavigationController || controller is UITabBarController || controller is UIInputViewController { return }
        print("拦截viewDidAppear")
        viewWillAppear(controller: controller)
    }

    private func viewWillDisappear(_ controller: UIViewController) {
        if controller is UINavigationController || controller is UITabBarController || controller is UIInputViewController { return }
        print("拦截viewDidDisappear")
        viewWillDisappear(controller: controller)
    }
}

public protocol ViewControllerProtocol {
    func viewWillAppear(controller: UIViewController)
    func viewWillDisappear(controller: UIViewController)
}

// MARK: - 默认实现
public extension ViewControllerProtocol {
    func viewWillAppear(controller: UIViewController) {
        SLJGServicer.shared.startPage(controller)
    }
    func viewWillDisappear(controller: UIViewController) {
        SLJGServicer.shared.stopPage(controller)
    }
}
