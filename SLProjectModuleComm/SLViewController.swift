//
//  SLViewController.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/12.
//

import UIKit

class SLViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.sl.registerClass(UITableViewCell.self)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
}

extension SLViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "首页"
        naviBar.item1Title = "点击"
        naviBar.item1Event = {
            print("导航栏点击")
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SLViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 10 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
}
