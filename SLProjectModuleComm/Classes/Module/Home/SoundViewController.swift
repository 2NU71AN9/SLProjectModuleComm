//
//  SoundViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/6/23.
//

import UIKit
import Peep

class SoundViewController: BaseViewController {
    @IBAction func btn1Action(_ sender: UIButton) {
        Peep.play(sound: AlertTone.tweet)
    }
    @IBAction func btn2Action(_ sender: UIButton) {
        Peep.play(sound: AlertTone.alert)
    }
    @IBAction func btn3Action(_ sender: UIButton) {
        Peep.play(sound: KeyPress.tap)
    }
    @IBAction func btn4Action(_ sender: UIButton) {
        Peep.play(sound: Bundle.main.url(forResource: "Example_Success", withExtension: "m4a"))
    }
}
