//
//  TransitionViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/6.
//

import UIKit
import Hero

class TransitionViewController: BaseViewController {
    
    private var showAnimType: HeroDefaultAnimationType = .push(direction: .left)
    private var dismissAnimType: HeroDefaultAnimationType = .push(direction: .left)
    private var showDt: HeroDefaultAnimationType.Direction = .left
    private var dismissDt: HeroDefaultAnimationType.Direction = .left
    
    @IBOutlet weak var animTypeSeg: UISegmentedControl!
    @IBOutlet weak var showDtSeg: UISegmentedControl!
    @IBOutlet weak var dismissDtSeg: UISegmentedControl!
    
    @IBOutlet weak var showBtn2: UIButton! {
        didSet {
            showBtn2.heroID = "showBtn2"
        }
    }
    
    @IBAction func animTypeSegAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showAnimType = .push(direction: showDt)
            dismissAnimType = .push(direction: dismissDt)
        case 1:
            showAnimType = .pull(direction: showDt)
            dismissAnimType = .pull(direction: dismissDt)
        case 2:
            showAnimType = .cover(direction: showDt)
            dismissAnimType = .cover(direction: dismissDt)
        case 3:
            showAnimType = .uncover(direction: showDt)
            dismissAnimType = .uncover(direction: dismissDt)
        case 4:
            showAnimType = .slide(direction: showDt)
            dismissAnimType = .slide(direction: dismissDt)
        case 5:
            showAnimType = .zoomSlide(direction: showDt)
            dismissAnimType = .zoomSlide(direction: dismissDt)
        case 6:
            showAnimType = .pageIn(direction: showDt)
            dismissAnimType = .pageIn(direction: dismissDt)
        case 7:
            showAnimType = .pageOut(direction: showDt)
            dismissAnimType = .pageOut(direction: dismissDt)
        case 8:
            showAnimType = .fade
            dismissAnimType = .fade
        case 9:
            showAnimType = .zoom
            dismissAnimType = .zoom
        case 10:
            showAnimType = .zoomOut
            dismissAnimType = .zoomOut
        default:
            break
        }
    }
    @IBAction func showDtSegAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showDt = .left
        case 1:
            showDt = .right
        case 2:
            showDt = .up
        case 3:
            showDt = .down
        default:
            break
        }
        animTypeSegAction(animTypeSeg)
    }
    @IBAction func dismissDtSegAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            dismissDt = .left
        case 1:
            dismissDt = .right
        case 2:
            dismissDt = .up
        case 3:
            dismissDt = .down
        default:
            break
        }
        animTypeSegAction(animTypeSeg)
    }
    @IBAction func showAction(_ sender: UIButton) {
        let vc = Transition2ViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .selectBy(presenting: showAnimType, dismissing: dismissAnimType)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showAction2(_ sender: UIButton) {
        let vc = Transition2ViewController()
        navigationController?.hero.isEnabled = true
        navigationController?.heroNavigationAnimationType = .selectBy(presenting: showAnimType, dismissing: dismissAnimType)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - LifeCyle
extension TransitionViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "转场动画"
    }
}
