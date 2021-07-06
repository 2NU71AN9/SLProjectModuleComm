//
//  SLHomeViewController.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/15.
//

import UIKit
import SLIKit
import JFCitySelector

class SLHomeViewController: BaseViewController {
    let guideManager = GuideManager()
}

// MARK: - LifeCyle
extension SLHomeViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "首页"
        guideManager.showMarks(over: self, complete: nil)
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
            let vc = FaceIDViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [0, 1]:
            let vc = FaceRecognitionViewController()
            present(vc, animated: true, completion: nil)
        case [0, 2]:
            let vc = TapticViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [0, 3]:
            let vc = SoundViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [0, 4]:
            let vc = SLQRCodeViewController { result in
                SLHUD.showToast(result?.strScanned)
            }
            navigationController?.pushViewController(vc, animated: true)
        case [0, 5]:
            let vc = QRCodeViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 0]:
            let vc = WaterfallFlowViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 1]:
            let vc = RefreshViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 2]:
            let vc = EmptyPageViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 3]:
            let vc = ToastViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 4]:
            let vc = SegmentViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 5]:
            let vc = ListNestViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 6]:
            let vc = CarouselViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 7]:
            let images = [1, 2, 3, 4, 5, 6, 7].compactMap { UIImage(named: "\($0)") }
            SLImageBrower.browser(images).show()
        case [1, 8]:
            let vc = MessageAlertViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 9]:
            let vc = PopMenuCustomViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 10]:
            let vc = MarqueeViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 11]:
            let vc = ScrollMsgViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [1, 12]:
            GuideManager.showGuide(false)
        case [1, 13]:
            guideManager.showMarks(false, over: self, complete: nil)
        case [2, 0]:
            let vc = ImagePickerViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [2, 1]:
            SL.pickerFile.complete { url, _ in
                SLFileBrowser(url).show()
            }.show()
        case [2, 2]:
            SL.pickerDate.date(Date()).mode(.dateAndTime).complete { date in
                SLHUD.showToast(date.description)
            }.show()
        case [2, 3]:
            SL.pickerTag
                .titles(["标签1", "标签2", "标签3", "标签4", "标签5", "标签6", "标签7", "标签8", "标签9", "标签10"])
                .maxNum(1)
                .complete { array in
                    SLHUD.showToast(array.first?.1)
                }.show()
        case [2, 4]:
            SL.pickerNormal
                .titles(["标签1", "标签2", "标签3", "标签4", "标签5", "标签6", "标签7", "标签8", "标签9", "标签10"])
                .complete { _, text in
                    SLHUD.showToast(text)
                }.show()
        case [2, 5]:
            SL.pickerAddress.type(.area).complete { p, c, a in
                SLHUD.showToast("\(p?.name ?? "")\(c?.name ?? "")\(a?.name ?? "")")
            }.show()
        case [2, 6]:
            let vc = FGMapChooseAddressViewController { (poi) in
                SLHUD.showToast(poi.addressDetailDesc)
            }
            let navi = UINavigationController(rootViewController: vc)
            navi.modalPresentationStyle = .fullScreen
            present(navi, animated: true, completion: nil)
        case [2, 7]:
            let config = JFCSConfiguration()
            config.isPinyinSearch = false
            let vc = JFCSTableViewController(configuration: config, delegate: self)
            vc.title = "选择城市"
            present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        case [3, 0]:
            let vc = CustomNavigationViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [3, 1]:
            let vc = DrawerViewController()
            navigationController?.pushViewController(vc, animated: true)
        case [3, 2]:
            let vc = GridViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension SLHomeViewController: JFCSTableViewControllerDelegate {
    func viewController(_ viewController: JFCSTableViewController, didSelectCity model: JFCSBaseInfoModel) {
        viewController.dismiss(animated: true, completion: nil)
        SLHUD.showToast(model.name)
    }
}
