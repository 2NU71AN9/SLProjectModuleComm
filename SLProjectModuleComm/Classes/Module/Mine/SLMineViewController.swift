//
//  SLMineViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/21.
//

import UIKit

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
        .registerClass(UITableViewCell.self)
        .base
}

// MARK: - LifeCyle
extension SLMineViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "我的"
        naviBar.item1Title = "退出"
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
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SLMineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
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
    
}
