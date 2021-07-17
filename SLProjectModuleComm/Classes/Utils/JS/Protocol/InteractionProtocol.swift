//
//  InteractionProtocol.swift
//  AuxiliaryLine
//
//  Created by 孙梁 on 2020/8/31.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

protocol InteractionProtocol {
    func handleUrl(_ url: URL?)
}

extension InteractionProtocol where Self: SLJSViewController {
    func handleUrl(_ url: URL?) {
        guard let url = url else { return }
        if url.absoluteString.hasPrefix("hios://NaviBack") {
            dissmiss()
        } else if url.absoluteString.hasPrefix("hios://openNativeByPageName") {
            
        }
    }
}
