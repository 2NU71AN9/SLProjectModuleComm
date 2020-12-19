//
//  SLHomeView.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/15.
//

import UIKit

class SLHomeView: BaseView {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerClass(UITableViewCell.self)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SLHomeView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 30 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
}
