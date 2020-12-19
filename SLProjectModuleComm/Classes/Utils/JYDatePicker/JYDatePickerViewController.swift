//
//  JYDatePickerViewController.swift
//  Artist
//
//  Created by 孙梁 on 2020/3/4.
//  Copyright © 2020 2UN7. All rights reserved.
//

import UIKit
import SLSupportLibrary
import pop
import RxSwift

class JYDatePickerViewController: UIViewController {

    let dateSubject = PublishSubject<Date>()
    var mode: UIDatePicker.Mode = .date
    var initDate: Date = Date()
    var minDate: Date?
    var maxDate: Date?
    var complete: ((Date) -> Void)?

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewHeight: NSLayoutConstraint! {
        didSet {
            viewHeight.constant = 266 + bottomHeight
        }
    }
    @IBOutlet weak var bottomGap: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = mode
        datePicker.date = initDate
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        show()
    }

    init(mode: UIDatePicker.Mode, initDate: Date? = nil, minDate: Date? = nil, maxDate: Date? = nil, complete: ((Date) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        self.mode = mode
        self.initDate = initDate ?? Date()
        self.minDate = minDate
        self.maxDate = maxDate
        self.complete = complete
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if touches.contains(where: { $0.view == view }) {
            hide()
        }
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        hide()
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        dateSubject.onNext(datePicker.date)
        complete?(datePicker.date)
        hide()
    }
}

extension JYDatePickerViewController: UIPickerViewDelegate {

}

extension JYDatePickerViewController {
    private func show() {
        let anim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        anim?.toValue = 0
        bottomGap.pop_add(anim, forKey: nil)
    }
    @objc private func hide() {
        let anim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        anim?.toValue = -266
        bottomGap.pop_add(anim, forKey: nil)
        dismiss(animated: true, completion: nil)
    }
}
