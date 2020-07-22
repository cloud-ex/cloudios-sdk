//
//  SettlesAPIPoint.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import Moya

enum SettlesAPIPoint {
    case settles(type:String,coin:String,offset:Int,limit:Int) // 获取所有记录
    case depositAddress(coin:String) // 获取充值地址
    case rechargeAmount(coin_code:String,address:String,amount:String="0") // 充值通知
    case withdraw(password:String, addressType:Int,to_address:String,coin_code:String,vol:String, verifyType: Int, code:String,ga_code:String,memo:String="") // 提现请求
    case withdrawAddresses(action:String,coin_code:String,address:String,remark:String,addressType:Int) // 提现地址管理
}

extension SettlesAPIPoint : TargetType {
    var baseURL: URL {
        return URL.init(string: NetDefine.http_host_url)!
    }
    
    var path: String {
        switch self {
        case .settles:
            return "/ifaccount/settles"
        case .depositAddress:
            return "/ifaccount/address"
        case .rechargeAmount:
            return "/ifaccount/rechargeAmount"
        case .withdraw:
            return "/ifaccount/withdraw"
        case .withdrawAddresses:
            return "/ifaccount/withdrawAddress"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .depositAddress,.settles:
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
        case .settles(let type, let coin, let offset, let limit):
            parameters["type"] = type
            parameters["coin"] = coin
            parameters["offset"] = String(offset)
            parameters["limit"] = String(limit)
            return .requestCompositeParameters(bodyParameters: [:], bodyEncoding: URLEncoding.httpBody, urlParameters: parameters)
        case .depositAddress(let coin):
            parameters["coin"] = coin
            return .requestCompositeParameters(bodyParameters: [:], bodyEncoding: URLEncoding.httpBody, urlParameters: parameters)
        case .rechargeAmount(let coin_code, let address, let amount):
            parameters["coin_code"] = coin_code
            parameters["address"] = address
            parameters["amount"] = amount
            let nonce = CLongLong(KRBasicParameter.getNonce13())
            parameters["nonce"] = nonce
        case .withdraw(_, let addressType, let to_address, let coin_code, let vol, let verifyType, let code, let ga_code, let memo):
            parameters["type"] = addressType
            parameters["to_address"] = to_address
            parameters["coin_code"] = coin_code
            parameters["vol"] = vol
            parameters["nonce"] = KRBasicParameter.getNonce13()
            if verifyType == 1 { // 手机验证
                parameters["sms_code"] = code
            } else if verifyType == 2 {
                parameters["email_code"] = code
            }
            if PublicInfoManager.sharedInstance.accountEntity.ga_key != "unbound" {
                parameters["ga_code"] = ga_code
            }
            if memo.count > 0 {
                parameters["memo"] = memo
            }
        case .withdrawAddresses(let action, let coin_code, let address, let remark, let addressType):
            parameters["coin_code"] = coin_code
            parameters["address"] = address
            parameters["remark"] = remark
            parameters["type"] = addressType
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.default, urlParameters: ["action":action])
        }
        if self.method == .post {
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        } else {
            switch self {
            case .depositAddress,.settles:
                return .requestParameters(parameters: parameters, encoding:URLEncoding.queryString)
            default:
                return .requestParameters(parameters: parameters, encoding:URLEncoding.httpBody )
            }
        }
    }
    
    var headers: [String : String]? {
        let header = KRNetManager.sharedInstance.getHeaderParams()
        switch self {
        case .withdraw(let password, _, _, _, _, _, _, _, _):
            let pwd = KRMD5.getmd5(password)
            return KRNetManager.sharedInstance.getHeaderParams(pwd)
        default:
            break
        }
        return header
    }
    
    
}
