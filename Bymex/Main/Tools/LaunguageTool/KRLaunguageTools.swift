//
//  KRLaunguageTools.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

let UserLanguage = "UserLanguage"

let AppleLanguages = "AppleLanguages"

@objcMembers class KRLaunguageTools: NSObject {

    static let shareInstance = KRLaunguageTools()

    let def = UserDefaults.standard

    var bundle : Bundle?

    //根据语言key获取翻译
    @objc class func getString(key:String) -> String{
        if let dlLan = XUserDefault.getVauleForKey(key: self.getDownloadLanKey()) as? [String : String] {
            if var value = dlLan[key] {
                if value.contains("%s") {
                    value = value.replacingOccurrences(of: "%s", with: "%@")
                }
                return value
            }else {
                return self.getDfString(key: key)
            }
        }else {
            return self.getDfString(key: key)
        }
    }
    
    @objc class func getDfString(key:String) -> String {
        
        let bundle = KRLaunguageTools.shareInstance.bundle

        if let str = bundle?.localizedString(forKey: key, value: nil, table: nil){
            return str
        }
        return ""
    }

    //初始化语言
    func initUserLanguage() {

        var string:String = def.value(forKey: UserLanguage) as! String? ?? ""
        if string == "" {
            let languages = def.object(forKey: AppleLanguages) as? NSArray
            if languages?.count != 0 {
                let current = languages?.object(at: 0) as? String
                if current != nil {
                    string = current!
                    def.set(current, forKey: UserLanguage)
                    def.synchronize()
                }
            }
        }

        if string.range(of: "zh-Hant") != nil{
            string = "zh-Hant"
        } else if string.range(of: "zh-Hans") != nil{
            string = "zh-Hans"
        } else if string.range(of: "ko") != nil{
            string = "ko-KR"
        } else if string.range(of: "ja") != nil{
            string = "ja"
        } else if string.range(of:"vi") != nil{
            string = "vi"
        } else if string.range(of: "en") != nil{
            string = "en"
        } else if string.range(of: "es") != nil{
            string = "es"
        }
        var path = Bundle.main.path(forResource:string , ofType: "lproj")
        
        if path == nil {
            path = Bundle.main.path(forResource:"zh-Hant" , ofType: "lproj")
        }

        bundle = Bundle(path: path!)

    }

    //设置语言
    func setLanguage(langeuage:String) {
        
        if langeuage == "el-GR"{
          if let  path = Bundle.main.path(forResource:"zh-Hant" , ofType: "lproj") {
           
            bundle = Bundle(path: path)
            def.set("zh-Hant", forKey: UserLanguage)
            
            def.synchronize()
            }

        }else if langeuage == "zh-CN"{
            if let  path = Bundle.main.path(forResource:"zh-Hans" , ofType: "lproj") {
                
                bundle = Bundle(path: path)
                def.set("zh-Hans", forKey: UserLanguage)
                
                def.synchronize()
            }
        }
        else if langeuage == "ja-JP"{
            if let  path = Bundle.main.path(forResource:"ja" , ofType: "lproj") {

                bundle = Bundle(path: path)
                def.set("ja-JP", forKey: UserLanguage)

                def.synchronize()
            }
        }
        else if langeuage == "ko-KR"{
            if let  path = Bundle.main.path(forResource:"ko-KR" , ofType: "lproj") {

                bundle = Bundle(path: path)
                def.set("ko-KR", forKey: UserLanguage)

                def.synchronize()
            }
        }
        else if langeuage == "vi-VN"{
            if let  path = Bundle.main.path(forResource:"vi" , ofType: "lproj") {
                
                bundle = Bundle(path: path)
                def.set("vi-VN", forKey: UserLanguage)
                
                def.synchronize()
            }
        }
        
        else if langeuage == "es-ES"{
            if let  path = Bundle.main.path(forResource:"es" , ofType: "lproj") {
                bundle = Bundle(path: path)
                def.set("es-ES", forKey: UserLanguage)
                def.synchronize()
            }
        }
        
        else if langeuage == "en-US"{
            if let  path = Bundle.main.path(forResource:"en" , ofType: "lproj") {
                bundle = Bundle(path: path)
                def.set("en-US", forKey: UserLanguage)
                def.synchronize()
            }
        }
            
        else{
            // 如果有下载的新语言,
            if let dlLan = XUserDefault.getVauleForKey(key:langeuage) as? [String : String],dlLan.count > 0 {
                bundle = nil
                
            } else {
                let path = Bundle.main.path(forResource:"en" , ofType: "lproj")
                bundle = Bundle(path: path!)
            }
            
            def.set(langeuage, forKey: UserLanguage)
            def.synchronize()
        }
       
        self.tryDownloadCurrentLan()
    }
    
    static func getDownloadLanKey() ->String{
        return "dl_\(KRBasicParameter.getPhoneLanguage())"
    }

}

extension KRLaunguageTools{
    static let ch = "zh-cn"//中文
    
    static let ko = "ko-kr"//韩语
    
    static let mn = "mn-mn"//蒙语,废弃
    
    static let en = "en-us"//英语
    
    static let jp = "ja_JP"//日语
    
    static let ru = "ru-ru"//俄语,废弃
    
    static let el = "el-gr"//繁体
    
    static let vi = "vi-vn"//越南
    
    static let es = "es-es" //西班牙语
    
    func localSupportsLans() -> [String] {
        return[KRLaunguageTools.ch,KRLaunguageTools.el,KRLaunguageTools.ko,KRLaunguageTools.en,KRLaunguageTools.jp,KRLaunguageTools.vi,KRLaunguageTools.es]
    }
    
    func serverSupportLans() -> [String] {
        var serversupports:[String] = []
        // 从服务端获取支持的语言
        serversupports.append(KRLaunguageTools.ch)
        return serversupports
    }
    
    func supportLan(_ lankey:String) ->Bool {
        var key = lankey
        key = key.replacingOccurrences(of: "-", with: "_")
        if localSupportsLans().contains(key) {
            return true
        }
        if serverSupportLans().contains(key) {
            return true
        }
        return false
    }
}

extension KRLaunguageTools {
    func tryDownloadCurrentLan() {
        
    }
    
    func readLocalFile() {
        
    }
}
