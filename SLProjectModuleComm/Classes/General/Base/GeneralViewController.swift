//
//  GeneralViewController.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/8/27.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit
import SLIKit

/**
 base类, 可根据vc名称自动初始化并持有view和viewModel
 需要按命名规则事先创建好vc view viewModel
 命名规则: xxxViewController xxxView  xxxViewModel
 可不创建xxxView或xxxViewModel, 即和普通vc一样, 并且不影响xib使用
 */
class GeneralViewController: UIViewController {

    public var contentView: BaseView? {
        view as? BaseView
    }
    public var viewModel: BaseViewModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let nibNameOrNil = String(describing: type(of: self))
        if Bundle.main.path(forResource: nibNameOrNil, ofType: "nib") != nil {
            super.init(nibName: nibNameOrNil, bundle: nil)
        } else {
            super.init(nibName: nil, bundle: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required convenience init() {
        let nibNameOrNil = String(describing: type(of: self))
        if Bundle.main.path(forResource: nibNameOrNil, ofType: "nib") != nil {
            self.init(nibName: nibNameOrNil, bundle: nil)
        } else {
            self.init(nibName: nil, bundle: nil)
        }
    }

    /// 重写loadView方法, 替换view, 初始化viewModel
    override func loadView() {
        super.loadView()
        let name = String(describing: type(of: self))
        let clsName = String(name.prefix(upTo: name.index(name.endIndex, offsetBy: -10)))

        if Bundle.main.path(forResource: clsName, ofType: "nib") != nil,
            let nibCls = Bundle.main.loadNibNamed("\(clsName)", owner: nil, options: nil)?.first as? BaseView {
            view = nibCls
        } else if let cls = NSClassFromString(Bundle.main.sl.namespace~~ + "." + clsName) as? BaseView.Type {
            view = cls.init()
        }
        if let cls = NSClassFromString(Bundle.main.sl.namespace~~ + "." + clsName + "Model") as? BaseViewModel.Type {
            viewModel = cls.init()
        }
    }
}
