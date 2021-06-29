//
//  ImagePicker2ViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/29.
//

import UIKit
import HXPhotoPicker
import JXSegmentedView
import SLIKit

class ImagePicker2ViewController: BaseViewController {

    private lazy var tableView = UITableView(frame: CGRect.zero, style: .insetGrouped).sl
        .showsVerticalScrollIndicator(false)
        .showsHorizontalScrollIndicator(false)
        .delegate(self)
        .dataSource(self)
        .rowHeight(UITableView.automaticDimension)
        .estimatedRowHeight(80)
        .estimatedSectionHeaderHeight(0)
        .estimatedSectionFooterHeight(0)
        .registerClass(UITableViewCell.self)
        .registerNib(HXPPImageCell.self)
        .base
    
    private lazy var photoModel1: HXPhotoPickerTableCellModel = {
        let photoModel = HXPhotoPickerTableCellModel()
        return photoModel
    }()
    private lazy var photoModel2: HXPhotoPickerTableCellModel = {
        let photoModel = HXPhotoPickerTableCellModel()
        return photoModel
    }()
}

// MARK: - LifeCyle
extension ImagePicker2ViewController {
    override func setMasterView() {
        super.setMasterView()
        naviBarHidden = true
        view.addSubview(tableView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.sl.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ImagePicker2ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 2 ? 3 : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HXPPImageCell", for: indexPath) as? HXPPImageCell
            cell?.titleLabel.text = "照片1"
            cell?.photoMaxNum = 6
            cell?.photoViewModel = photoModel1
            cell?.hxPhotoViewChangeHeightClosure = {
                tableView.reloadSections([indexPath.section], with: .fade)
            }
            return cell~~
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HXPPImageCell", for: indexPath) as? HXPPImageCell
            cell?.titleLabel.text = "照片2"
            cell?.photoMaxNum = 9
            cell?.photoViewModel = photoModel2
            cell?.hxPhotoViewChangeHeightClosure = {
                tableView.reloadSections([indexPath.section], with: .fade)
            }
            return cell~~
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.text = "\(indexPath.row + 1)"
            return cell
        }
    }
}

// MARK: - JXPagingViewListViewDelegate
extension ImagePicker2ViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView { view }
}
