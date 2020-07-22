//
//  KRSwapKLineVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/20.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
/// k 线数据
class KRSwapKLineVM: NSObject {
    
    var reciveKLineSocketData: (([KRChartItem]) -> ())?
    
    var lineDataDict : [String : [BTItemModel]] = [:]
    
    /// 当前 k 线数据对应的类型
    var currentKLineDataType: SLFrequencyType = .FREQUENCY_TYPE_15M
    
    private var currentInstrumentID: Int64 = 0
    
    private var lastestTimestamp = NSNumber(value: 0)
    
    override init() {
        super.init()
        self.addKLineSocketNotify()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.unsubscribeKLineScoketData(contract_id: self.currentInstrumentID)
    }
    
    /// 请求 k 线数据
    /// - Parameters:
    ///   - timeType: 时间刻度
    ///   - contract_id: 合约 ID
    ///   - complete: 回调
    func requestKLineData(timeType: KRKLineTimeType, contract_id: Int64, complete: @escaping ([KRChartItem]?) -> Void) {
        if let kLineDataType = self.convertTimeType(timeType) {
            self.requestKLineData(kLineDataType: kLineDataType, contract_id: contract_id, complete: complete)
        } else {
            complete(nil)
        }
    }
    
    /// 请求 k 线数据
    func requestKLineData(kLineDataType: SLFrequencyType, contract_id: Int64, complete: @escaping ([KRChartItem]?) -> Void) {
        let handleKLineData: (([BTItemModel]?) -> Void) = {[weak self] itemModelArray in
            guard let mySelf = self else { return}
            guard let _itemModelArray = itemModelArray else {
                complete(nil)
                return
            }
            var itemArr: [KRChartItem] = []
            for model in _itemModelArray {
                let item = KRChartItem()
                item.time = Int(model.timestamp.int32Value)
                
                item.openPrice = CGFloat(KRBasicParameter.handleDouble(model.open ?? "0"))
                item.highPrice = CGFloat(KRBasicParameter.handleDouble(model.high ?? "0"))
                item.lowPrice = CGFloat(KRBasicParameter.handleDouble(model.low ?? "0"))
                item.closePrice = CGFloat(KRBasicParameter.handleDouble(model.close ?? "0"))
                item.vol = CGFloat(KRBasicParameter.handleDouble(model.last_qty ?? "0"))
                itemArr.append(item)
            }
            // 记录最新的数据时间
            mySelf.lastestTimestamp = _itemModelArray.first?.timestamp ?? NSNumber(value: 0)
            complete(itemArr)
        }
        BTDrawLineManager.share()?.loadData(withCoin: "", contractID: contract_id, type: .LINE_TYPE_FUTURES, frequencyType: kLineDataType, previewDataBlock: { (itemModelArray) in
            handleKLineData(itemModelArray)
        }, middleDataBlock: { (itemModelArray) in
            
        }, fullDataBlock: { (itemModelArray) in
            handleKLineData(itemModelArray)
        }, failure: { (error) in
            complete(nil)
        })
    }
    
    
    private func convertTimeType(_ timeType: KRKLineTimeType) -> SLFrequencyType? {
        var kLineDataType: SLFrequencyType? = nil
        switch timeType {
        case .k_timeline:
                kLineDataType = .FREQUENCY_TYPE_M
        case .k_1min:
                kLineDataType = .FREQUENCY_TYPE_1M
        case .k_5min:
                kLineDataType = .FREQUENCY_TYPE_5M
        case .k_15min:
                kLineDataType = .FREQUENCY_TYPE_15M
        case .k_30min:
                kLineDataType = .FREQUENCY_TYPE_30M
        case .k_1hour:
                kLineDataType = .FREQUENCY_TYPE_1H
        case .k_4hour:
                kLineDataType = .FREQUENCY_TYPE_4H
        case .k_1day:
                kLineDataType = .FREQUENCY_TYPE_1D
        case .k_1week:
                kLineDataType = .FREQUENCY_TYPE_1W
        case .k_1mon:
                kLineDataType = .FREQUENCY_TYPE_1MO
        }
        return kLineDataType
    }
    
    // MARK: - Socket
    func addKLineSocketNotify() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKLineScoketData), name: NSNotification.Name(rawValue: SLSocketDataUpdate_QuoteBin_Notification), object: nil)
    }
    
    func subscribKLineSocketData(contract_id: Int64, timeType: KRKLineTimeType) {
        if let kLineDataType = self.convertTimeType(timeType) {
            self.currentKLineDataType = kLineDataType
            self.currentInstrumentID = contract_id
            SLSocketDataManager.sharedInstance().sl_subscribeQuoteBinData(withContractID: contract_id, stockLineDataType: kLineDataType)
        }
    }
    
    func unsubscribeKLineScoketData(contract_id: Int64) {
        SLSocketDataManager.sharedInstance().sl_unsubscribeQuoteBinData(withContractID: contract_id, stockLineDataType: self.currentKLineDataType)
    }
    
    @objc func handleKLineScoketData(notify: NSNotification) {
        guard let userInfo = notify.userInfo else {
            return
        }
        guard let itemModelArray = userInfo["data"] as? Array<BTItemModel> else {
            return
        }
        guard let kLineType = userInfo["kLineDataType"] as? NSNumber else {
            return
        }
        let kLineDataType = kLineType.intValue
        
        // 分时 和 1 分钟 返回的都是 SLStockLineDataTypeOneMinute
        if (kLineDataType != self.currentKLineDataType.rawValue) {
            if (kLineDataType == SLFrequencyType.FREQUENCY_TYPE_M.rawValue && self.currentKLineDataType == SLFrequencyType.FREQUENCY_TYPE_M) {
                
            } else {
                return
            }
        }
        
        var itemArr: [KRChartItem] = []
        for model in itemModelArray {
            if (model.timestamp.int64Value >= self.lastestTimestamp.int64Value) {
                let item = KRChartItem()
                item.time = Int(model.timestamp.int32Value)
                item.openPrice = CGFloat(KRBasicParameter.handleDouble(model.open ?? "0"))
                item.highPrice = CGFloat(KRBasicParameter.handleDouble(model.high ?? "0"))
                item.lowPrice = CGFloat(KRBasicParameter.handleDouble(model.low ?? "0"))
                item.closePrice = CGFloat(KRBasicParameter.handleDouble(model.close ?? "0"))
                item.vol = CGFloat(KRBasicParameter.handleDouble(model.last_qty ?? "0"))
                itemArr.append(item)
            }
        }
        self.reciveKLineSocketData?(itemArr)
    }
}
