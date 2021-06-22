//
//  JGAnalyticsProtocol.swift
//  SLJGServicer
//
//  Created by 孙梁 on 2021/1/8.
//

import UIKit
import CoreLocation

/**
 1. 头文件
    #import <UIKit/UIKit.h>
    #import "JANALYTICSService.h"
    如果需要使用idfa功能所需要引入的头文件（可选）
    #import <AdSupport/AdSupport.h>
 2. AppDelegate
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         if SLJGServicer.shared.handleOpenURL(url: url, options: options) == false {
             // 其他SDK的回调
         }
         return true
     }
 */
public protocol JGAnalyticsProtocol {
    /// 注册统计
    func registAnalytics(_ appKey: String) -> Self
    /// 页面流
    func startPage(_ vc: UIViewController)
    func stopPage(_ vc: UIViewController)
    /// 添加事件
    func addEvent(_ event: JGEventType)
    /// 绑定用户
    func bindUserInfo(_ userInfo: JANALYTICSUserInfo, complete: ((Int, String?) -> Void)?)
    /// 解绑当前绑定的用户
    func detachUserInfo(_ complete: ((Int, String?) -> Void)?)
    /// 地理位置上报
    func setLocation(latitude: Double, longitude: Double)
    func setLocation(_ location: CLLocation)
    
    /**
     设置周期上报频率
     默认为未设置频率，即时上报
     @param second 周期上报频率单位秒
     频率区间：0 或者 10 < frequency < 24*60*60
     可以设置为0，即表示取消周期上报频率，改为即时上报
     e.g. 十分钟上报一次 [JANALYTICSService setFrequency:600];
     */
    func setFrequency(_ second: Int)
}
 
public extension JGAnalyticsProtocol where Self: SLJGServicer {
    @discardableResult
    func registAnalytics(_ appKey: String) -> Self {
        let config = JANALYTICSLaunchConfig()
        config.appKey = appKey
        config.channel = "App Store"
        config.isProduction = true
        #if DEBUG
        config.isProduction = false
        #endif
        JANALYTICSService.setup(with: config)
        // 开启crash日志收集，默认是关闭状态
        JANALYTICSService.crashLogON()
        #if DEBUG
        JANALYTICSService.setDebug(true)
        #endif
        ViewControllerIntercepter.shared.intercepter()
        return self
    }
    
    func startPage(_ vc: UIViewController) {
        JANALYTICSService.startLogPageView("\(vc)")
    }
    func stopPage(_ vc: UIViewController) {
        JANALYTICSService.stopLogPageView("\(vc)")
    }
    
    func addEvent(_ event: JGEventType) {
        JANALYTICSService.eventRecord(event.eventObject)
    }
    
    func bindUserInfo(_ userInfo: JANALYTICSUserInfo, complete: ((Int, String?) -> Void)?) {
        JANALYTICSService.identifyAccount(userInfo, with: complete)
    }
    
    func detachUserInfo(_ complete: ((Int, String?) -> Void)?) {
        JANALYTICSService.detachAccount(complete)
    }
    
    func setLocation(latitude: Double, longitude: Double) {
        JANALYTICSService.setLatitude(latitude, longitude: longitude)
    }
    func setLocation(_ location: CLLocation) {
        JANALYTICSService.setLocation(location)
    }
    
    func setFrequency(_ second: Int) {
        JANALYTICSService.setFrequency(UInt(second))
    }
}
