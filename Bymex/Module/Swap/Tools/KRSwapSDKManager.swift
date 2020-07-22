//
//  KRSwapSDKManager.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/19.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

let MARKET_TICKER_LOADED_NOTI = "MARKET_TICKER_LOADED_NOTI"

enum InitialSLContractSDKStatus: Int {
    case unInitial = 0
    case initing
    case success
    case failed
}

protocol KRSwapSDKProtocol {
    func refreshOrderBook()
}

class KRSwapSDKManager {
    
    /// 初始化SDK状态
    private(set) var initialSLContractSDKStatus = InitialSLContractSDKStatus.unInitial
    let reachability = Reachability.forInternetConnection()
    var reloadSwapSDKTime = 0.0
    
    // 所有的市场Ticker
    var allTickerInfoObs : [BehaviorSubject<BTItemModel>] = []
    // USDT Ticker
    var usdtTickerObs : [BehaviorSubject<BTItemModel>] = []
    // 币本位 Ticker
    var currencyTickerObs : [BehaviorSubject<BTItemModel>] = []
    // 模拟 Ticker
    var simulateTickerObs : [BehaviorSubject<BTItemModel>] = []
    
    lazy var currentBS: BehaviorSubject<BTItemModel> = BehaviorSubject(value: BTItemModel())
    
    // 接收最新的资产数据
    lazy var propertySub : PublishSubject<[BTWebSocketModel]> = PublishSubject<[BTWebSocketModel]>()
    
    var online_swap_guide = ""   // 合约指南
    var online_swap_ADL = ""     // 自动减仓
    var online_swap_Close = ""   // 强制平仓
    
    static let shared = KRSwapSDKManager()
    
    func configSLContractSDK() {
        #if DEBUG
        SLSDK.setLogEnable(true)
        #else
        SLSDK.setLogEnable(false)
        #endif
        /// 初始化合约语言
        BTLanguageTool.sharedInstance()?.setCurrentLaunguage(CNS)
        /// 初始化合约通知
        initNotification()
        /// 初始化合约SDK
        reLoadSwapSDK()
    }
    
    func initNotification() {
        // 合约SDK初始化成功
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(swapInfoReloaded),
                                               name: NSNotification.Name(rawValue: BTLoadContractsInfo_Notification),
                                               object: nil)
        // 当websocket链接成功
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contractWebSocketDidOpenNotification),
                                               name: NSNotification.Name(rawValue: ContractWebSocketDidOpenNote),
                                               object: nil)
        // 监听登录成功
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(swapSDKLoadPlatForm),
                                               name: NSNotification.Name(rawValue: KRLoginStatus),
                                               object: nil)
        // 添加退出登录通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshLogout),
                                               name: NSNotification.Name(rawValue: SLToken_Lose_effectiveness_Notification),
                                               object: nil)
        // 监听网络状态发生改变
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged),
                                               name: NSNotification.Name(rawValue: "kRNetworkReachabilityChangedNotification"),
                                               object: reachability)
        // 监听市场行情刷新
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(wsSwapTicker),
                                               name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Ticker_Notification),
                                               object: nil)
    }
    
    func reLoadSwapSDK() {
        
        switch initialSLContractSDKStatus {
        case .unInitial,.failed:
            print("=== 初始化Swap SDK ===")
        case .initing:
            return
        case .success:
            return
        }
        initialSLContractSDKStatus = .initing
        SLSDK.sharedInstance()?.sl_start(withAppID: "Bymex", launchOption: getSDKParames(), callBack: { [weak self] (result, error) in
            if error != nil { // 初始化失败
                self?.initialSLContractSDKStatus = .unInitial
                if ((self?.reloadSwapSDKTime ?? 129 ) > 128) {
                    // 您的网络状况不是很好，请检查网络后重试
                    self?.initialSLContractSDKStatus = .failed
                    return;
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (self?.reloadSwapSDKTime ?? 0)) {
                    if SLPublicSwapInfo.sharedInstance()?.hasSwapInfo == false {
                        self?.reLoadSwapSDK()
                    }
                }
                // 重新初始化时间2的指数级增长
                if (self?.reloadSwapSDKTime == 0) {
                    self?.reloadSwapSDKTime = 2;
                } else {
                    self?.reloadSwapSDKTime *= 2;
                }
                return
            }
            self?.initialSLContractSDKStatus = .success
        })
    }
    
    func krWebSocketClose() {
        SLContractSocketManager.shared().srWebSocketClose()
    }
    
    func krWebSocketConnect() {
        SLContractSocketManager.shared().srWebSocketOpen(withURLString: NetDefine.swap_wss_url)
        krGetAllPosition()
    }
    
    func krGetAllPosition(_ handlePositions: (([BTPositionModel]) -> ())?=nil) {
        BTContractTool.getUserPositionWithcoinCode(nil, contractID: 0, status: .holdSystem, offset: 0, size: 0, success: { (positions) in
            handlePositions?(positions ?? [])
        }) { (error) in
            print(error as Any)
            handlePositions?([])
        }
    }
}

//MARK:- 通知事件
extension KRSwapSDKManager {
    /// SDK初始化配置成功
    @objc func swapInfoReloaded(notification: NSNotification) {
        /// 获取合约列表
        SLSDK.sl_loadFutureMarketData {[weak self] (result, error) in
            if result != nil {
                self?.createObs()
                if SLContractSocketManager.shared().isConnected == false {
                    SLContractSocketManager.shared().srWebSocketOpen(withURLString: NetDefine.swap_wss_url)
                }
                self?.swapSDKLoadPlatForm()
            }
        }
    }
    
    @objc func swapSDKLoadPlatForm() {
        if let activeEntity = XUserDefault.getActiveAccount() {
            let account = BTAccount()
            account.token = activeEntity.token
            account.uid = activeEntity.uid
            account.access_key = ""
            account.expiredTs = ""
            SLPlatformSDK.sharedInstance()?.sl_start(withAccountInfo: account)
            // 登录成功后监听私有信息
            SLSocketDataManager.sharedInstance().sl_subscribeContractUnicastData()
        }
    }
    
    /// ws链接成功
    @objc func contractWebSocketDidOpenNotification(notification: NSNotification) {
        // 订阅 ticker ,订阅深度 如果登录之后订阅资产
        let tickerArr = SLPublicSwapInfo.sharedInstance()?.getTickersWithArea(.CONTRACT_BLOCK_UNKOWN) ?? []
        var symbolArr : [NSNumber] = []
        for itemModel in tickerArr {
            symbolArr.append(NSNumber.init(value: itemModel.instrument_id))
        }
        // 订阅Ticker
        SLSocketDataManager.sharedInstance().sl_subscribeContractTickerData(symbolArr)
        // 订阅深度
        do {
            let temp_entity = try currentBS.value()
            if temp_entity.instrument_id > 0 {
                SLSocketDataManager.sharedInstance().sl_subscribeContractDepthData(withInstrument: temp_entity.instrument_id)
            }
        } catch {
        }
        // 如果登录
        if XUserDefault.getToken() != nil, SLPlatformSDK.sharedInstance()?.activeAccount != nil { // 如果已经登录订阅私有资产信息
            SLSocketDataManager.sharedInstance().sl_subscribeContractUnicastData()
        }
    }
    
    @objc func refreshLogout() {
        SLPlatformSDK.sharedInstance()?.sl_logout()
        // 退出登录后取消订阅私有信息(注意ws不能断)
        SLSocketDataManager.sharedInstance().sl_unSubscribeContractUnicastData()
    }
    
    @objc func reachabilityChanged(notification: NSNotification) {
        if let reachability = notification.object as? Reachability {
            if reachability.currentReachabilityStatus().rawValue != 0 && (initialSLContractSDKStatus == .unInitial && initialSLContractSDKStatus == .failed) {
                reLoadSwapSDK()
            }
        }
    }
    
    @objc func wsSwapTicker(notification: NSNotification) {
        guard let data = notification.userInfo?["data"] as? BTItemModel else { return}
        for entity in self.allTickerInfoObs {
            do {
                var temp_entity = try entity.value()
                if temp_entity.instrument_id == data.instrument_id {
                    temp_entity = data
                    entity.onNext(temp_entity)
                    break
                }
            } catch {
                
            }
        }
    }
}

//MARK:- handle data
extension KRSwapSDKManager {
    
    static func krShowOpenSwapAlert(_ itemModel : BTItemModel?) {
        guard let instrument_id = itemModel?.instrument_id, let coin_code = itemModel?.contractInfo?.margin_coin else {
            return
        }
        if SLPlatformSDK.sharedInstance()!.sl_determineWhetherToOpenContract(withCoinCode: coin_code) == false {
            let sheet = KRSwapOpenSheet()
            sheet.clickSubmitBtnBlock = {
                BTContractTool.createContractAccount(withContractID: instrument_id, success: { (result) in
                    EXAlert.dismissEnd {
                        EXAlert.showSuccess(msg: "开通成功".localized())
                        SLPlatformSDK.sharedInstance().sl_loadUserContractPerpoty()
                    }
                }) { (error) in
                    EXAlert.dismissEnd {
                        if let errMsg = error as? String {
                            EXAlert.showFail(msg: errMsg)
                        } else {
                            EXAlert.showFail(msg: "数据错误，请稍后再试...")
                        }
                    }
                }
            }
            EXAlert.showSheet(sheetView: sheet)
        }
    }
    
    func getSDKParames() -> SLPrivateConfig {
        let config = SLPrivateConfig.shared()
        config!.base_host = NetDefine.swap_host_url
        config!.private_KEY = "OZ1WNXAlbe84Kpq8"
        config!.host_Header = "ex"
        return config!
    }
    
    func createObs() {
        let allTicker = SLPublicSwapInfo.sharedInstance()?.getTickersWithArea(.CONTRACT_BLOCK_UNKOWN) ?? []
        var default_id = XUserDefault.getDefaultSwapID()
        if default_id == 0 {
            guard let item = allTicker.first else {
                return
            }
            default_id = item.instrument_id
            XUserDefault.setDefaultSwapID(item.instrument_id)
        }
        self.allTickerInfoObs = allTicker.map { (ticker) -> BehaviorSubject<BTItemModel> in
            let ob = BehaviorSubject(value: ticker)
            if ticker.contractInfo.area == .CONTRACT_BLOCK_USDT {
                usdtTickerObs.append(ob)
            } else if ticker.contractInfo.area == .CONTRACT_BLOCK_STAND ||
                ticker.contractInfo.area == .CONTRACT_BLOCK_INVERSE {
                currencyTickerObs.append(ob)
            } else if ticker.contractInfo.area == .CONTRACT_BLOCK_SIMULATION {
                simulateTickerObs.append(ob)
            }
            if ticker.instrument_id == default_id {
                currentBS = ob
            }
            return ob
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(MARKET_TICKER_LOADED_NOTI),object: nil)
    }
    
    // 应用设置页面
    func getSwapSettingPage() -> [KRSettingSecEntity] {
        var setpage : [KRSettingSecEntity] = []
        
        let baseSet = KRSettingSecEntity()
        let unitEntity = KRSettingVEntity()
        unitEntity.name = "合约展示单位".localized()
        unitEntity.defaule = BTStoreData.storeBool(forKey: BT_UNIT_VOL) == true ? "币".localized() : "张".localized()
        unitEntity.cellType = .defaultTC
        
        let unrealityEntity = KRSettingVEntity()
        unrealityEntity.name = "未实现盈亏计算".localized()
        unrealityEntity.defaule = (BTStoreData.storeObject(forKey: ST_UNREA_CARCUL) as? Int ?? 0 == 0) ? "最新价".localized() : "合理价".localized()
        unrealityEntity.cellType = .defaultTC
        
        let doubleComfirmEntity = KRSettingVEntity()
        doubleComfirmEntity.name = "二次下单确认".localized()
        doubleComfirmEntity.switchType = XUserDefault.getOnComfirmSwapAlert() == true ? "1" : "0"
        doubleComfirmEntity.cellType = .switchTC
        
        let planCycleEntity = KRSettingVEntity()
        planCycleEntity.name = "条件单有效时长".localized()
        planCycleEntity.defaule = (BTStoreData.storeObject(forKey: ST_DATE_CYCLE) as? Int ?? 0 == 0) ? "24小时".localized() : "7天".localized()
        planCycleEntity.cellType = .defaultTC
        
        baseSet.contents = [unitEntity,unrealityEntity,doubleComfirmEntity,planCycleEntity]
        setpage = [baseSet]
        
        return setpage
    }
    
    func getDetailType(_ model: BTContractOrderModel) -> KRSwapTransactionDetailType? {
        if (model.category == .trigger || model.category == .break) {
            return .force
        } else if (model.category == .detail) {
            if KRBasicParameter.handleDouble(model.take_fee ?? "0") > 0 {
                return .force
            } else {
                return .reduce
            }
        }
        return nil
    }
    
    func getOrderResultStr(_ model : BTContractOrderModel) -> String {
        if model.errorno == .cancel && KRBasicParameter.handleDouble(model.cum_qty ?? "0") > 0 && KRBasicParameter.handleDouble(model.qty ?? "0") > KRBasicParameter.handleDouble(model.cum_qty ?? "0") {
            return "部分成交".localized()
        } else {
            switch model.errorno {
            case .noNoErr:
                return "已完成".localized()
            case .cancel,.timeout, .ASSETS, .FREEZE , .CLOSE, .reduce, .compensate, .positionErr, .FORBBIDN, .OPPSITE, .UNDO, .FOK, .IOC, .MARKET, .PASSIVE, .PLAY, .HANDOVER, .FORCE:
                return "已撤销".localized()
            default: break
            }
        }
        return ""
    }
    
    func getErrorNoStr(_ model : BTContractOrderModel) -> String {
        if model.cycle != nil && model.trend.rawValue > 0 && model.trigger_type.rawValue > 0 {
            return getPlanOrderErrNoStr(model)
        } else {
            return getOrderErrNoStr(model)
        }
    }
    
    // 历史委托失败原因
    func getOrderErrNoStr(_ model : BTContractOrderModel) -> String {
        var errNoStr = ""
        switch model.errorno {
        case .noNoErr:
            errNoStr = ""
        case .cancel:   // 用户取消
            errNoStr = "contract_normal_order_cancel".localized()
        case .timeout:  // 破产委托超时未成交，被系统撤销
            errNoStr = "contract_normal_order_timeout".localized()
        case .ASSETS:   // 用户资产不足，部分委托被系统撤销
            errNoStr = "contract_normal_order_ASSETS".localized()
        case .FREEZE:   // 冻结保证金不足，部分委托被系统撤销
            errNoStr = "contract_normal_order_FREEZE".localized()
        case .UNDO:     // 部分委托被系统撤销
            errNoStr = "contract_normal_order_UNDO".localized()
        case .CLOSE:    // 经系统试算该委托成交会引起仓位强平，委托被系统撤销
            errNoStr = "contract_normal_order_CLOSE".localized()
        case .reduce:   // 用户仓位发生自动减仓，部分委托被系统撤销
            errNoStr = "contract_normal_order_reduce".localized()
        case .compensate:   // 分摊对手方穿仓损失，部分委托被系统撤销
            errNoStr = "contract_normal_order_compensate".localized()
        case .positionErr:  // 可平仓位数量不足，部分委托被系统撤销
            errNoStr = "contract_normal_order_positionErr".localized()
        case .FORBBIDN:     // 委托类型非法，该委托被系统撤销
            errNoStr = "contract_normal_order_FORBBIDN".localized()
        case .OPPSITE:      // 不能与自己的反向订单成交，部分委托被系统撤销
            errNoStr = "contract_normal_order_OPPSITE".localized()
        case .FOK:      // FOK订单，无法全部成交时被系统撤销
            errNoStr = "contract_normal_order_FOK".localized()
        case .IOC:      // IOC订单，无法立即成交时部分委托被系统撤销
            errNoStr = "contract_normal_order_IOC".localized()
        case .MARKET:   // 市价单成交价格偏离过大，部分委托被系统撤销
            errNoStr = "contract_normal_order_MARKET".localized()
        case .PASSIVE:  // 被动委托，撮合时为taker部分被系统撤销
            errNoStr = "contract_normal_order_PASSIVE".localized()
        case .FORCE:    // 仓位发生强平，未成交委托被系统撤销
            errNoStr = "contract_normal_order_FORCE".localized()
        case .PLAY:     // play订单，部分委托被系统撤销
            errNoStr = "contract_normal_order_PLAY".localized()
        case .HANDOVER: // 仓位被强制交割，部分委托被系统撤销
            errNoStr = "contract_normal_order_HANDOVER".localized()
        default:
            errNoStr = ""
        }
        return errNoStr
    }
    
    // 条件单失败原因
    func getPlanOrderErrNoStr(_ model : BTContractOrderModel) -> String {
        var errNoStr = ""
        let finishTime = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: (model.finished_at ?? "0")), format: "yyyy/MM/dd HH:mm") ?? "-"
        let symbol = model.contractInfo?.symbol ?? "-"
        var tgPxType = "最新价".localized()
        switch model.trigger_type {
        case .tradePriceType:
            tgPxType = "最新价".localized()
        case .markPriceType:
            tgPxType = "合理价".localized()
        case .indexPriceType:
            tgPxType = "指数价".localized()
        default: break
        }
        let tgPx = model.px ?? "-"
        switch model.errorno {
        case .noNoErr:
            errNoStr = ""
        case .cancel:   // 用户取消
            errNoStr = "contract_normal_planOrder_cancel".localized()
        case .timeout:  // 订单超时
            errNoStr = "contract_normal_planOrder_timeout".localized()
        case .ASSETS:   // yyyy-MM-dd hh-mm-ss BTCUSDT(合约交易对)永续合约最新价格(触发类型)价格达到XXX触发条件单，因账户保证金余额不足，委托无法提交，执行失败
            errNoStr = String(format: "contract_normal_planOrder_ASSETS".localized(), finishTime,symbol,tgPxType,tgPx)
        case .FREEZE:   // yyyy-MM-dd hh-mm-ss BTCUSDT(合约交易对)永续合约最新价格(触发类型)价格达到XXX触发条件单，因委托撮合成交后将会引起仓位强平，委托无法提交，执行失败
            errNoStr = String(format: "contract_normal_planOrder_FREEZE".localized(), finishTime,symbol,tgPxType,tgPx)
        case .UNDO:     // 订单参数无效，触发失败
            errNoStr = "contract_normal_planOrder_UNDO".localized()
        case .CLOSE:    // yyyy-MM-dd hh-mm-ss BTCUSDT(合约交易对)永续合约最新价格(触发类型)价格达到XXX触发条件单，因仓位发生强平，无法提交委托，执行失败
            errNoStr = String(format: "contract_normal_planOrder_CLOSE".localized(), finishTime,symbol,tgPxType,tgPx)
        case .reduce:   // yyyy-MM-dd hh-mm-ss BTCUSDT(合约交易对)永续合约最新价格(触发类型)价格达到XXX触发条件单，因不存在可平仓位，无法提交委托，执行失败
            errNoStr = String(format: "contract_normal_planOrder_reduce".localized(), finishTime,symbol,tgPxType,tgPx)
        case .compensate:   // yyyy-MM-dd hh-mm-ss BTCUSDT(合约交易对)永续合约最新价格(触发类型)价格达到XXX触发条件单，因仓位可平数量不足，无法提交委托，执行失败
            errNoStr = String(format: "contract_normal_planOrder_compensate".localized(), finishTime,symbol,tgPxType,tgPx)
        case .positionErr:  // yyyy-MM-dd hh-mm-ss BTCUSDT(合约交易对)永续合约最新价格(触发类型)价格达到XXX触发条件单，因仓位34567654已被平仓，无法提交委托，执行失败
            errNoStr = String(format: "contract_normal_planOrder_positionErr".localized(), finishTime,symbol,tgPxType,tgPx)
        case .FORBBIDN:     // yyyy-MM-dd hh-mm-ss BTCUSDT(合约交易对)永续合约最新价格(触发类型)价格达到XXX触发条件单，因该合约已被暂停交易，无法提交委托，执行失败
            errNoStr = String(format: "contract_normal_planOrder_FORBBIDN".localized(), finishTime,symbol,tgPxType,tgPx)
        case .OPPSITE:      // 不能与自己的反向订单成交
            errNoStr = "contract_normal_planOrder_OPPSITE".localized()
        case .FOK:      // yyyy-MM-dd hh-mm-ss BTCUSDT(合约交易对)永续合约最新价格(触发类型)价格达到XXX触发条件单，因该合约已被下线，无法提交委托，执行失败
            errNoStr = String(format: "contract_normal_planOrder_FOK".localized(), finishTime,symbol,tgPxType,tgPx)
        case .IOC:      // 条件单执行失败
            errNoStr = "contract_normal_planOrder_IOC".localized()
        default:
            errNoStr = "contract_normal_planOrder_IOC".localized()
        }
        return errNoStr
    }
    
    func handleAddQtyOrderBooksData(_ orderBooks: [SLOrderBookModel]) -> [SLOrderBookModel] {
        var qty = BTZERO
        for (_, item) in orderBooks.enumerated() {
            qty = qty.bigAdd(item.qty)
            item.addupQty = qty
        }
        return orderBooks
    }
    
    func getforceTips(_ order : BTContractOrderModel) -> String {
        var forceTips = ""
        if order.px == nil || order.currentPrice == nil {
            return forceTips
        }
        if (order.category == .normal) {
            if (order.side == .buy_OpenLong) {
                if (order.currentPrice != nil && order.px.greaterThan(order.currentPrice.bigMul("1.05"))) {
                    forceTips = "contract_makerOrder_open_tips".localized()
                }
            } else if (order.side == .buy_CloseShort) {
                if (order.currentPrice != nil && order.px.greaterThan(order.currentPrice.bigMul("1.05"))) {
                    forceTips = "contract_makerOrder_close_tips".localized()
                }
            } else if (order.side == .sell_CloseLong) {
                if (order.currentPrice != nil && order.px.lessThan(order.currentPrice.bigMul("0.95"))) {
                    forceTips = "contract_makerOrder_close_tips".localized()
                }
            } else if (order.side == .sell_OpenShort) {
                if (order.currentPrice != nil && order.px.lessThan(order.currentPrice.bigMul("0.95"))) {
                    forceTips = "contract_makerOrder_open_tips".localized()
                }
            }
        } else if (order.category == .market) {
            if (order.side == .buy_OpenLong) {
                if (order.currentPrice != nil && order.open_avg_px != nil && order.open_avg_px.greaterThan(order.currentPrice.bigMul("1.03"))) {
                    forceTips = "contract_makerOrder_open_tips".localized()
                }
            } else if (order.side == .buy_CloseShort) {
                if (order.currentPrice != nil && order.open_avg_px != nil && order.open_avg_px.greaterThan(order.currentPrice.bigMul("1.03"))) {
                    forceTips = "contract_makerOrder_close_tips".localized()
                }
            } else if (order.side == .sell_CloseLong) {
                if (order.currentPrice != nil && order.open_avg_px != nil && order.open_avg_px.lessThan(order.currentPrice.bigMul("0.97"))) {
                    forceTips = "contract_makerOrder_close_tips".localized()
                }
            } else if (order.side == .sell_OpenShort) {
                if (order.currentPrice != nil && order.open_avg_px != nil && order.open_avg_px.lessThan(order.currentPrice.bigMul("0.97"))) {
                    forceTips = "contract_makerOrder_open_tips".localized()
                }
            }
        }
        return forceTips
    }
}

extension Array where Element == DispatchWorkItem {
    mutating func cancelPendingItems() {
        let newItems = self
        for (index, item) in newItems.enumerated() {
            if !item.isCancelled, index+1 != self.count {
                item.cancel()
                self.remove(at: index)
            }
        }
    }
}
