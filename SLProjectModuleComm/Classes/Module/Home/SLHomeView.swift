//
//  SLHomeView.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/15.
//

import UIKit
import ViewAnimator

class SLHomeView: BaseView {
    
    private let animations = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.sl.registerClass(UITableViewCell.self)
        }
    }
}

extension SLHomeView {
    func startAnim() {
        tableView.reloadData()
        UIView.animate(views: tableView.visibleCells, animations: animations, completion: nil)
    }
}
