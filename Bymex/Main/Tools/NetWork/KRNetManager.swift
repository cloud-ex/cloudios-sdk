//
//  KRNetManager.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import Alamofire

//网络请求状态
public enum NetRequestResultState : String {
    case Success = "Success"//请求正确 例如200
    case NetFailure  = "NetFailure"   //网络失败 例如 连接超时 没有网络
    case ServerFailure = "ServerFailure" // 服务器失败 例如404 500
    case SendRequestFailure = "SendRequestFailure" // 发起请求失败 将要请求失败
}

public class KRNetManager: NSObject {
    
    //MARK:地址拼接
    public func url(_ host : String,model : String , action : String) -> String{
        return host + model + action
    }
    
    var managerArray = NSMutableArray.init()
    
    var header : String = "ex"
    
    /// MARK: 单例
    @objc public static var sharedInstance : KRNetManager {
        struct Static {
            static let instance : KRNetManager = KRNetManager()
        }
        return Static.instance
    }
    
    // MARK:获取header的参数
    @objc public func getHeaderParams(_ password:String="") -> [String : String] {
        var headParam : [String : String] = [:]
        let deviceId = KRBasicParameter.getUUID()//uid
//        let deviceVersion = KRBasicParameter.getDeviceVersion()     // 设备version
        let deviceModel_CU = KRBasicParameter.getPhoneModel()       // 设备型号
        let devicePhoneOS = KRBasicParameter.getPhoneOS()           // 版本型号
        let deviceLanguage = KRBasicParameter.getPhoneLanguage()    // 语言
        let deviceNetwork = KRBasicParameter.getNetStatus()         // 网络状态
        let app_Version = KRBasicParameter.getAppVersion()          // app version

        
        headParam[header + "-ver"] = app_Version
        headParam[header + "-idfa"] = deviceId
        headParam[header + "-connection-type"] = deviceNetwork
        headParam[header + "-language"] = deviceLanguage
        headParam[header + "-model"] = deviceModel_CU
        headParam[header + "-dev"] = "iOS"
        headParam[header + "-platform"] = devicePhoneOS
        
        if let token = XUserDefault.getToken(),let activeEntity = XUserDefault.getActiveAccount() {
            let nonce = KRBasicParameter.getNonce16()
            let sign = NSString.init(string: token).aes256_encrypt(NetDefine.PRIVATE_KEY, nonce: nonce)
            headParam[header + "-Sign"] = sign
            headParam[header + "-ts"] = nonce
            if activeEntity.uid != "" {
                headParam[header + "-uid"] = activeEntity.uid
            }
            if activeEntity.ssid != "" {
                headParam[header + "-ssid"] = activeEntity.ssid
            }
            if password.count > 0 {
                headParam[header + "-assetPassword"] = password
            }
        } else {
            headParam[header + "-ts"] = KRBasicParameter.getNonce16()
        }
        return headParam
    }
}

