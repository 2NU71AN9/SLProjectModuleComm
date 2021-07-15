//
//  LanguageViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/15.
//

import UIKit
import SLIKit

class LanguageViewController: BaseViewController {
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
        .base
    
    private let dataArray = SLLanguageManager.shared.availableLanguages
}

// MARK: - LifeCyle
extension LanguageViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.discover_location.text
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
extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row].title
        cell.accessoryType = dataArray[indexPath.row].isCurrent ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = dataArray[indexPath.row]
        guard !language.isCurrent, let code = language.code else { return }
        SLLanguageManager.shared.setLanguage(with: code)
        tableView.reloadData()
    }
}

// MARK: - Privater Methods
extension LanguageViewController {
    override func bind() {
        super.bind()
    }
}

// MARK: - Event
extension LanguageViewController {
    
}
