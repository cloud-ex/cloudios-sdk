//
//  KRLeverageManager.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/29.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

let leverageChangeNotiName = NSNotification.Name.init("leverageChangeNotiName")

// MARK: - KRLeverageModel
/// 合约杠杆倍数--元组
typealias krContractLeverage = (model: KRLeverageModel, leverage: UInt8)
let defaultContractLeverage: krContractLeverage = (KRLeverageModel.staged, 10)
/// 杠杆模式（全仓full，逐仓staged）
enum KRLeverageModel: String {
    case full
    case staged
    
    var btPositionOpenType: BTPositionOpenType {
        get {
            switch self {
            case .full:
                return BTPositionOpenType.allType
            case .staged:
                return BTPositionOpenType.pursueType
            }
        }
    }
    
    var desc: String {
        get {
            switch self {
            case .full:
                return "全仓".localized()
            case .staged:
                return "逐仓".localized()
            }
        }
    }
    
    func desc(_ leverage: UInt8) -> String {
        return "\(self.desc) \(leverage)X"
    }
}

class KRLeverageManager {
    static let shared = KRLeverageManager.init()
    /// 用户合约杠杠倍数限制[uid_instrumentId : item]
    private(set) var leverageLimitInfo: [String : Item] = [ : ]
    private let storeKey = "userContractLeverage"
    private var hasLoadedCache = false
    
    /// 当前用户设置的杠杆
    private(set) var userSelectedLeverage: krContractLeverage = defaultContractLeverage {
        didSet {
            userContractLeverageItem = Item.init(leverage: userSelectedLeverage)
            NotificationCenter.default.performSelector(inBackground: #selector(NotificationCenter.default.post(_:)),
                                                       with: Notification.init(name: leverageChangeNotiName))
        }
    }
    private(set) var userContractLeverageItem = Item.init(leverage: defaultContractLeverage)
    
    struct Item {
        var leverage: krContractLeverage
        
        var key: String {
            return "\(leverage.model.rawValue)-\(leverage.leverage)"
        }
        
        init(leverage: krContractLeverage) {
            self.leverage = leverage
        }
        
        init(dic: [String : Any]) {
            self.leverage = (KRLeverageModel.init(rawValue: dic["model"] as! String)!, dic["leverage"] as! UInt8)
        }
        
        func toDic() -> [String : Any] {
            var dic = [String : Any]()
            dic["model"] = leverage.model.rawValue
            dic["leverage"] = leverage.leverage
            
            return dic
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willTerminateNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
    }
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveUserContractLeverage),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveUserContractLeverage),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    private func toJsonString() -> String? {
        var dic = [String : Any]()

        leverageLimitInfo.forEach { (key: String, value: Item) in
            dic[key] = value.toDic()
        }
        guard dic.count > 0 else { return nil }
        
        if let data = try? JSONSerialization.data(withJSONObject: dic),
            let jsonString = String.init(data: data, encoding: .utf8) {
            return jsonString
        }
        return nil
    }
    @objc private func saveUserContractLeverage() {
        guard leverageLimitInfo.count > 0 else {
            XUserDefault.removeKey(key: storeKey)
            return
        }
        
        if let leverageString = self.toJsonString() {
            XUserDefault.setValueForKey(leverageString, key: storeKey)
        }
    }
    private func loadUserContractLeverage() {
        guard let leverageString = XUserDefault.getVauleForKey(key: storeKey) as? String,
            let data = leverageString.data(using: .utf8),
            let dic = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
            return
        }
        // 处理leverageLimitInfo
        dic.forEach { (key: String, value: Any) in
            leverageLimitInfo[key] = Item.init(dic: value as! [String : Any])
        }
    }
    
    func leverageInfo(uid: String, instrumentId: Int64) -> Item? {
        self.loadUserContractLeverage()
        let key = "\(uid)_\(instrumentId)"
        return leverageLimitInfo[key]
    }
    func updateCurrentUserLeverageInfo(uid: String, instrumentId: Int64, leverage: krContractLeverage) {
        DispatchQueue.global().sync {
            userSelectedLeverage = leverage
            let key = "\(uid)_\(instrumentId)"
            let item = Item.init(leverage: leverage)
            leverageLimitInfo[key] = item
            self.saveUserContractLeverage()
        }
    }
    
    func getleverageInfo(_ instrumentId: Int64) -> KRLeverageStruct {
        guard let account = SLPlatformSDK.sharedInstance()?.activeAccount,instrumentId > 0 else {
            return KRLeverageStruct.init(typeStr: "逐仓", leverage: "10")
        }
        let lev = self.leverageInfo(uid: account.uid ?? idfa, instrumentId: instrumentId)?.leverage.leverage.toString() ?? "10"
        let itemType = (KRLeverageManager.shared.leverageInfo(uid: account.uid ?? idfa, instrumentId: instrumentId)?.leverage.model == .full) ? "全仓".localized() : "逐仓".localized()
        return KRLeverageStruct.init(typeStr: itemType, leverage: lev)
    }
    
    func refreshLeverage(_ instrumentId: Int64) -> String {
        guard instrumentId > 0, SLPlatformSDK.sharedInstance()?.activeAccount != nil else {
            return "逐仓10X"
        }
        let leverageStruct = KRLeverageManager.shared.getleverageInfo(instrumentId)
        let leverageNum = leverageStruct.typeStr + leverageStruct.leverage + "X"
        return leverageNum
    }
    
    // MARK: -- 接口

    /// 获取服务器杠杆
    func getGlobalLeverage(instrumentId: Int64,
                           successCallback: ((_ arr: [SLGlobalLeverageEntity]?) -> Void)? = nil,
                           failureCallback: ((_ err: Any?) -> Void)? = nil) {
        guard let account = XUserDefault.getActiveAccount() else {
            failureCallback?("未登录".localized())
            return
        }
        let success = { [weak self] (result: [SLGlobalLeverageEntity]?) in
            guard let arr = result?.sorted(by: { ($0.updated_at as String) > ($1.updated_at as String) }) else {
                failureCallback?(nil)
                return
            }
            if arr.count > 0,
                let num = arr.first!.config_value.toUInt8(),
                let levModel = arr.first!.position_type.toLeverageModel() {
                //更新数据
                self?.updateCurrentUserLeverageInfo(uid: account.uid,
                                                    instrumentId: instrumentId,
                                                    leverage: (levModel, num))
            }else{
                //更新数据
                self?.updateCurrentUserLeverageInfo(uid: account.uid,
                                                    instrumentId: instrumentId,
                                                    leverage: defaultContractLeverage)
            }
            if arr.count == 0 {
                self?.setGlobalLeverage(instrumentId: instrumentId,
                                        leverage: defaultContractLeverage.leverage,
                                        leverageModel: defaultContractLeverage.model, failureCallback: {_ in})
            }
            successCallback?(arr)
                
        }
        BTContractTool.getGlobalLeverage(instrumentId, success: success) { (err) in
            failureCallback?(err)
        }
    }
    
    func setGlobalLeverage(instrumentId: Int64,
                           leverage: UInt8,
                           leverageModel: KRLeverageModel,
                           successCallback: ((_ arr: [SLGlobalLeverageEntity]?) -> Void)? = nil,
                           failureCallback: ((_ err: Any?) -> Void)? = nil) {
        
        guard let account = XUserDefault.getActiveAccount() else {
            failureCallback?("未登录".localized())
            return
        }
        
        let success = { [weak self] (arr: [SLGlobalLeverageEntity]?) in
            //更新数据
            self?.updateCurrentUserLeverageInfo(uid: account.uid,
                                                instrumentId: instrumentId,
                                                leverage: (leverageModel, leverage))
            successCallback?(arr)
        }
        BTContractTool.setGlobalLeverage(instrumentId, leverage: Int32(leverage), positionType: leverageModel.btPositionOpenType, way: .unkown, success: success) { (error) in
            failureCallback?(error)
        }
    }
}

extension BTPositionOpenType {
    var desc: String? {
        get {
            switch self {
            case .pursueType:
                return "逐仓".localized()
            case .allType:
                return "全仓".localized()
            default:
                return nil
            }
        }
    }
    func toLeverageModel() -> KRLeverageModel? {
        switch self {
        case .pursueType:
            return KRLeverageModel.staged
        case .allType:
            return KRLeverageModel.full
        default:
            return nil
        }
    }
}
