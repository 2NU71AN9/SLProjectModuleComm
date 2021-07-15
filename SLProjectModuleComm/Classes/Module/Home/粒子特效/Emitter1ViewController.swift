//
//  Emitter1ViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/8.
//

import UIKit
import SLIKit

class Emitter1ViewController: BaseViewController {

    private lazy var emitter: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.name = "emitterLayer"
        layer.emitterShape = .line // 发射器形状
        layer.emitterMode = .outline // 发射器发射粒子的位置
        layer.emitterSize = CGSize(width: SL.SCREEN_WIDTH, height: 0) // 发射器大小
        layer.position = CGPoint(x: SL.SCREEN_WIDTH / 2, y: SL.SCREEN_HEIGHT + 50) // 发射器位置
        layer.renderMode = .oldestFirst
        layer.masksToBounds = false
        layer.zPosition = -1
        layer.emitterCells = cells
        return layer
    }()
    
    private lazy var cells: [CAEmitterCell] = {
        var cells: [CAEmitterCell] = []
        for index in 0 ... 10 {
            let cell = CAEmitterCell()
            cell.birthRate = 4 // 每秒几次
            cell.lifetime = 5 // 粒子生命周期
            cell.velocity = CGFloat(Int(arc4random_uniform(100))) + 50 // 速度
            cell.yAcceleration = -CGFloat(Int(arc4random_uniform(50))) - 50 // 加速度
            cell.emissionLongitude = 0 // 方向
            cell.emissionRange = CGFloat.pi / 4
            cell.spin = ((index % 2) == 0 ? -1 : 1) * CGFloat.pi * 2 // 自转
            cell.spinRange = CGFloat.pi * 2 / 2
            cell.scale = 0.06 // 缩放
            cell.scaleRange = 0.04
            let image = images[Int(arc4random_uniform(4))]
            cell.contents = image.cgImage
            cells.append(cell)
        }
        return cells
    }()
    
    private var images: [UIImage] = [R.image.emoji01200()~~,
                                     R.image.emoji02200()~~,
                                     R.image.emoji03200()~~,
                                     R.image.emoji04200()~~]
}

// MARK: - LifeCyle
extension Emitter1ViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.home_emitter.text
        view.layer.addSublayer(emitter)
    }
}
