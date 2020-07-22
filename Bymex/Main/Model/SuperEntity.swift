//
//  SuperEntity.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

@objcMembers class KRBaseModel : NSObject{

}

@objcMembers class SuperEntity: NSObject {
    
    var dict : [String : Any] = [:]//保存的字典
    
    var key : String = ""//实体的key
    
    var value : String = ""//实体的value,不可以存储数组，字典等复合类型的数据
    
    /*传入字典和需要保护的属性，保护的属性为字符串形式*/
    public func setEntitiyWithDict(_ dict : [String : Any] , _ unsafeEntities : [String] = []) {
        setValueOfDict(dict ,unsafeEntities)
    }

    /**
     获取对象对于的属性值，无对于的属性则返回NIL
     - parameter property: 要获取值的属性
     - returns: 属性的值
     */
    public func getValueOfProperty(property:String)->AnyObject?{
        
        let allPropertys = self.getAllPropertys()
        
        if(allPropertys.contains(property)){
            return self.value(forKey: property) as AnyObject
        }else{
            return nil
        }
        
    }
    
    /**
     根据字典传值设置对象属性的值
     */
    public func setValueOfDict(_ dict : [String : Any] , _ unsafeEntities : [String] = []){
        let allPropertys = self.getAllPropertys()
        for key in dict.keys{
            if unsafeEntities.contains(key) == false{
                if(allPropertys.contains(key)){
                    if dict[key] != nil && !(dict[key] is NSNull){//防止空
                        let valueStr = "\(dict[key]!)"
                        self.setValue(valueStr, forKey: key)
                    }
                }
            }
        }
    }
    
    
    /**
     设置对象属性的值
     - parameter property: 属性
     - parameter value:    值
     - returns: 是否设置成功
     
     */
    public func setValueOfProperty(_ property:String,_ value:Any)->Bool{
        
        let allPropertys = self.getAllPropertys()
        
        if(allPropertys.contains(property)){
            //防止崩溃
            let valueStr = String(describing: value)
            self.setValue(valueStr, forKey: property)
            return true
        }else{
            return false
        }
    }
    
    /**
     获取对象的所有属性名称
     - returns: 属性名称数组
     */
    
    public func getAllPropertys()->[String]{
        
        var result = [String]()
        
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        
        guard let buff = class_copyPropertyList(object_getClass(self), count) else{return []}
        
        let countInt = Int(count[0])
        
        for i in 0..<countInt{
            let temp = buff[i]
            let tempPro = property_getName(temp)
            if let proper = String.init(utf8String: tempPro){
                result.append(proper)
            }
        }
        
        return result
    }
    
}

extension SuperEntity{
    
    open func config(_ dic: [String : Any]) {
        self.setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if value is NSNull || value == nil {
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }
    
}

extension SuperEntity{
    func setEntityWithDict(_ dict : [String : Any]){
        self.dict = dict
    }
    
    //MARK:设置属性
    func dictContains(_ key : String , defaultStr : String = "") -> String{
        var value = ""
        if self.dict.keys.contains(key) &&
            (dict[key] as? NSNull == nil) &&
            (dict[key] as? String ?? "" != "null"){//服务端返回的不是null类型，并且也不是字符串“null”
            value = String(describing:dict[key] ?? defaultStr)
        }else {
            value = defaultStr
        }
        return value
    }
    
    func getDicWithKeys(_ dict : [String : Any]) -> [String : Any]{
        
        return [:]
    }
    
}
