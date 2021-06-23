//
//  SegmentContentViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit
import SLIKit
import JXSegmentedView

class SegmentContentViewController: BaseViewController {

}

// MARK: - LifeCyle
extension SegmentContentViewController {
    override func setMasterView() {
        super.setMasterView()
        naviBarHidden = true
        view.backgroundColor = UIColor.sl.random
    }
}

// MARK: - JXPagingViewListViewDelegate
extension SegmentContentViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView { view }
}
