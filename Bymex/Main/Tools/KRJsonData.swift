//
//  KRJsonData.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

extension JSONSerialization{
    
    //将字典转成json字符串
    class func jsonDataFromDictToString(_ dict : [String : Any]) -> String{
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonStr = String.init(data: jsonData, encoding: String.Encoding.utf8){
                return jsonStr
            }
        }catch _ {
            
        }
        return ""
    }
    
}
