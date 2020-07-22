//
//  KRDrawerSiftEntity.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  筛选实例

import Foundation

class KRDrawerSiftSecEntity: NSObject {
    var title = ""
    var content : [KRDrawerSiftRowEntity] = []
}

class KRDrawerSiftRowEntity: NSObject {
    var name = ""
    var isSelect = false
    var type = 0 // 表示全部
}
