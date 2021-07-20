//
//  VideoDetailViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/20.
//

import UIKit
import ZFPlayer
import SLIKit
import AVKit

class VideoDetailViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var popCallback: (() -> Void)?
    var playCallback: (() -> Void)?
    var player: ZFPlayerController?
    
    init(_ player: ZFPlayerController?, popCallback: (() -> Void)?, playCallback: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.player = player
        self.popCallback = popCallback
        self.playCallback = playCallback
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required convenience init() {
        self.init(nil, popCallback: nil, playCallback: nil)
    }
}

// MARK: - LifeCyle
extension VideoDetailViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "视频播放"
        player?.addPlayerView(toContainerView: imageView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 继续播放
        player?.currentPlayerManager.play()
//        playCallback?()
//        player?.addPlayerView(toContainerView: imageView)
    }
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            popCallback?()
        }
    }
    override var shouldAutorotate: Bool {
        false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if player?.isFullScreen ?? false {
            return .lightContent
        }
        return .default
    }
    override var prefersStatusBarHidden: Bool {
        false
    }
}
