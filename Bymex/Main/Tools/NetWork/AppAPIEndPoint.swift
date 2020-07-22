//
//  AppAPIEndPoint.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/12.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import Moya

enum AppAPIEndPoint {
    case login(loginType: Int,userName:String,password:String,validate:String)
    case register(registerType: Int,userName:String,password:String,code:String,inviter_id:String="")
    case resetPassword(resertType: Int,userName:String,password:String,code:String)
    case verifyPhoneCode(nameType:Int,verifyCodeType:String ,userName:String,validate:String="")
    case bindEmail(email:String,email_code:String,sms_code:String)
    case bindPhone(phone:String,email_code:String,sms_code:String)
    case checkUpdate
    case assetPassword(action:Int,pwd:String, code:String, ga_code:String="")
    case assetPasswordEffectiveTime(password:String,effectiveTime:Int)
    case captchCheck
    case uploadImage
    case accountName(name: String)
    case banners
    case gaKey(action:String,ga_code:String="")
    case usersMe
}

extension AppAPIEndPoint : TargetType {
    var baseURL: URL {
        return URL.init(string: NetDefine.http_host_url)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/ifaccount/login"   // 登录
        case .register:
            return "/ifaccount/users/register"  // 注册
        case .resetPassword:
            return "/ifaccount/users/resetPassword" // 重置密码
        case .bindEmail:
            return "/ifaccount/bindEmail"   // 绑定邮箱
        case .bindPhone:
            return "/ifaccount/bindPhone"   // 绑定手机号
        case .verifyPhoneCode: // 发送验证码
            return "/ifaccount/verifyCode"
        case .checkUpdate:
            return "/ifglobal/checkUpdate"    // 获取最新版本信息
        case .assetPassword:
            return "/ifaccount/assetPassword"   // 资金密码操作
        case .captchCheck:
            return "/ifaccount/captchCheck" // 检查是否需要图片验证码
        case .uploadImage:
            return "/ifaccount/upload?type=image"   // 上传图片
        case .accountName:
            return "/ifaccount/user/accountName"   // 设置昵称
        case .banners:
            return "/ifglobal/banners" //获取banner轮播图
        case .gaKey:
            return "/ifaccount/GAKey" // 谷歌验证码
        case .usersMe:
            return "/ifaccount/users/me"  // 账户资产信息
        case .assetPasswordEffectiveTime:
            return "/ifaccount/assetPasswordEffectiveTime" // 资金密码有效时长
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .banners,.usersMe:
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parameters: [String: Any] = [:]
        switch self {
        case .login(let loginType,let userName, let password,let validate):
            if loginType == 1 {// 手机
                if userName.contains(" ") == true {
                    parameters["phone"] = userName
                } else {
                    parameters["phone"] = "+86 " + userName
                }
            } else if loginType == 2 { //邮箱
                parameters["email"] = userName
            }
            let nonce = CLongLong(KRBasicParameter.getNonce16())
            parameters["password"] = KRMD5.getmd5(String(format: "%@%lld",KRMD5.getmd5(password),nonce!))
            parameters["nonce"] = nonce
            parameters["validate"] = validate
            break
        case .register(let registerType, let userName,let password, let code, _):
            if registerType == 1 {// 手机注册
                parameters["phone"] = userName
            } else if registerType == 2 { //邮箱注册
                parameters["email"] = userName
            }
            parameters["password"] = KRMD5.getmd5(password)
            parameters["code"] = code
            parameters["nonce"] = KRBasicParameter.getNonce13()
            parameters["inviter_id"] = 0
            break
        case .resetPassword(let resertType,let userName,let password,let code):
            if resertType == 1 {// 手机注册
                parameters["phone"] = "+86 " + userName
            } else if resertType == 2 { //邮箱注册
                parameters["email"] = userName
            }
            parameters["password"] = KRMD5.getmd5(password)
            parameters["code"] = code
            break
        case .bindEmail(let email,let email_code,let sms_code):
            parameters["email"] = email
            parameters["email_code"] = email_code
            parameters["sms_code"] = sms_code
        case .bindPhone(let phone,let email_code,let sms_code):
            parameters["phone"] = phone
            parameters["email_code"] = email_code
            parameters["sms_code"] = sms_code
        case .verifyPhoneCode(let nameType,let verifyCodeType,let name, let validate):
            if nameType == 1 {
                parameters["phone"] = name
            } else if nameType == 2 {
                parameters["email"] = name
            }
            parameters["type"] = verifyCodeType
            return .requestCompositeParameters(bodyParameters: ["validate": validate], bodyEncoding: JSONEncoding.default, urlParameters: parameters)
        case .checkUpdate:
            break
        case .assetPassword(let action, let password, let code,let ga_code):
            var actionType = ""
            if action == 1 { // 添加
                actionType = "add"
            } else if action == 2 { // 重置
                actionType = "reset"
                parameters["sms_code"] = code
                parameters["ga_code"] = Int32(ga_code)
            }
            parameters["asset_password"] = KRMD5.getmd5(password)
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.default, urlParameters: ["action":actionType])
        case .assetPasswordEffectiveTime(let password, let effectiveTime):
            parameters["asset_password"] = KRMD5.getmd5(password)
            parameters["asset_password_effective_time"] = effectiveTime
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.default, urlParameters: ["action":"reset"])
        case .captchCheck:
            break
        case .uploadImage:
            break
        case .accountName(let name):
            parameters["account_name"] = name
            break
        case .banners:
            parameters["platform"] = 2
            parameters["language"] = KRBasicParameter.getPhoneLanguage()
            break
        case .gaKey(let action , let ga_code):
            if ga_code.count > 0 {
                parameters["ga_code"] = Int64(ga_code)
            }
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.default, urlParameters: ["action": action])
        case .usersMe:
            break
        }
        if self.method == .post {
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        } else {
            switch self {
            case .banners,.usersMe:
                return .requestParameters(parameters: parameters, encoding:URLEncoding.queryString)
            default:
                return .requestParameters(parameters: parameters, encoding:URLEncoding.httpBody )
            }
        }
    }
    
    var headers: [String : String]? {
        let header = KRNetManager.sharedInstance.getHeaderParams()
        return header
    }
        
    func getRegularURL(_ url : String) -> String {
        return url.wk_URLEncodedString3()
    }
    
}
