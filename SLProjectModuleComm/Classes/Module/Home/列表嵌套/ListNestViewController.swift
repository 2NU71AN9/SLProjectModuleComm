//
//  ListNestViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/28.
//

import UIKit
import JXPagingView
import JXSegmentedView
import SLIKit

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

class ListNestViewController: BaseViewController {
    
    private lazy var headView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: SL.SCREEN_WIDTH, height: CGFloat(tableHeaderViewHeight)))
        view.backgroundColor = R.color.prime()
        view.image = R.image.cry100()
        return view
    }()
    
    private lazy var pagingView: JXPagingView = {
        let view = JXPagingListRefreshView(delegate: self)
        return view
    }()
    private lazy var dataSource: JXSegmentedTitleDataSource = {
        let ds = JXSegmentedTitleDataSource()
        ds.titles = titles
        ds.titleSelectedColor = R.color.prime()~~
        ds.titleNormalColor = R.color.text_gray1()~~
        ds.isTitleColorGradientEnabled = true
        ds.isTitleZoomEnabled = true
        return ds
    }()
    /// 初始化指示器
    private lazy var indicator: JXSegmentedIndicatorLineView = {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = R.color.prime()~~
        return indicator
    }()
    private lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: SL.SCREEN_WIDTH, height: CGFloat(headerInSectionHeight)))
        view.delegate = self
        view.dataSource = dataSource
        view.indicators = [indicator]
        view.listContainer = pagingView.listContainerView
        return view
    }()
    
    private var titles = ["item1", "item2", "item3"]
    private var tableHeaderViewHeight: Int = 200
    private var headerInSectionHeight: Int = 40
}

// MARK: - LifeCyle
extension ListNestViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "列表嵌套"
        view.addSubview(pagingView)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pagingView.snp.sl.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(naviBar.snp.bottom)
        }
    }
}

extension ListNestViewController: JXPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        tableHeaderViewHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        headView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        headerInSectionHeight
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        segmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        ListNestContentViewController()
    }
}

extension ListNestViewController: JXSegmentedViewDelegate {
    
}
