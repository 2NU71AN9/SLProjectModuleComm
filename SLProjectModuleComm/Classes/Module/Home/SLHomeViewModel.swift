//
//  SLHomeViewModel.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/15.
//

import UIKit
import RxSwift

class SLHomeViewModel: BaseViewModel {
    
    let cellDidSelectSubject = PublishSubject<IndexPath>()
    
    private let dataArray = [
        ["FaceID / TouchID", "人脸检测", "Taptic", "音效", "二维码扫描", "生成二维码"],
        ["瀑布流", "上拉加载/下拉刷新", "空白状态页", "Toast", "多页面", "列表嵌套", "轮播", "图片浏览",
         "弹窗(SwiftMessages)", "弹出菜单(NewPopMenu)", "跑马灯(MarqueeLabel)", "滚动消息(RollingNotice-Swift)", "引导页(EAIntroView)", "功能引导(Instructions)"],
        ["图片选择", "文件选择+文件预览", "时间选择", "标签选择1", "标签选择2", "地址选择(三联)######", "地址选择(高德)#######", "城市选择"],
        ["自定义导航栏########", "搜索组件########", "抽屉#########", "GridView#########"],
        ["动画########", "星星评分########"]
    ]
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SLHomeViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { dataArray.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { dataArray[section].count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = dataArray[indexPath.section][indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellDidSelectSubject.onNext(indexPath)
    }
}
