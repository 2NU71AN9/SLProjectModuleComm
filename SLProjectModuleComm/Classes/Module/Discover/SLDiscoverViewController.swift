//
//  SLDiscoverViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/21.
//

import UIKit

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
}

// MARK: - LifeCyle
extension SLDiscoverViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "发现"
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SLDiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 10 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
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
    
}
