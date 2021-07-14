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
        [SLLocalText.discover_UMShare, SLLocalText.discover_JGShare, SLLocalText.discover_wechatPayAndAliPay, SLLocalText.discover_inPurchase, SLLocalText.discover_RYIM],
        [SLLocalText.discover_netWork, SLLocalText.discover_socket, SLLocalText.discover_GCD],
        [SLLocalText.discover_component, SLLocalText.discover_AOP, SLLocalText.discover_stringInterpolation, SLLocalText.discover_customOperator, SLLocalText.discover_JS, SLLocalText.discover_webView],
        [SLLocalText.discover_authority, SLLocalText.discover_location, SLLocalText.discover_crypto],
        [SLLocalText.discover_videoPlayer, SLLocalText.discover_audeoPlayer]
    ]
}

// MARK: - LifeCyle
extension SLDiscoverViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.tab_discover.text
        
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
        cell.textLabel?.text = dataArray[indexPath.section][indexPath.row].text
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
        case [2, 4]:
            let vc = SLJSViewController("https://www.baidu.com")
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
