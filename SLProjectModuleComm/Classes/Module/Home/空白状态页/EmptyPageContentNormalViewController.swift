//
//  EmptyPageContentNormalViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit
import JXSegmentedView

class EmptyPageContentNormalViewController: BaseViewController {

    private lazy var tableView = UITableView(frame: CGRect.zero, style: .insetGrouped).sl
        .delegate(self)
        .dataSource(self)
        .rowHeight(UITableView.automaticDimension)
        .estimatedRowHeight(80)
        .estimatedSectionHeaderHeight(0)
        .estimatedSectionFooterHeight(0)
        .registerClass(UITableViewCell.self)
        .base

}

// MARK: - LifeCyle
extension EmptyPageContentNormalViewController {
    override func setMasterView() {
        super.setMasterView()
        naviBarHidden = true
        view.addSubview(tableView)
        tableView.isLoadingEnable = false
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
extension EmptyPageContentNormalViewController: UITableViewDelegate, UITableViewDataSource {
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
extension EmptyPageContentNormalViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView { view }
}
