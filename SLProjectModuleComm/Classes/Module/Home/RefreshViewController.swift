//
//  RefreshViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit

class RefreshViewController: BaseViewController {

    private lazy var tableView = UITableView(frame: CGRect.zero, style: .insetGrouped).sl
        .delegate(self)
        .dataSource(self)
        .rowHeight(UITableView.automaticDimension)
        .estimatedRowHeight(80)
        .estimatedSectionHeaderHeight(0)
        .estimatedSectionFooterHeight(0)
        .registerClass(UITableViewCell.self)
        .refreshHeader { [weak self] in
            self?.refresh()
        }
        .refreshFooter { [weak self] in
            self?.loadMore()
        }
        .base
    
    private var page = 1
}

// MARK: - LifeCyle
extension RefreshViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "上拉加载/下拉刷新"
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
extension RefreshViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        page
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

// MARK: - Privater Methods
extension RefreshViewController {
    override func bind() {
        super.bind()
    }
    
    private func refresh() {
        page = 1
        loadData()
    }
    private func loadMore() {
        page += 1
        loadData()
    }
    private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.tableView.sl.endRefreshing(PAGE_SIZE, standard: PAGE_SIZE)
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Event
extension RefreshViewController {
    
}
