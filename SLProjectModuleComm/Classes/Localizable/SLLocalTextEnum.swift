//
//  SLLocalTextEnum.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/14.
//

public enum SLLocalText: String {
    case login
    case logout
    case tab_home
    case tab_discover
    case tab_my
    
    case home_faceId_TouchID
    case home_faceDetector
    case home_taptic
    case home_sound
    case home_QRCodeScan
    case home_QRCodeMaker
    case home_waterfall
    case home_refreshAndLoad
    case home_emptyPage
    case home_toast
    case home_naviPage
    case home_listNest
    case home_carouse
    case home_imageBrowser
    case home_alert
    case home_popMenu
    case home_marquee
    case home_rollingNotice
    case home_guide
    case home_instruction
    case home_screenShot
    case home_swipeCell
    case home_imagePicker
    case home_filePicker
    case home_datePicker
    case home_tagPicker1
    case home_tagPicker2
    case home_addressPicker
    case home_addressPicker_gaode
    case home_cityPicker
    case home_customNavigation
    case home_drawer
    case home_gridView
    case home_transitionAnimation
    case home_tableViewCellAnimation
    case home_star
    case home_emitter
    
    case discover_UMShare
    case discover_JGShare
    case discover_wechatPayAndAliPay
    case discover_inPurchase
    case discover_RYIM
    case discover_netWork
    case discover_socket
    case discover_GCD
    case discover_component
    case discover_AOP
    case discover_stringInterpolation
    case discover_customOperator
    case discover_JS
    case discover_webView
    case discover_authority
    case discover_location
    case discover_crypto
    case discover_videoPlayer
    case discover_audioPlayer
    
    case my_iPhoneName
    case my_iPhoneDesc
    case my_sysName
    case my_systemVersion
    case my_batteryLevel
    case my_networkStatus
    case my_IP
    case my_wifiIP
    case my_wifiName
    case my_wifiMacAddress
    case my_cleanCache
    case my_localizable
    case my_darkMode
    case my_goSysSet
    case my_goAppSet
    case my_goAppStore
}

public extension SLLocalText {
    var text: String { NSLocalizedString(rawValue, comment: "") }
}
