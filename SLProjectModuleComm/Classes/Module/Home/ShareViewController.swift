//
//  ShareViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/22.
//

import UIKit
import SLIKit

class ShareViewController: BaseViewController {
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
    
    private var titles = ["文字", "图片", "链接", "视频", "音乐", "小程序"]
    private var type = 0 // 0=友盟 1=极光
    
    init(_ type: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    required convenience init() {
        self.init(0)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - LifeCyle
extension ShareViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "\(type == 0 ? "友盟" : "极光")分享"
        view.addSubview(tableView)
    }
    
    override func setVisitorPage() {
        setMasterView()
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
extension ShareViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == 0 {
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                SLUMServicer.shared.shareText("这是友盟分享内容") { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            case (0, 1):
                SLUMServicer.shared.shareImage("https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1091405991,859863778&fm=26&gp=0.jpg") { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            case (0, 2):
                SLUMServicer.shared.shareUrl("www.baidu.com", title: "这是链接", text: "这是内容这是内容这是内容这是内容这是内容这是内容", image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            case (0, 3):
                SLUMServicer.shared.shareVideo("http://v.youku.com/v_show/id_XOTQwMDE1ODAw.html?from=s1.8-1-1.2&spm=a2h0k.8191407.0.0", title: "这是视频", text: "这是内容这是内容这是内容这是内容这是内容这是内容", image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            case (0, 4):
                SLUMServicer.shared.shareAudio("http://c.y.qq.com/v8/playsong.html?songid=108782194&source=yqq#wechat_redirect", title: "这是音频", text: "这是内容这是内容这是内容这是内容这是内容这是内容", image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            case (0, 5):
                SLUMServicer.shared.shareMiniApp(title: "这是小程序", text: "小程序描述", url: "www.jiguang.cn", userName: "gh_d43f693ca31f", path: "pages/page", type: .release, image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            default:
                break
            }
        } else {
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                SLJGServicer.shared.shareText("这是极光分享内容") { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            case (0, 1):
                SLJGServicer.shared.shareImage("https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1091405991,859863778&fm=26&gp=0.jpg") { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            case (0, 2):
                SLJGServicer.shared.shareUrl("www.baidu.com", title: "这是链接", text: "这是内容这是内容这是内容这是内容这是内容这是内容", image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            case (0, 3):
                SLJGServicer.shared.shareVideo("http://v.youku.com/v_show/id_XOTQwMDE1ODAw.html?from=s1.8-1-1.2&spm=a2h0k.8191407.0.0", title: "这是视频", text: "这是内容这是内容这是内容这是内容这是内容这是内容", image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            case (0, 4):
                SLJGServicer.shared.shareAudio("https://y.qq.com/n/yqq/song/003RCA7t0y6du5.html", title: "这是音频", text: "这是内容这是内容这是内容这是内容这是内容这是内容", image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            case (0, 5):
                SLJGServicer.shared.shareMiniApp(title: "这是小程序", text: "小程序描述", url: "www.jiguang.cn", userName: "gh_d43f693ca31f", path: "pages/page", type: nil, image: UIImage(named: "wechatTimeLine50")) { (isSuccess) in
                    print("分享结果==>\(isSuccess)")
                }
            default:
                break
            }
        }
    }
}

// MARK: - Privater Methods
extension ShareViewController {
    override func bind() {
        super.bind()
    }
}

// MARK: - Event
extension ShareViewController {
    
}
