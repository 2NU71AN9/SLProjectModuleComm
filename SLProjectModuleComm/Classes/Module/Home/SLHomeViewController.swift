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
