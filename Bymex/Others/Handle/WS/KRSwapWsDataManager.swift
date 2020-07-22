//
//  KRSwapWsDataManager.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/20.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

enum KRSocketDataType {
    case ticker
    case orderbook
    case trade
    case quoteBin
    case userProperty
}

enum KRLineDataType {
    case KRStockLineDataTypeUnKnow
    case KRStockLineDataTypeTimely  // 分时
    case KRStockLineDataTypeOneMinute   // 1min
    case KRStockLineDataTypeFiveMinutes // 5min
    case KRStockLineDataTypeFifteenMinutes  // 15min
    case KRStockLineDataTypeThirtyMinutes   // 30min
    case KRStockLineDataTypeOneHour     // 1H
    case KRStockLineDataTypeTwoHours    // 2H
    case KRStockLineDataTypeFourHours   // 4H
    case KRStockLineDataTypeSixHours    // 6H
    case KRStockLineDataTypeTwelveHours // 12H
    case KRStockLineDataTypeOneDay      // 1D
    case KRStockLineDataTypeOneWeek     // 1W
    case KRStockLineDataTypeOneMonth    // 30D
}

class KRSwapWsDataManager: NSObject {
    
    public static var sharedInstance : KRSwapWsDataManager {
        struct Static {
            static let instance : KRSwapWsDataManager = KRSwapWsDataManager()
        }
        return Static.instance
    }
    
    //MARK:-处理合约ws数据
    public func ws_dealSwapData(_ wsData: Dictionary<String, Any>) {
        
        guard let group = wsData["group"] as? String, group != "",let action = wsData["action"] as? Int else {
            return
        }
        if group.contains("Ticker") {
            let _ =  dealSwapTickerData(action, wsData)
        } else if group.contains("OrderBook") {
            
        } else if group.contains("Trade") {
            
        } else if group.contains("UserProperty") {
            
        } else if group.contains("QuoteBin") {
            
        }
    }
    
    //MARK:-订阅合约市场Ticker
    public func ws_subscribeSwapTicker(_ instruments : Array<Int>) {
        subscribeDataWithType(.ticker,instruments)
    }
    
    public func ws_unsubscribeSwapTicker(_ instruments : Array<Int>) {
        unSubscribeDataWithType(.ticker,instruments)
    }
    
    //MARK:-订阅合约深度OrderBook
    public func ws_subscribeSwapOrderBook(_ instruments : Array<Int>) {
        subscribeDataWithType(.orderbook,instruments)
    }
    
    public func ws_unsubscribeSwapOrderBook(_ instruments : Array<Int>) {
        unSubscribeDataWithType(.orderbook,instruments)
    }
    
    //MARK:-订阅合约最新成交Trade
    public func ws_subscribeSwapTrade(_ instruments : Array<Int>) {
        subscribeDataWithType(.trade,instruments)
    }
    
    public func ws_unsubscribeSwapTrade(_ instruments : Array<Int>) {
        unSubscribeDataWithType(.trade,instruments)
    }
    
    //MARK:-订阅合约私有资产信息
    public func ws_subscribeUnicast(_ account:KRAccountEntity) {
        if KRWSManager.sharedInstance.hasAuth == true { // 已经认证直接订阅
            subscribeDataWithType(.userProperty)
        } else {
            KRWSManager.sharedInstance.authenticate(account)
        }
    }
    
    //MARK:-订阅数据更新
    public func subscribeDataWithType(_ socketDataType:KRSocketDataType,_ instruments : Array<Int> = []) {
        if socketDataType == .userProperty {
            KRWSManager.sharedInstance.sendDataWithAction("subscribe", ["UserProperty"])
            return
        }
        if instruments.isEmpty == true {
            if socketDataType == .ticker {
                KRWSManager.sharedInstance.sendDataWithAction("subscribe", ["Ticker"])
            }
            return
        }
        let typeStr = p_typeStringFromDataType(socketDataType, .KRStockLineDataTypeUnKnow)
        var args : Array<String> = []
        if typeStr.isEmpty == false {
            for instrument in instruments {
                let red = String(format: "%@:%d",typeStr,instrument)
                args.append(red)
            }
        }
        KRWSManager.sharedInstance.sendDataWithAction("subscribe", args)
    }
    
    public func subscribeDataWithKType(_ instrumentID : Int, _ kLineDataType : KRLineDataType = .KRStockLineDataTypeUnKnow) {
        
    }
    
    //MARK:-取消订阅数据更新
    public func unSubscribeDataWithType(_ socketDataType:KRSocketDataType,_ instruments : Array<Int> = []) {
        var args : Array<String> = []
        let typeStr = p_typeStringFromDataType(socketDataType, .KRStockLineDataTypeUnKnow)
        if typeStr.isEmpty == false {
            for instrument in instruments {
                let red = String(format: "%@:%d",typeStr,instrument)
                args.append(red)
            }
        }
        KRWSManager.sharedInstance.sendDataWithAction("unsubscribe", args)
    }
    
    //MARK:-获取订阅类型
    private func p_typeStringFromDataType(_ socketDataType:KRSocketDataType,_ kLineDataType : KRLineDataType) -> String {
        var typeStr = ""
        switch socketDataType {
        case .ticker:
            typeStr = "Ticker"
        case .orderbook:
            typeStr = "OrderBook500"
        case .trade:
            typeStr = "Trade"
        case .userProperty:
            typeStr = "UserProperty"
        default:
            break
        }
        // K线
        if socketDataType == .quoteBin {
            typeStr = "QuoteBin5m"
            switch kLineDataType {
            case .KRStockLineDataTypeTimely:
                typeStr = "QuoteBin1m"
                case .KRStockLineDataTypeOneMinute:
                typeStr = "QuoteBin1m"
                case .KRStockLineDataTypeFiveMinutes:
                typeStr = "QuoteBin5m"
                case .KRStockLineDataTypeFifteenMinutes:
                typeStr = "QuoteBin15m"
                case .KRStockLineDataTypeThirtyMinutes:
                typeStr = "QuoteBin30m"
                case .KRStockLineDataTypeOneHour:
                typeStr = "QuoteBin1h"
                case .KRStockLineDataTypeTwoHours:
                typeStr = "QuoteBin2h"
                case .KRStockLineDataTypeFourHours:
                typeStr = "QuoteBin4h"
                case .KRStockLineDataTypeSixHours:
                typeStr = "QuoteBin6h"
                case .KRStockLineDataTypeTwelveHours:
                typeStr = "QuoteBin12h"
                case .KRStockLineDataTypeOneDay:
                typeStr = "QuoteBin1d"
                case .KRStockLineDataTypeOneWeek:
                typeStr = "QuoteBin1w"
                case .KRStockLineDataTypeOneMonth:
                typeStr = "QuoteBin30d"
            default:
                break
            }
        }
        return typeStr
    }
}

extension KRSwapWsDataManager {
    private func dealSwapTickerData(_ action: Int, _ wsData: Dictionary<String, Any>) -> BTItemModel? {
        if let group = wsData["group"] as? String,let _ = wsData["data"] as? Dictionary<String, Any>  {
            let groupArr = group.components(separatedBy: ":")
            if groupArr.count == 2, let _ = Int(groupArr[1]) {
                if action == 0 {
                    
                } else if action == 1 {
                    
                } else if action == 2 { // 更新
//                    for entity in KRSwapInfoManager.sharedInstance.allTickerInfoObs {
//                        do {
//                            let temp_entity = try entity.value()
//                            if temp_entity.instrument_id == instrument_id {
//                                temp_entity.setValueOfDict(data)
//                                entity.onNext(temp_entity)
//                            }
//                        } catch {
//
//                        }
//                    }
                } else if action == 4 { // 插入
                    
                } else if action == 5 { // 删除
                    
                }
            }
        }
        return nil
    }
    
    private func dealSwapOrderBookData(_ action: Int, _ wsData: Dictionary<String, Any>) {
        
    }
    
    private func dealSwapTradeData(_ action: Int, _ wsData: Dictionary<String, Any>) {
        
    }
    
    private func dealSwapUserPropertyData(_ wsData: Dictionary<String, Any>) {
        
    }
}
