//
//  CarouselViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/28.
//

import UIKit
import FSPagerView

class CarouselViewController: BaseViewController {
    
    private let num = 7
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            pagerView.delegate = self
            pagerView.dataSource = self
            pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            pageControl.backgroundColor = .clear
            pageControl.numberOfPages = num
            pageControl.contentHorizontalAlignment = .center
            pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            pageControl.hidesForSinglePage = true
        }
    }
    
    @IBOutlet weak var autoSw: UISwitch!
    @IBOutlet weak var infiniteSw: UISwitch!
    @IBOutlet weak var itemSizeSl: UISlider!
    @IBOutlet weak var itemSpaceSl: UISlider!
    
    @IBOutlet weak var animSeg: UISegmentedControl!
    
    @IBOutlet weak var pageControlSeg: UISegmentedControl!
    @IBOutlet weak var pcSizeSl: UISlider!
    @IBOutlet weak var pcSapceSl: UISlider!
    
    /// 自动播放
    @IBAction func autoSwAction(_ sender: UISwitch) {
        pagerView.automaticSlidingInterval = sender.isOn ? 2 : 0
    }
    /// 无限
    @IBAction func infiniteSwAction(_ sender: UISwitch) {
        pagerView.isInfinite = sender.isOn
    }
    @IBAction func itemSizeAction(_ sender: UISlider) {
        let newScale = 0.5 + CGFloat(sender.value) * 0.5 // [0.5 - 1.0]
        pagerView.itemSize = pagerView.frame.size.applying(CGAffineTransform(scaleX: newScale, y: newScale))
    }
    @IBAction func itemSpaceAction(_ sender: UISlider) {
        pagerView.interitemSpacing = CGFloat(sender.value) * 20 // [0 - 20]
    }
    /// 动画方式
    @IBAction func animAction(_ sender: UISegmentedControl) {
        animtTypeIndex = sender.selectedSegmentIndex
    }
    private let transformerTypes: [FSPagerViewTransformerType] = [.crossFading, .zoomOut, .depth, .linear, .overlap, .ferrisWheel, .invertedFerrisWheel, .coverFlow, .cubic]
    private var animtTypeIndex = 0 {
        didSet {
            itemSizeSl.isEnabled = animtTypeIndex <= 2
            itemSpaceSl.isEnabled = itemSizeSl.isEnabled
            
            let type = transformerTypes[animtTypeIndex]
            pagerView.transformer = FSPagerViewTransformer(type: type)
            switch type {
            case .crossFading, .zoomOut, .depth:
                pagerView.itemSize = FSPagerView.automaticSize
                pagerView.decelerationDistance = 1
            case .linear, .overlap:
                let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
                pagerView.itemSize = pagerView.frame.size.applying(transform)
                pagerView.decelerationDistance = FSPagerView.automaticDistance
            case .ferrisWheel, .invertedFerrisWheel:
                pagerView.itemSize = CGSize(width: 180, height: 140)
                pagerView.decelerationDistance = FSPagerView.automaticDistance
            case .coverFlow:
                pagerView.itemSize = CGSize(width: 220, height: 170)
                pagerView.decelerationDistance = FSPagerView.automaticDistance
            case .cubic:
                let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                pagerView.itemSize = pagerView.frame.size.applying(transform)
                pagerView.decelerationDistance = 1
            }
        }
    }
    
    @IBAction func pcAction(_ sender: UISegmentedControl) {
        pcStyleIndex = sender.selectedSegmentIndex
    }
    @IBAction func pcSizeAction(_ sender: UISlider) {
        pageControl.itemSpacing = 6.0 + CGFloat(sender.value * 10.0) // [6 - 16]
        // Redraw UIBezierPath
        if [3, 4].contains(pcStyleIndex) {
            let index = pcStyleIndex
            pcStyleIndex = index
        }
        
    }
    @IBAction func pcSpaceAction(_ sender: UISlider) {
        pageControl.interitemSpacing = 6.0 + CGFloat(sender.value * 10.0) // [6 - 16]
    }
    
    fileprivate var pcStyleIndex = 0 {
        didSet {
            // Clean up
            pageControl.setStrokeColor(nil, for: .normal)
            pageControl.setStrokeColor(nil, for: .selected)
            pageControl.setFillColor(nil, for: .normal)
            pageControl.setFillColor(nil, for: .selected)
            pageControl.setImage(nil, for: .normal)
            pageControl.setImage(nil, for: .selected)
            pageControl.setPath(nil, for: .normal)
            pageControl.setPath(nil, for: .selected)
            switch pcStyleIndex {
            case 0:
                // Default
                break
            case 1:
                // Ring
                pageControl.setStrokeColor(.green, for: .normal)
                pageControl.setStrokeColor(.green, for: .selected)
                pageControl.setFillColor(.green, for: .selected)
            case 2:
                // Image
                pageControl.setImage(UIImage(named: "icon_footprint"), for: .normal)
                pageControl.setImage(UIImage(named: "icon_cat"), for: .selected)
            case 3:
                // UIBezierPath - Star
                pageControl.setStrokeColor(.yellow, for: .normal)
                pageControl.setStrokeColor(.yellow, for: .selected)
                pageControl.setFillColor(.yellow, for: .selected)
                pageControl.setPath(starPath, for: .normal)
                pageControl.setPath(starPath, for: .selected)
            case 4:
                // UIBezierPath - Heart
                let color = UIColor(red: 255 / 255.0, green: 102 / 255.0, blue: 255 / 255.0, alpha: 1.0)
                pageControl.setStrokeColor(color, for: .normal)
                pageControl.setStrokeColor(color, for: .selected)
                pageControl.setFillColor(color, for: .selected)
                pageControl.setPath(heartPath, for: .normal)
                pageControl.setPath(heartPath, for: .selected)
            default:
                break
            }
        }
    }
    // ⭐️
    fileprivate var starPath: UIBezierPath {
        let width = pageControl.itemSpacing
        let height = pageControl.itemSpacing
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: width * 0.5, y: 0))
        starPath.addLine(to: CGPoint(x: width * 0.677, y: height * 0.257))
        starPath.addLine(to: CGPoint(x: width * 0.975, y: height * 0.345))
        starPath.addLine(to: CGPoint(x: width * 0.785, y: height * 0.593))
        starPath.addLine(to: CGPoint(x: width * 0.794, y: height * 0.905))
        starPath.addLine(to: CGPoint(x: width * 0.5, y: height * 0.8))
        starPath.addLine(to: CGPoint(x: width * 0.206, y: height * 0.905))
        starPath.addLine(to: CGPoint(x: width * 0.215, y: height * 0.593))
        starPath.addLine(to: CGPoint(x: width * 0.025, y: height * 0.345))
        starPath.addLine(to: CGPoint(x: width * 0.323, y: height * 0.257))
        starPath.close()
        return starPath
    }
    
    // ❤️
    fileprivate var heartPath: UIBezierPath {
        let width = pageControl.itemSpacing
        let height = pageControl.itemSpacing
        let heartPath = UIBezierPath()
        heartPath.move(to: CGPoint(x: width * 0.5, y: height))
        heartPath.addCurve(
            to: CGPoint(x: 0, y: height * 0.25),
            controlPoint1: CGPoint(x: width * 0.5, y: height * 0.75) ,
            controlPoint2: CGPoint(x: 0, y: height * 0.5)
        )
        heartPath.addArc(
            withCenter: CGPoint(x: width * 0.25, y: height * 0.25),
            radius: width * 0.25,
            startAngle: .pi,
            endAngle: 0,
            clockwise: true
        )
        heartPath.addArc(
            withCenter: CGPoint(x: width * 0.75, y: height * 0.25),
            radius: width * 0.25,
            startAngle: .pi,
            endAngle: 0,
            clockwise: true
        )
        heartPath.addCurve(
            to: CGPoint(x: width * 0.5, y: height),
            controlPoint1: CGPoint(x: width, y: height * 0.5),
            controlPoint2: CGPoint(x: width * 0.5, y: height * 0.75)
        )
        heartPath.close()
        return heartPath
    }
}

// MARK: - LifeCyle
extension CarouselViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "轮播"
    }
    
    override func setVisitorPage() {
        setMasterView()
    }
}

extension CarouselViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        num
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: "\(index + 1)")
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
}
