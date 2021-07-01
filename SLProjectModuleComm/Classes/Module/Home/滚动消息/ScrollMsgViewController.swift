//
//  ScrollMsgViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/1.
//

import UIKit
import RollingNotice_Swift
import SLIKit

class ScrollMsgViewController: BaseViewController {
    private lazy var msgView1: GYRollingNoticeView = {
        let view = GYRollingNoticeView()
        view.stayInterval = 3
        view.delegate = self
        view.dataSource = self
        view.register(UINib(nibName: "ScrollMsgCell", bundle: nil), forCellReuseIdentifier: "ScrollMsgCell")
        return view
    }()
    private lazy var msgView2: GYRollingNoticeView = {
        let view = GYRollingNoticeView()
        view.delegate = self
        view.dataSource = self
        view.register(GYNoticeViewCell.self, forCellReuseIdentifier: "GYNoticeViewCell")
        return view
    }()
    
    let messages1 = ["自定义cell-1111111111111111", "自定义cell-2222222222222222", "自定义cell-33333333333333333333333", "自定义cell-4444444444444444", "自定义cell-555555555555555555555"]
    let messages2 = ["普通cell-1111111111111111", "普通cell-2222222222222222", "普通cell-33333333333333333333333", "普通cell-4444444444444444", "普通cell-555555555555555555555"]
}

// MARK: - LifeCyle
extension ScrollMsgViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "滚动消息"
        view.addSubview(msgView1)
        view.addSubview(msgView2)
        msgView1.reloadDataAndStartRoll()
        msgView2.reloadDataAndStartRoll()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        msgView1.snp.sl.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(150)
            make.height.equalTo(80)
        }
        msgView2.snp.sl.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(msgView1.snp.bottom).offset(100)
            make.height.equalTo(50)
        }
    }
}

extension ScrollMsgViewController: GYRollingNoticeViewDelegate, GYRollingNoticeViewDataSource {
    func numberOfRowsFor(roolingView: GYRollingNoticeView) -> Int {
        roolingView == msgView1 ? messages1.count : messages2.count
    }
    
    func rollingNoticeView(roolingView: GYRollingNoticeView, cellAtIndex index: Int) -> GYNoticeViewCell {
        if roolingView == msgView1 {
            let cell = roolingView.dequeueReusableCell(withIdentifier: "ScrollMsgCell") as? ScrollMsgCell
            cell?.label.text = messages1[index]
            return cell!
        } else {
            let cell = roolingView.dequeueReusableCell(withIdentifier: "GYNoticeViewCell")
            cell?.textLabel.text = messages2[index]
            cell?.contentView.backgroundColor = .yellow
            if index % 2 == 0 {
                cell?.contentView.backgroundColor = .green
            }
            cell?.textLabelLeading = 20
            return cell!
        }
    }
    
    func rollingNoticeView(_ roolingView: GYRollingNoticeView, didClickAt index: Int) {
         print("\(index)")
    }
}

// MARK: - Privater Methods
extension ScrollMsgViewController {
    override func bind() {
        super.bind()
    }
}

// MARK: - Event
extension ScrollMsgViewController {
    
}
