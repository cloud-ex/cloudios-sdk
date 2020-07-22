//
//  SwapAPIEndPoint.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/7.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Moya

enum SwapAPIEndPoint {
    case instruments
    case indexes
    case riskReserves
    case fundingrate
    case depth
    case kline
    case createAccount
    case tickers
    case accounts
    case userOrders
    case userPositions
    case trades
    case userTrades
    case submitOrder
    case submitPlanOrder
    case cancelOrders
    case cancelPlanOrders
    case transferFunds
    case changeMargin
    case userLiqRecords
    case userPlanOrders
    case orderTrades
}

extension SwapAPIEndPoint : TargetType {
    var baseURL: URL {
        return URL.init(string: NetDefine.swap_host_url)!
    }
    
    var path: String {
        switch self {
        case .instruments:
            return "/swap/instruments"      // 合约配置信息
        case .indexes:
            return "/swap/indexes"          // 合约指数信息
        case .riskReserves:
            return "/swap/riskReserves"     // 保险基金
        case .fundingrate:
            return "/swap/fundingrate"      // 资金费率
        case .depth:
            return "/swap/depth"            // 深度
        case .kline:
            return "/swap/kline"            // K线
        case .createAccount:
            return "/swap/createAccount"    // 开通合约
        case .tickers:
            return "/swap/tickers"          // 合约市场数据
        case .accounts:
            return "/swap/accounts?"        // 合约账户资产
        case .userOrders:
            return "/swap/userOrders?"      // 合约用户订单
        case .userPositions:
            return "/swap/userPositions?"   // 合约用户仓位
        case .trades:
            return "/swap/trades"           // 市场成交列表
        case .userTrades:
            return "/swap/userTrades"       // 用户成交列表
        case .submitOrder:
            return "/swap/submitOrder"      // 提交合约订单
        case .submitPlanOrder:
            return "/swap/submitPlanOrder"  // 提交条件单
        case .cancelOrders:
            return "/swap/cancelOrders"     // 取消合约订单
        case .cancelPlanOrders:
            return "/swap/cancelPlanOrders" // 取消条件单
        case .transferFunds:
            return "/swap/transferFunds"    // 资金划转
        case .changeMargin:
            return "/swap/changeMargin"     // 调整保证金
        case .userLiqRecords:
            return "/swap/userLiqRecords"   // 用户爆仓记录
        case .userPlanOrders:
            return "/swap/userPlanOrders?"  // 条件单列表
        case .orderTrades:
            return "/swap/orderTrades?"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .instruments,.indexes,.tickers:
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        let parameters: [String: Any] = [:]
        switch self {
        case .instruments:
            break
        case .indexes:
            break
        case .riskReserves:
            break
        case .fundingrate:
            break
        case .depth:
            break
        case .kline:
            break
        case .createAccount:
            break
        case .tickers:
            break
        case .accounts:
            break
        case .userOrders:
            break
        case .userPositions:
            break
        case .trades:
            break
        case .userTrades:
            break
        case .submitOrder:
            break
        case .submitPlanOrder:
            break
        case .cancelOrders:
            break
        case .cancelPlanOrders:
            break
        case .transferFunds:
            break
        case .changeMargin:
            break
        case .userLiqRecords:
            break
        case .userPlanOrders:
            break
        case .orderTrades:
            break
        }
        if self.method == .post {
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        } else {
            switch self {
            case .instruments,.indexes,.tickers:
                return .requestParameters(parameters: parameters, encoding:URLEncoding.queryString )
            default:
                return .requestParameters(parameters: parameters, encoding:URLEncoding.httpBody )
            }
        }
    }
    
    var headers: [String : String]? {
        let header = KRNetManager.sharedInstance.getHeaderParams()
        return header
    }
    
    
}
