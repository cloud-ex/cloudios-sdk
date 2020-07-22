//
//  KRKeyBoadModel.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRKeyBoadModel: NSObject {

    var keyBoadString: String? // 键盘上的字母
    var isCapital: Bool? = false // 是否大写
    
    init(str: String, flag: Bool) {
        self.keyBoadString = str
        self.isCapital = flag
    }
}
