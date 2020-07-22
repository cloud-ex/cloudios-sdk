//
//  XUserDefault.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class XUserDefault: NSObject {

    //设置并同步
    class func setValueForKey(_ value : Any? , key : String){
        if value == nil || value is NSNull{//容错
            return
        }
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    //获取，如没有返回空字符串
    class func getVauleForKey(key : String) -> Any{
        return UserDefaults.standard.object(forKey: key) ?? ""
    }
    
    //移除
    class func removeKey(key : String){
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }

}

extension XUserDefault {
    //获取当前登录账户
    class func getActiveAccount() -> KRAccountEntity? {
        if PublicInfoManager.sharedInstance.accountEntity.token != "" {
            return PublicInfoManager.sharedInstance.accountEntity
        }
        return nil
    }
    //获取token
    class func getToken()-> String?{
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.token) as? String, str != ""{
            return str
        }
        return nil
    }
    //获取手势密码
    class func getGesturesPassword()-> String? {
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.gesturesPassword) as? String, str != ""{
            return str
        }
        return nil
    }
    
    class func setGesturesPassword(_ password : String) {
        XUserDefault.setValueForKey(password, key: XUserDefault.gesturesPassword)
    }
    
    // 获取faceIdOrTouchId密码
    class func getFaceIdOrTouchIdPassword() -> String?{
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.onFaceIdOrTouchIdPassword) as? String , str != ""{
            return str
        }
        return nil
    }
    // 设置faceIdOrTouchId密码
    class func setFaceIdOrTouchId(_ gpw : String){
        XUserDefault.setValueForKey(gpw, key: XUserDefault.onFaceIdOrTouchIdPassword)
    }
    // 获取登录密码
    class func getUserSignPassword() -> String?{
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.loginPwd) as? String , str != ""{
            // 解密获取
            let gpw = NSString.init(string: str).bt_decryptWithAES()
            return gpw
        }
        return nil
    }
    // 设置登录密码
    class func setUserSignPassword(_ gpw : String){
        // 加密保存
        if gpw != "" {
            let signPwd = NSString.init(string: gpw).bt_encryptWithAES()
            XUserDefault.setValueForKey(signPwd, key: XUserDefault.loginPwd)
        } else {
            XUserDefault.setValueForKey(gpw, key: XUserDefault.loginPwd)
        }
    }
    
    // 获取上次登录账号
    class func getAccountName() -> String?{
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.accountName) as? String , str != ""{
            return str
        }
        return nil
    }
    // 设置当前登录账号
    class func setAccountName(_ name : String){
        XUserDefault.setValueForKey(name, key: XUserDefault.accountName)
    }
    
    // 获取上次选中的合约
    class func getDefaultSwapID() -> Int64 {
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.swapId) as? Int64 , str != 0 {
            return str
        }
        return 0
    }
    // 设置选中的合约id
    class func setDefaultSwapID(_ swapID : Int64){
        XUserDefault.setValueForKey(swapID, key: XUserDefault.swapId)
    }
}

extension XUserDefault {
    
    static let token = "token"//登录token
    
    static let uid = "uid"//uid
    
    static let XUUID = "XUUID"//设备id
    
    static let swapId = "SwapId"//合约id
    
    static let gesturesPassword = "gesturesPassword" // 手势密码
    
    static let onFaceIdOrTouchIdPassword = "faceIdOrTouchIdPassword"//是否开启生物识别

    static let countryCode = "countryCode"//国家编号
    
    static let onGesturesPassword = "onGesturesPassword"//是否开启手势密码
    
    static let onGooglePassword = "onGooglePassword"//是否开启谷歌登录
    
    static let collectionCoinMap = "collectionCoinMap"//收藏的币对
    
    static let collectionCoinMaySymbols = "collectionCoinMaySymbols" //收藏币对symbol
    
    static let accountName = "mobileNumber"//用户账号
    
    static let loginPwd = "loginPwd"//登录密码
    
    static let userInfo = "userInfo"//个人信息
    
    static let publicInfo = "publicInfo"//初始化信息接口
    
    static let loginTime = "loginTime"//登录时间
    
    static let searchArray = "searchArray"//最近查看的币对数组
    
    static let assets = "assets"//是否开启资产
    
    static let hideZeroAssets = "hideZeroAssets"//是否开启资产隐藏0资产
    
    static let updateVersion = "updateVersion"//存储接口版本

    static let swapMode = "swapMode"//合约模式
    
    static let swapComfirmAlert = "swapComfirmAlert"//合约二次确认框
}

extension XUserDefault {
    //设置是否合约二次确认框
    class func setComfirmSwapAlert(_ status : Bool){
        if status == true {
            XUserDefault.setValueForKey("1", key: XUserDefault.swapComfirmAlert)
        } else {
            XUserDefault.setValueForKey("0", key: XUserDefault.swapComfirmAlert)
        }
    }
    
    //获取是否合约二次确认框
    class func getOnComfirmSwapAlert() -> Bool {
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.swapComfirmAlert) as? String {
            if str == "" {
                setComfirmSwapAlert(true)
                return true
            } else if str == "1" {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    // 获取合约模式
    class func getSwapMode() -> String {
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.swapMode) as? String {
            if str == "" {
                setComfirmSwapAlert(true)
                return "0"
            } else if str == "1" {
                return "1"
            } else {
                return "0"
            }
        }
        setSwapMode("0")
        return "0"
    }
    
    // 设置合约模式
    class func setSwapMode(_ mode : String) {
        if mode == "1" {
            XUserDefault.setValueForKey("1", key: XUserDefault.swapMode)
        } else {
            XUserDefault.setValueForKey("0", key: XUserDefault.swapMode)
        }
    }
}
