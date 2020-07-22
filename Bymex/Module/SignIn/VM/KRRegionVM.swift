//
//  KRRegionVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRRegionVM: NSObject {
    weak var vc : KRRegionVc?
    func setVC(_ vc : KRRegionVc){
        self.vc = vc
    }
    var arr : [String:[RegionEntity]] = [:]
}

// 本地
extension KRRegionVM{
    //汉语排序
    func zh_nameTransForm(_ array : [RegionEntity]) -> [String:[RegionEntity]]{
        for item in array{
            let pinyin = self.transform(item.cnName)
            var type = ""
            if pinyin.count > 0{
                type = pinyin.first!.description
                if type >= "@" && type <= "Z"{
                    self.keyArray(type ,item:item)
                }
            }
        }
        return arr
    }
    
    func keyArray(_ str : String , item : RegionEntity){
        
        if arr[str] != nil{
            arr[str]?.append(item)
        }else{
            let array : [RegionEntity] = []
            arr[str] = array
            arr[str]?.append(item)
        }
    }
    
    func transform(_ chinese : String) -> String{
        let pinyin = NSMutableString.init(string: chinese)
        CFStringTransform(pinyin as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(pinyin as CFMutableString, nil, kCFStringTransformStripCombiningMarks, false)
        return pinyin.uppercased
    }
    
    //英语排序
    func us_nameTransForm(_ array : [RegionEntity]) -> [String:[RegionEntity]]{
        for item in array{
            let pinyin = self.transform(item.enName)
            var type = ""
            if pinyin.count > 0{
                type = pinyin.first!.description
                if type >= "@" && type <= "Z"{
                    self.keyArray(type ,item:item)
                }
            }
        }
        return arr
    }
    
}
