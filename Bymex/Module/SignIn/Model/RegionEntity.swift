//
//  RegionEntity.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class RegionEntity: SuperEntity {
    
    var enName = ""
    
    var cnName = ""
    
    var dialingCode = ""
    
    var numberCode = ""
    
    var showName = ""
    
    var pinyin = ""
    
    override func setEntityWithDict(_ dict : [String : Any]){
        super.setEntityWithDict(dict)
        enName = dictContains("enName")
        cnName = dictContains("cnName")
        dialingCode = dictContains("dialingCode")
        numberCode = dictContains("numberCode")
        showName = dictContains("showName")
    }
    
}
class RegionManager : NSObject{
    //MARK:单例
    public static var sharedInstance : RegionManager{
        struct Static {
            static let instance : RegionManager = RegionManager()
        }
        return Static.instance
    }
    
    var regionEntity = RegionEntity()
    
}
