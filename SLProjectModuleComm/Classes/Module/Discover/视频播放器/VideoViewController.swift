//
//  VideoViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/20.
//

import UIKit
import ZFPlayer
import SLIKit

let kPlayerViewTag = 149

class VideoViewController: BaseViewController {
    private lazy var tableView = UITableView(frame: CGRect.zero, style: .plain).sl
        .showsVerticalScrollIndicator(false)
        .showsHorizontalScrollIndicator(false)
        .delegate(self)
        .dataSource(self)
        .rowHeight(UITableView.automaticDimension)
        .estimatedRowHeight(80)
        .estimatedSectionHeaderHeight(0)
        .estimatedSectionFooterHeight(0)
        .separatorStyle(.none)
        .registerNib(VideoPlayerCell.self)
        .base
    
    private lazy var playerManager: ZFAVPlayerManager = {
        let manager = ZFAVPlayerManager()
        return manager
    }()
    
    private lazy var player: ZFPlayerController = {
        let player = ZFPlayerController(scrollView: tableView, playerManager: playerManager, containerViewTag: kPlayerViewTag)
        player.controlView = controlView
        /// 移动网络依然自动播放
        player.isWWANAutoPlay = true
        /// 1.0是完全消失的时候
        player.playerDisapperaPercent = 1.0
        /// 0.0是刚开始显示的时候
        player.playerApperaPercent = 0.0
        player.orientationWillChange = { _, isFullScreen in
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
//                delegate.allowOrentitaionRotation = isFullScreen
            }
        }
        player.playerDidToEnd = { [weak self] _ in
            self?.controlView.resetControlView()
            player.stopCurrentPlayingCell()
        }
        /// 停止的时候找出最合适的播放
        player.zf_scrollViewDidEndScrollingCallback = { [weak self] indexPath in
            if player.playingIndexPath == nil {
                self?.playTheVideoAtIndexPath(indexPath)
            }
        }
        /// 以下设置滑出屏幕后不停止播放
        player.stopWhileNotVisible = false
        
        var margin: CGFloat = 20
        var w = SL.SCREEN_WIDTH / 2
        var h = w * 9 / 16
        var x = SL.SCREEN_WIDTH - w - margin
        var y = SL.SCREEN_HEIGHT - h - margin
        player.smallFloatView.frame = CGRect(x: x, y: y, width: w, height: h)
        return player
    }()
    
    private lazy var controlView: ZFPlayerControlView = {
        let ctr = ZFPlayerControlView()
        return ctr
    }()
    
    private lazy var dataArray: [VideoModel] = []
}

// MARK: - LifeCyle
extension VideoViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "视频播放"
        view.addSubview(tableView)
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.isViewControllerDisappear = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.isViewControllerDisappear = true
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.sl.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            tableView.delegate = nil
            player.stopCurrentPlayingCell()
        }
    }
    
    override var shouldAutorotate: Bool {
        false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    override var prefersStatusBarHidden: Bool {
        false
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoPlayerCell", for: indexPath) as? VideoPlayerCell
        cell?.indexPath = indexPath
        cell?.model = dataArray[indexPath.row]
        cell?.playVideoAtIndexPath = { [weak self] indexPath in
            self?.playTheVideoAtIndexPath(indexPath)
        }
        return cell~~
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        videoDetail(indexPath)
    }
}

extension VideoViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidEndDecelerating()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.zf_scrollViewDidEndDraggingWillDecelerate(decelerate)
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScrollToTop()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScroll()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewWillBeginDragging()
    }
}

// MARK: - Privater Methods
extension VideoViewController {
    override func bind() {
        super.bind()
    }
    
    private func loadData() {
        if let dict = Bundle.main.sl.loadJSON(with: "videoData") as? [String: Any],
           let list = dict["list"] as? [[String: Any]],
           let models = [VideoModel].deserialize(from: list) as? [VideoModel] {
            dataArray = models
            tableView.reloadData()
            player.zf_filterShouldPlayCellWhileScrolled { [weak self] indexPath in
                self?.playTheVideoAtIndexPath(indexPath)
            }
        }
    }
    
    private func playTheVideoAtIndexPath(_ indexPath: IndexPath) {
        guard let video_url = dataArray[indexPath.row].video_url,
              let url = URL(string: video_url) else { return }
        player.playTheIndexPath(indexPath, assetURL: url)
        controlView.showTitle(dataArray[indexPath.row].title, coverURLString: dataArray[indexPath.row].thumbnail_url, placeholderImage: nil, fullScreenMode: .landscape)
    }
}

// MARK: - Event
extension VideoViewController {
    private func videoDetail(_ indexPath: IndexPath) {
        /// 如果正在播放的index和当前点击的index不同，则停止当前播放的index
        if player.playingIndexPath != indexPath {
            player.stopCurrentPlayingCell()
        }
        /// 如果没有播放，则点击进详情页会自动播放
        if !self.player.currentPlayerManager.isPlaying {
            playTheVideoAtIndexPath(indexPath)
        }
        /// 到详情页
        let vc = VideoDetailViewController(player) { [weak self] in
            self?.player.addPlayerViewToCell()
        } playCallback: {
            self.playTheVideoAtIndexPath(indexPath)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
