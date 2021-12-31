//
//  SwiftUIViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/12/30.
//

import UIKit
import SwiftUI

class SwiftUIViewController: BaseViewController {
    private lazy var controller: UIHostingController<ContentView> = {
        let controller = UIHostingController(rootView: ContentView("哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"))
        controller.view.frame = view.bounds
        return controller
    }()
}

// MARK: - LifeCyle
extension SwiftUIViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.home_SwiftUI.text
        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}

struct ContentView: View {
    
    private var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text("\(title)")
    }
}
