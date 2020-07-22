//
//  KRKeyBoardUtil.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRKeyBoardUtil: NSObject {
    static var numberSource = ["1","2","3","4","5","6","7","8","9","0","·"]
}

extension KRKeyBoardUtil {
    static func getNumberSourceBy() -> [KRKeyBoadModel] {
        var array = [KRKeyBoadModel]()
        for m in 0...numberSource.count - 1 {
            let str = numberSource[m]
            let model = KRKeyBoadModel.init(str: str, flag: false)
            array.append(model)
        }
        return array
    }
}
