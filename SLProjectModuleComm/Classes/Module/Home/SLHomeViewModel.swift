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
    
    private let dataArray = [["友盟分享", "极光分享"],
                             ["人脸检测", "Taptic", "音效", "二维码扫描", "生成二维码"],
                             ["瀑布流", "上拉加载/下拉刷新", "空白状态页", "Toast", "多页面", "列表嵌套", "轮播"],
                             ["图片选择", "文件选择+文件预览"],
                             ["前往系统设置", "前往自己应用设置", "前往AppStore"]
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
