//
//  GuideManager.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/1.
//

import UIKit
import EAIntroView
import SLIKit

class GuideManager: NSObject {
    static func show() {
        let page1 = EAIntroPage()
        page1.title = "关雎"
        page1.desc = "关关雎鸠，在河之洲。窈窕淑女，君子好逑。\n参差荇菜，左右流之。窈窕淑女，寤寐求之。\n求之不得，寤寐思服。悠哉悠哉，辗转反侧。\n参差荇菜，左右采之。窈窕淑女，琴瑟友之。\n参差荇菜，左右芼之。窈窕淑女，钟鼓乐之。"
        page1.titleIconView = UIImageView(image: R.image.emoji01200())
        page1.titleIconPositionY = SL.statusBarHeight + 80
        page1.titlePositionY = 140 + SL.bottomHeight + 80
        page1.descPositionY = 140 + SL.bottomHeight + 80

        let page2 = EAIntroPage()
        page2.title = "木瓜"
        page2.desc = "投我以木瓜，报之以琼琚。匪报也，永以为好也！\n投我以木桃，报之以琼瑶。匪报也，永以为好也！\n投我以木李，报之以琼玖。匪报也，永以为好也！"
        page2.titleIconView = UIImageView(image: R.image.emoji02200())
        page2.titleIconPositionY = SL.statusBarHeight + 80
        page2.titlePositionY = 140 + SL.bottomHeight + 80
        page2.descPositionY = 140 + SL.bottomHeight + 80
        
        let page3 = EAIntroPage()
        page3.title = "无衣"
        page3.desc = "岂曰无衣？七兮。不如子之衣，安且吉兮。\n岂曰无衣？六兮。不如子之衣，安且燠兮。"
        page3.titleIconView = UIImageView(image: R.image.emoji03200())
        page3.titleIconPositionY = SL.statusBarHeight + 80
        page3.titlePositionY = 140 + SL.bottomHeight + 80
        page3.descPositionY = 140 + SL.bottomHeight + 80
        
        let page4 = EAIntroPage()
        page4.title = "桃夭"
        page4.desc = "桃之夭夭，灼灼其华。之子于归，宜其室家。\n桃之夭夭，有蕡其实。之子于归，宜其家室。\n桃之夭夭，其叶蓁蓁。之子于归，宜其家人。"
        page4.titleIconView = UIImageView(image: R.image.emoji04200())
        page4.titleIconPositionY = SL.statusBarHeight + 80
        page4.titlePositionY = 140 + SL.bottomHeight + 80
        page4.descPositionY = 140 + SL.bottomHeight + 80
        
        let intro = EAIntroView(frame: SL.SCREEN_BOUNS, andPages: [page1, page2, page3, page4])
        intro?.backgroundColor = UIColor.sl.random
        intro?.tapToNext = true
        intro?.skipButtonAlignment = .center
        intro?.skipButtonY = 80 + SL.bottomHeight
        intro?.pageControlY = 42 + SL.bottomHeight
        intro?.show(in: UIApplication.shared.windows.last, animateDuration: 0.3)
    }
}
