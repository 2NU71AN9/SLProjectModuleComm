//
//  SLDiscoverViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/21.
//

import UIKit
import Hero
import SPPermissions
import SLIKit
import CTMediator

class SLDiscoverViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.sl
                .showsVerticalScrollIndicator(false)
                .showsHorizontalScrollIndicator(false)
                .delegate(self)
                .dataSource(self)
                .rowHeight(UITableView.automaticDimension)
                .estimatedRowHeight(80)
                .estimatedSectionHeaderHeight(0)
                .estimatedSectionFooterHeight(0)
                .registerClass(UITableViewCell.self)
        }
    }
    
    private let dataArray = [
        ["友盟分享", "极光分享", "微信支付/支付宝支付", "App内购", "融云IM#######"],
        ["网络请求(Moya+RxSwift+HandyJSON)", "socket长连接", "多线程GCD"],
        ["组件化调用", "AOP", "字符串插值", "自定义/重载操作符", "JS交互#######", "WebView"],
        ["权限申请", "定位", "加解密(CryptoSwift)"],
        ["视频播放器#######", "音频播放器#######"]
    ]
}

// MARK: - LifeCyle
extension SLDiscoverViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "发现"
        
         // 转场TableviewCell动画
//        navigationController?.hero.isEnabled = true
//        tableView.hero.modifiers = [.cascade]
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SLDiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { dataArray.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { dataArray[section].count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = dataArray[indexPath.section][indexPath.row]
        cell.hero.modifiers = [.fade, .scale(0.5)]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellDidSelectAction(indexPath)
    }
}

// MARK: - Privater Methods
extension SLDiscoverViewController {
    override func bind() {
        super.bind()
    }
}

// MARK: - Event
extension SLDiscoverViewController {
    private func cellDidSelectAction(_ indexPath: IndexPath) {
        switch indexPath {
        case [0, 0]:
            let vc = ShareViewController(0)
            navigationController?.pushViewController(vc, animated: true)
        case [0, 1]:
            let vc = ShareViewController(1)
            navigationController?.pushViewController(vc, animated: true)
        case [0, 2]:
            let vc = AppPayViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [0, 3]:
            let vc = AppPurchaseViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 0]:
            let vc = NetworkViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 1]:
            let vc = SocketViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 2]:
            let vc = GCDViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 0]:
            if let vc = CTMediator.sharedInstance().moduleVC(title: "组件化调用") {
                navigationController?.pushViewController(vc, animated: true)
            }
        case [2, 1]:
            let vc = AOPViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 2]:
            let vc = StringInterpolationViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 3]:
            let vc = CustomOperatorViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 5]:
            let vc = SLWebViewController(URL(string: "https://www.baidu.com"))
            let navi = UINavigationController(rootViewController: vc)
            present(navi, animated: true, completion: nil)
        case [3, 0]:
            let ctr = SPPermissions.list([.reminders, .camera, .photoLibrary, .locationWhenInUse, .locationAlways, .calendar, .bluetooth, .contacts, .microphone])
            ctr.present(on: self)
        case [3, 1]:
            let vc = LocationViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [3, 2]:
            let vc = CryptoViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
