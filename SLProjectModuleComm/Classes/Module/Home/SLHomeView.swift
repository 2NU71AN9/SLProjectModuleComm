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
            tableView.sl.registerClass(UITableViewCell.self)
        }
    }
}
