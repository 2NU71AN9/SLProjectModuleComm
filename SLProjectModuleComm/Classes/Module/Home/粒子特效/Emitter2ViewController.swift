//
//  Emitter2ViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/8.
//

import UIKit
import SLIKit

class Emitter2ViewController: BaseViewController {
    private lazy var emitter: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.name = "emitterLayer"
        layer.emitterShape = .point // 发射器形状
        layer.emitterMode = .points // 发射器发射粒子的位置
        layer.emitterSize = CGSize(width: 0, height: 0) // 发射器大小
        layer.position = CGPoint(x: SL.SCREEN_WIDTH / 2, y: SL.SCREEN_HEIGHT + 50) // 发射器位置
        layer.renderMode = .oldestFirst
        layer.masksToBounds = false
        layer.zPosition = -1
        layer.emitterCells = [cell]
        return layer
    }()
    
    private lazy var cell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.birthRate = 1 // 每秒几次
        cell.lifetime = 1.3 // 粒子生命周期
        cell.velocity = 600 // 速度
        cell.velocityRange = 100
        cell.yAcceleration = 300 // 加速度
        cell.emissionLongitude = -CGFloat.pi / 2 // 方向
        cell.emissionRange = CGFloat.pi / 8
        cell.scale = 0.06 // 缩放
        cell.emitterCells = [subCell]
        let image = images[Int(arc4random_uniform(4))]
        cell.contents = image.cgImage
        return cell
    }()
    
    private lazy var subCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.birthRate = 5000 // 每秒几次
        cell.lifetime = 1.2 // 粒子生命周期
        cell.beginTime = 1.28 // 开始发射时间
        cell.velocity = CGFloat(Int(arc4random_uniform(100))) + 150 // 速度
        cell.yAcceleration = 50 // 加速度
        cell.emissionRange = CGFloat.pi * 2
        cell.scale = 0.8 // 缩放
        let image = images[Int(arc4random_uniform(4))]
        cell.contents = image.cgImage
        return cell
    }()
    
    private var images: [UIImage] = [R.image.emoji01200()~~,
                                     R.image.emoji02200()~~,
                                     R.image.emoji03200()~~,
                                     R.image.emoji04200()~~]

}

// MARK: - LifeCyle
extension Emitter2ViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "粒子特效2"
        view.layer.addSublayer(emitter)
    }
}
