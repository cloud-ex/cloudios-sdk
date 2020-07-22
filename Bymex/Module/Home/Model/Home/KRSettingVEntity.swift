//
//  KRSettingVEntity.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum SettingTcType {
    case none
    case baseTC
    case defaultTC
    case switchTC
    case iconTC
    case selectTC
}

enum RecommendType {
    case none
    case deposit
    case withdraw
    case tranfer
    case help
    case fundrate
}

class KRSettingSecEntity: NSObject {
    var title = ""
    var contents : [KRSettingVEntity] = []
    var hasLogout  = false
}

class KRSettingVEntity: NSObject {
    var image_url = ""
    var platform = 0
    var name = "" // 名字
    var jump_url = ""
    var jump_type = 0
    var tnative_url = ""
    
    var switchType = "0"// 1开启 0关闭
    var defaule = ""// 默认
    var cellType = SettingTcType.defaultTC
    var isSelected = false
    
    var vmType = KRSetAccountType.none
    var rmType = RecommendType.none
}
