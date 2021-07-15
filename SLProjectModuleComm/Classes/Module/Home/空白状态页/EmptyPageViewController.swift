//
//  EmptyPageViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit
import SLIKit
import JXSegmentedView

class EmptyPageViewController: BaseViewController {
    /// 初始化dataSource
    private lazy var segmentedViewDataSource: JXSegmentedTitleDataSource = {
        let ds = JXSegmentedTitleDataSource()
        ds.isItemSpacingAverageEnabled = true
        ds.titles = titles
        ds.titleNormalColor = R.color.text_gray1()~~
        ds.titleSelectedColor = R.color.prime()~~
        return ds
    }()
    /// 初始化指示器
    private lazy var indicator: JXSegmentedIndicatorLineView = {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = R.color.prime()~~
        return indicator
    }()
    /// 初始化分类切换SegmentedView
    private lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.dataSource = segmentedViewDataSource
        view.indicators = [indicator]
        view.listContainer = listContainerView
        return view
    }()
    /// 初始化列表容器视图
    private lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        return view
    }()
    
    /// 顶部滚动切换的titles
    private lazy var titles = ["普通", "自定义", "WebView"]
    /// 包含的所有视图数组, 须遵守JXSegmentedListContainerViewListDelegate
    private lazy var vcs: [JXSegmentedListContainerViewListDelegate] = [EmptyPageContentNormalViewController(),
                                                                        EmptyPageContentCustomViewController(),
                                                                        EmptyPageContentWebViewController()]
}

// MARK: - LifeCyle
extension EmptyPageViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.home_emptyPage.text
        view.addSubview(segmentedView)
        view.addSubview(listContainerView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        segmentedView.snp.sl.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(naviBar.snp.bottom)
            make.height.equalTo(40)
        }
        listContainerView.snp.sl.makeConstraints { (make) in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - JXPagingViewDelegate
extension EmptyPageViewController: JXSegmentedListContainerViewDataSource {
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        vcs[index]
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        titles.count
    }
}
