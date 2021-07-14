//
//  SLMineViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/21.
//

import UIKit
import SLIKit
import DeviceKit

class SLMineViewController: BaseViewController {
    private lazy var tableView = UITableView(frame: CGRect.zero, style: .insetGrouped).sl
        .showsVerticalScrollIndicator(false)
        .showsHorizontalScrollIndicator(false)
        .delegate(self)
        .dataSource(self)
        .rowHeight(UITableView.automaticDimension)
        .estimatedRowHeight(80)
        .estimatedSectionHeaderHeight(0)
        .estimatedSectionFooterHeight(0)
        .base
    
    private let dataArray = [
        [SLLocalText.my_iPhoneName, SLLocalText.my_iPhoneDesc, SLLocalText.my_sysName, SLLocalText.my_systemVersion, SLLocalText.my_batteryLevel, SLLocalText.my_networkStatus, SLLocalText.my_IP, SLLocalText.my_wifiIP, SLLocalText.my_wifiName, SLLocalText.my_wifiMacAddress],
        [SLLocalText.my_cleanCache, SLLocalText.my_localizable, SLLocalText.my_darkMode],
        [SLLocalText.my_goSysSet, SLLocalText.my_goAppSet, SLLocalText.my_goAppStore]
    ]
    
    private lazy var segView: UISegmentedControl = {
        var items = ["跟随系统", "普通", "黑色"]
        let view = UISegmentedControl(items: items)
        view.selectedSegmentIndex = SLDisplayModeManager.shared.currentMode.rawValue
        view.addTarget(self, action: #selector(changeMode), for: .valueChanged)
        return view
    }()
}

// MARK: - LifeCyle
extension SLMineViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.tab_my.text
        naviBar.item1Title = SLLocalText.logout.text
        naviBar.item1Event = { AccountServicer.service.logout() }
        view.addSubview(tableView)
    }
    
    override func setVisitorPage() {
        super.setVisitorPage()
        naviBar.item1Title = nil
        naviBar.item1Event = nil
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.sl.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    override func networkStatusChanged(_ status: SLNetworkStatus) {
        super.networkStatusChanged(status)
        tableView.reloadSections([0], with: .fade)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SLMineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            if #available(iOS 13.0, *) {
                return dataArray[section].count
            } else {
                return dataArray[section].count - 1
            }
        default:
            return dataArray[section].count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        }
        cell?.textLabel?.text = dataArray[indexPath.section][indexPath.row].text
        cell?.accessoryType = .disclosureIndicator
        switch indexPath {
        case [0, 0]:
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = Device.current.name
        case [0, 1]:
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = Device.current.description
        case [0, 2]:
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = Device.current.systemName
        case [0, 3]:
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = Device.current.systemVersion
        case [0, 4]:
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = "\(Device.current.batteryLevel ?? 0)"
        case [0, 5]:
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = SLNetworkListenManager.shared.networkStatus.desc
        case [0, 6]:
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = SL.tools.getIPAddress()
        case [0, 7]:
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = SL.tools.getWiFiIP()
        case [0, 8]:
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = SL.tools.getWifiNameWithMac().0
        case [0, 9]:
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = SL.tools.getWifiNameWithMac().1
        case [1, 0]:
            cell?.detailTextLabel?.text = SLFileManager.access2Cache()
        case [1, 2]:
            cell?.accessoryView = segView
        default:
            cell?.detailTextLabel?.text = nil
        }
        return cell~~
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellDidSelectAction(indexPath)
    }
}

// MARK: - Privater Methods
extension SLMineViewController {
    override func bind() {
        super.bind()
    }
}

// MARK: - Event
extension SLMineViewController {
    private func cellDidSelectAction(_ indexPath: IndexPath) {
        switch indexPath {
        case [1, 0]:
            SLFileManager.cleanCache { [weak self] in
                self?.tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = SLFileManager.access2Cache()
            }
        case [2, 0]:
            if let url = URL(string: "App-Prefs:root") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case [2, 1]:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case [2, 2]:
            SL.tools.goAppStore(APPID)
        default:
            break
        }
    }
    
    @objc private func changeMode() {
        switch segView.selectedSegmentIndex {
        case 0:
            SLDisplayModeManager.shared.setDisplayMode(.flowSystem(nil))
        case 1:
            SLDisplayModeManager.shared.setDisplayMode(.light)
        case 2:
            SLDisplayModeManager.shared.setDisplayMode(.dark)
        default:
            break
        }
    }
}
