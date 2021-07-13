//
//  JSAPI.swift
//  PGJManager-iOS
//
//  Created by 孙梁 on 2019/1/17.
//  Copyright © 2019 fg. All rights reserved.
//

import UIKit

enum JSAPI {
    case myClouse
    case classTeach_tab1
    case classTeach_tab2
    case classTeach_tab3
    case selfStudy_tab1
    case selfStudy_tab2
    case homework_tab1
    case homework_tab2
    case test
    case learningAnalysis
    case myClass
    case correcting
    case cooperationInquiry_tab1
    case cooperationInquiry_tab2
}

extension JSAPI {

    static let debugBaseURL = "http://192.168.7.50:8080"
    static let releaseBaseURL = "http://192.168.7.50:8080"

    var completeUrl: String {
        return baseURL + path + parameterStr
    }

    private var baseURL: String {
        #if DEBUG
        return JSAPI.debugBaseURL
        #else
        return JSAPI.releaseBaseURL
        #endif
    }
    private var path: String {
        switch self {
        case .myClouse:
            return ""
        case .classTeach_tab1:
            return "/#/courseTeach/courseTeachList"
        case .classTeach_tab2:
            return "/#/courseTeach/classRecord"
        case .classTeach_tab3:
            return "/#/courseTeach/workbenchRecord"
        case .selfStudy_tab1:
            return "/#/autonomicLearningParent/autonomicLearning/oneselfStudy"
        case .selfStudy_tab2:
            return "/#/autonomicLearningParent/autonomicLearning/publishRecord"
        case .homework_tab1:
            return "/#/homeWorkStatistics/index/releaseRecord?step=0"
        case .homework_tab2:
            return "/#/homeWorkStatistics/index/releaseRecord?step=1"
        case .test:
            return "/#/examination/index/sectionTopics"
        case .learningAnalysis:
            return ""
        case .myClass:
            return "/#/myClass/index"
        case .correcting:
            return "/#/taskCorrecting/index"
        case .cooperationInquiry_tab1:
            return "/#/cooperation/index?step=0"
        case .cooperationInquiry_tab2:
            return "/#/cooperation/index?step=1"
        }
    }
    private var parameterStr: String {
        return ""
    }

    var title: String? {
        switch self {
        case .classTeach_tab1:
            return "教学课程"
        case .classTeach_tab2:
            return "上课记录"
        case .classTeach_tab3:
            return "课堂检测"
        case .selfStudy_tab1:
            return "备课记录"
        case .selfStudy_tab2:
            return "发布记录"
        case .homework_tab1:
            return "作业记录"
        case .homework_tab2:
            return "发布记录"
        case .cooperationInquiry_tab1:
            return "探究内容"
        case .cooperationInquiry_tab2:
            return "探究任务"
        default:
            return nil
        }
    }
}
