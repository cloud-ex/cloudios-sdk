//
//  KRCustomObjMapper.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
//import Result
import Moya
import MJExtension

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func MJObjectMap<T>(_ type: T.Type,_ handleErr:Bool = true) -> Single<T> {
        return flatMap { response in
            #if DEBUG
            print("=======================================\n")
            print("请求：",response.request?.url ?? "None")
            let body = response.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
            print("参数：",body)
            print("\n=======================================")
            #endif
            if handleErr == true{
                if let code = response.response?.statusCode{
                    switch code{
                    case NSURLErrorTimedOut , 408:
                        EXAlert.showFail(msg: KRLaunguageTools.getString(key: "common_tip_networkTimeout"))
                        throw CustomNetworkError.ParseJSONError
                    case 403:
                        EXAlert.showFail(msg: KRLaunguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                        throw CustomNetworkError.ParseJSONError
                    case 404:
                        EXAlert.showFail(msg: KRLaunguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                        throw CustomNetworkError.ParseJSONError
                    case NSURLErrorCannotConnectToHost , NSURLErrorNetworkConnectionLost , NSURLErrorNotConnectedToInternet:
                        EXAlert.showFail(msg: KRLaunguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                        throw CustomNetworkError.ParseJSONError
                    default:
                        if let code = response.response?.statusCode , code >= 500 ,code < 600{
                            EXAlert.showFail(msg: KRLaunguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                            throw CustomNetworkError.ParseJSONError
                        }
                    }
                }
            }
            guard let json = try response.mapJSON() as? [String: Any] else {
                throw CustomNetworkError.ParseJSONError
            }
            #if DEBUG
            print("response：%@",(json as NSDictionary).mj_JSONString()!)
            print("\n=======================================")
            #endif
            
            var strCode:String = "200"// 默认成功
            if let code = json["errno"] as? String {
                strCode = code
            }else if let code = json["errno"] as? Int {
                strCode = "\(code)"
            }else {
                throw CustomNetworkError.ParseJSONError
            }
            
            if strCode == "OK" {
                guard let data = json["data"] else {
                    if let message = json["message"] as? String, message == "Success" {
                        let obj = (type as! NSObject.Type).mj_object(withKeyValues:json) as! T
                        return Single.just(obj)
                    }
                    throw  CustomNetworkError.ParseJSONError
                }
                if let result = data as? [[String: Any]] {
                    //这个用CommonAryModel.self 接.
                    let obj = (type as! NSObject.Type).mj_object(withKeyValues:["data":result]) as! T
                    return Single.just(obj)
                }
                else if let result = data as? [String: Any] {
                    let obj = (type as! NSObject.Type).mj_object(withKeyValues: result) as! T
                    if let account = obj as? KRAccountEntity {
                        if let time = result["asset_password_effective_time"] as? Int {
                            account.asset_password_effective_time = AssetPasswordEffectiveTimeType(rawValue: time)!
                        }
                        guard let allHeadder = response.response?.allHeaderFields else { return Single.just(obj) }
                        if let token = allHeadder["ex-token"] as? String {
                            account.token = token
                        }
                        if let uid = allHeadder["ex-uid"] as? String {
                            account.uid = uid
                        }
                        return Single.just(account as! T)
                    }
                    return Single.just(obj)
                }
                // 其他情况处理
                else if let result = data as? String {
                    //这个用CommonStringModel接.
                    let obj = (type as! NSObject.Type).mj_object(withKeyValues:["message":result]) as! T
                    return Single.just(obj)
                }
                //有些服务端返回0,data为null
                else if let _ = data as? NSNull {
                    //这个用CommonStringModel接.
                    let obj = (type as! NSObject.Type).mj_object(withKeyValues:["message":""]) as! T
                    return Single.just(obj)
                }else {
                    //还有返回int/double,全都当他是成功的
                    let obj = (type as! NSObject.Type).mj_object(withKeyValues:["message":""]) as! T
                    return Single.just(obj)
                }
            } else {
                if strCode == "FORBBIDEN"  { // 返回禁止，token失效
                    XUserDefault.removeKey(key: XUserDefault.token)
                    throw CustomNetworkError.ExpireTokenError
                } else {
                    if let msg = json["message"] as? String {
                        if msg.count > 0 {
                            EXAlert.showFail(msg: msg)
                        }
                        throw CustomNetworkError.ParseJSONError
                    }else {
                        throw CustomNetworkError.ParseJSONError
                    }
                }
            }
        }
    }
}

enum CustomNetworkError: String {
    case ParseJSONError = "Network Error"//解析错误
    case ExpireTokenError = "ExpireTokenError"//token
}

extension CustomNetworkError: Swift.Error {
    
}
