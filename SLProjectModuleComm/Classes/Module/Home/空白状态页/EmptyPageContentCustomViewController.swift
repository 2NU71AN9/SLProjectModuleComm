//
//  EmptyPageContentCustomViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit
import SLIKit
import JXSegmentedView

class EmptyPageContentCustomViewController: BaseViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped).sl
            .delegate(self)
            .dataSource(self)
            .rowHeight(UITableView.automaticDimension)
            .estimatedRowHeight(80)
            .estimatedSectionHeaderHeight(0)
            .estimatedSectionFooterHeight(0)
            .registerClass(UITableViewCell.self)
            .base
        tableView.emptyViewEnable = true // 默认true
        tableView.isLoadingEnable = false
        tableView.emptyView?.image = R.image.cry100()
        tableView.emptyView?.text = "没有找到数据"
        tableView.emptyView?.actionTitle = "重新加载"
        tableView.emptyView?.refreshAction = { [weak self] in
            SLHUD.message(desc: "重新加载")
        }
        return tableView
    }()
}

// MARK: - LifeCyle
extension EmptyPageContentCustomViewController {
    override func setMasterView() {
        super.setMasterView()
        naviBarHidden = true
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.sl.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension EmptyPageContentCustomViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

// MARK: - JXPagingViewListViewDelegate
extension EmptyPageContentCustomViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView { view }
}
