//
//  SLHomeViewController.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/15.
//

import UIKit
import SLIKit

class SLHomeViewController: BaseViewController {
    
}

// MARK: - LifeCyle
extension SLHomeViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "首页"
    }
}

// MARK: - Privater Methods
extension SLHomeViewController {
    override func bind() {
        super.bind()
        guard let contentView = contentView as? SLHomeView,
              let viewModel = viewModel as? SLHomeViewModel else { return }
        contentView.tableView.delegate = viewModel
        contentView.tableView.dataSource = viewModel
        viewModel.cellDidSelectSubject.subscribe(onNext: { [weak self] (value) in
            self?.cellDidSelectAction(value)
        }).disposed(by: bag)
    }
}

// MARK: - Event
extension SLHomeViewController {
    private func cellDidSelectAction(_ indexPath: IndexPath) {
        switch indexPath {
        case [0, 0]:
            let vc = ShareViewController(0)
            navigationController?.pushViewController(vc, animated: true)
        case [0, 1]:
            let vc = ShareViewController(1)
            navigationController?.pushViewController(vc, animated: true)
        case [1, 0]:
            let vc = FaceRecognitionViewController()
            present(vc, animated: true, completion: nil)
        case [1, 1]:
            let vc = TapticViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 2]:
            let vc = SoundViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 3]:
            let vc = SLQRCodeViewController { result in
                SLHUD.showToast(result?.strScanned)
            }
            navigationController?.pushViewController(vc, animated: true)
        case [1, 4]:
            let vc = QRCodeViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 0]:
            let vc = WaterfallFlowViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 1]:
            let vc = RefreshViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 2]:
            let vc = EmptyPageViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 3]:
            let vc = ToastViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 4]:
            let vc = SegmentViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 5]:
            let vc = ListNestViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 6]:
            let vc = CarouselViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [3, 0]:
            let vc = ImagePickerViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [3, 1]:
            SL.pickerFile.complete { url, _ in
                SLFileBrowser(url).show()
            }.show()
        case [3, 2]:
            SL.pickerDate.date(Date()).mode(.dateAndTime).complete { date in
                SLHUD.showToast(date.description)
            }.show()
        case [3, 3]:
            SL.pickerTag
                .titles(["标签1", "标签2", "标签3", "标签4", "标签5", "标签6", "标签7", "标签8", "标签9", "标签10"])
                .maxNum(1)
                .complete { array in
                    SLHUD.showToast(array.first?.1)
                }.show()
        case [3, 4]:
            SL.pickerNormal
                .titles(["标签1", "标签2", "标签3", "标签4", "标签5", "标签6", "标签7", "标签8", "标签9", "标签10"])
                .complete { _, text in
                    SLHUD.showToast(text)
                }.show()
        case [4, 0]:
            if let url = URL(string: "App-Prefs:root") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case [4, 1]:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case [4, 2]:
            SL.tools.goAppStore(APPID)
        default:
            break
        }
    }
}
