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
        [SLLocalText.home_faceId_TouchID, SLLocalText.home_faceDetector, SLLocalText.home_taptic, SLLocalText.home_sound, SLLocalText.home_QRCodeScan, SLLocalText.home_QRCodeMaker],
        [SLLocalText.home_waterfall, SLLocalText.home_refreshAndLoad, SLLocalText.home_emptyPage, SLLocalText.home_toast, SLLocalText.home_naviPage, SLLocalText.home_listNest, SLLocalText.home_carouse, SLLocalText.home_imageBrowser,
         SLLocalText.home_alert, SLLocalText.home_popMenu, SLLocalText.home_marquee, SLLocalText.home_rollingNotice, SLLocalText.home_guide, SLLocalText.home_instruction, SLLocalText.home_screenShot, SLLocalText.home_swipeCell],
        [SLLocalText.home_imagePicker, SLLocalText.home_filePicker, SLLocalText.home_datePicker, SLLocalText.home_tagPicker1, SLLocalText.home_tagPicker2, SLLocalText.home_addressPicker, SLLocalText.home_addressPicker_gaode, SLLocalText.home_cityPicker],
        [SLLocalText.home_customNavigation, SLLocalText.home_drawer, SLLocalText.home_gridView],
        [SLLocalText.home_transitionAnimation, SLLocalText.home_tableViewCellAnimation, SLLocalText.home_star, SLLocalText.home_emitter]
    ]
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SLHomeViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { dataArray.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { dataArray[section].count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = dataArray[indexPath.section][indexPath.row].text
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellDidSelectSubject.onNext(indexPath)
    }
}
