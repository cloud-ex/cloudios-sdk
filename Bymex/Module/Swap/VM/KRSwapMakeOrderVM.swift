//
//  KRSwapMakeOrderVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum KRMarketOrderVShowType : Int {
    case limit = 0
    case highLimit = 1
    case plan = 2
}

enum KRMarketOrderLimitType {
    case limitPx
    case marketPx
    case bidPx
    case askPx
}

enum KRMarketOrderHighLimitType : Int {
    case postOnly
    case fillOrKill
    case immediateOrCance
}

enum KRMarketOrderPlanType {
    case limitPlan
    case marketPlan
}

struct KRLeverageStruct {
    var typeStr : String
    var leverage : String
}

class KRSwapMakeOrderVM : NSObject {
    let disposeBag = DisposeBag()
    
    var itemModel : BTItemModel? {
        didSet {
            if itemModel != nil && itemModel?.contractInfo != nil {
                asset = SLPersonaSwapInfo.sharedInstance()?.getSwapAssetItem(withCoin: itemModel!.contractInfo.margin_coin)
                if oldValue?.instrument_id != itemModel?.instrument_id {
                    priceUnit = itemModel!.contractInfo!.quote_coin
                    costUnit = itemModel!.contractInfo!.margin_coin
                    makeOrderV?.refreshUnit()
                    makeOrderV?.priceInput.input.text = itemModel?.last_px.toSmallEditPriceContractID(itemModel?.instrument_id ?? 0)
                }
                makeOrderV?.refreshData()
            }
        }
    }
    
    weak var makeOrderV : KRSwapMakeOrderView?
    
    func setMakeOrderV(_ makeV : KRSwapMakeOrderView){
        self.makeOrderV = makeV
    }
    
    var asset : BTItemCoinModel?
    
    var direction = 1001 // 1001：开仓，1002：平仓
    let directionSubject : PublishSubject<Int> = PublishSubject()
    var orderSide : BTContractOrderWay = .buy_OpenLong              // 订单方向
    var orderType : KRMarketOrderVShowType = .limit                 // 订单类型
    var limitType : KRMarketOrderLimitType = .limitPx               // 价格类型
    var highLimitType : KRMarketOrderHighLimitType = .postOnly      // 高级委托类型
    var planType : KRMarketOrderPlanType = .limitPlan               // 条件单类型
    var tiggerType : BTContractOrderPriceType = .tradePriceType     // 触发类型
    
    /// 价格单位
    var priceUnit = ""
    /// 成本单位
    var costUnit = ""
    
    /// 以币为单位
    var isCoin : Bool {
        return BTStoreData.storeBool(forKey: BT_UNIT_VOL)
    }
    /// 数量单位
    var volumeUnit : String? {
        if isCoin == false {
            return "swap_text_volumeUnit".localized()
        }
        return itemModel?.contractInfo?.base_coin ?? "-"
    }
    
    var leverage : KRLeverageStruct? {
        get {
            guard let instrument_id = itemModel?.instrument_id else {
                return KRLeverageStruct(typeStr: "逐仓".localized(), leverage: "10")
            }
            return KRLeverageManager.shared.getleverageInfo(instrument_id)
        }
    }
    
    /// 买单深度
    var bids : [SLOrderBookModel]? {
        get {
            return SLPublicSwapInfo.sharedInstance()?.getBidOrderBooks(10) ?? []
        }
    }
    /// 卖单深度
    var asks : [SLOrderBookModel]? {
        get {
            return SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(10) ?? []
        }
    }
    /// 获取当前持多仓
    var buyPosition : BTPositionModel? {
        get {
            guard let entity = itemModel else {
                return nil
            }
            return SLFormula.getUserPosition(with: entity, contractWay: .buy_OpenLong)
        }
    }
    /// 获取当前持空仓
    var sellPosition : BTPositionModel? {
        get {
            guard let entity = itemModel else {
                return nil
            }
            return SLFormula.getUserPosition(with: entity, contractWay: .sell_OpenShort)
        }
    }
    /// 可开多
    var canOpenMore = "0"
    /// 可开空
    var canOpenShort = "0"
    
    /// 可平空
    var canCloseShort : String {
        get {
            var canClose = sellPosition?.cur_qty.bigSub(sellPosition?.freeze_qty) ?? "0"
            if isCoin {
                canClose = SLFormula.ticket(toCoin: canClose, price: sellPosition?.markPrice ?? "0", contract: itemModel!.contractInfo)
            }
            return canClose
        }
    }
    /// 可平多
    var canCloseMore : String {
        get {
            var canClose = buyPosition?.cur_qty.bigSub(buyPosition?.freeze_qty) ?? "0"
            if isCoin {
                canClose = SLFormula.ticket(toCoin: canClose, price: buyPosition?.markPrice ?? "0", contract: itemModel!.contractInfo)
            }
            return canClose
        }
    }
    
    var holdMoreNum : String {
        get {
            var hold = buyPosition?.cur_qty ?? "0"
            if isCoin {
                hold = SLFormula.ticket(toCoin: hold, price: buyPosition?.markPrice ?? "0", contract: itemModel!.contractInfo)
            }
            return hold
        }
    }
    
    var holdShortNum : String {
        get {
            var hold = sellPosition?.cur_qty ?? "0"
            if isCoin {
                hold = SLFormula.ticket(toCoin: hold, price: sellPosition?.markPrice ?? "0", contract: itemModel!.contractInfo)
            }
            return hold
        }
    }
    
    /// 可用
    var canUseAmount: String? {
        get {
            guard let instrument_id = itemModel?.instrument_id else {
                return "0"
            }
            if asset?.coin_code != itemModel?.contractInfo?.margin_coin {
                return "0"
            }
            return self.asset?.contract_avail.toSmallValue(withContract:instrument_id)
        }
    }
    
    var currentOrder : BTContractOrderModel?

}

extension KRSwapMakeOrderVM {
    
    // 生成订单
    func createOrder(px:String="0",qty:String="0",performPx:String="0") {
        if direction == 1001 {
            loadOpenOrder(px: px,qty: qty,performPx: performPx)
        } else {
            loadCloseOrder(px: px,qty: qty,performPx: performPx)
        }
    }
    
    //MARK:- 生成开仓单
    func loadOpenOrder(px:String="0",qty:String="0",performPx:String="0") {
        guard let entity = itemModel,let instrument_id = itemModel?.instrument_id, instrument_id > 0 else {
            return
        }
        let order = BTContractOrderModel()
        var openOrder : BTContractsOpenModel?
        order.takeFeeRatio = entity.contractInfo.taker_fee_ratio;
        order.instrument_id = instrument_id
        order.leverage = leverage?.leverage ?? "10"
        order.position_type = leverage?.typeStr == "全仓".localized() ? .allType : .pursueType
        if isCoin {
            if orderType == .plan && planType == .limitPlan {
                order.qty = SLFormula.coin(toTicket: qty, price: performPx, contract: entity.contractInfo).toString(0)
            } else {
                var carPx = px
                if orderType == .limit && limitType == .marketPx {
                    carPx = entity.last_px
                }
                order.qty = SLFormula.coin(toTicket: qty, price: carPx, contract: entity.contractInfo).toString(0)
            }
        } else {
            order.qty = qty
        }
        order.side = orderSide // 开多开空
        switch orderType {
        case .limit:
            order.category = .normal
            if limitType == .limitPx { // 限价单
                if px.lessThanOrEqual(BTZERO) {
                    order.px = itemModel!.fair_px
                } else {
                    order.px = px
                }
            } else if limitType == .marketPx {
                order.category = .market
                order.px = itemModel?.last_px ?? ""
            } else if limitType == .bidPx {
                if (bids?.count ?? 0 > 0) {
                    let orderM = bids!.first!
                    order.px = orderM.px
                }
            } else if limitType == .askPx {
                if (asks?.count ?? 0 > 0) {
                    let orderM = asks!.first!
                    order.px = orderM.px
                }
            }
        case .highLimit:
            if limitType == .limitPx {
                if px.lessThanOrEqual(BTZERO) {
                    order.px = entity.fair_px
                } else {
                    order.px = px
                }
            } else if limitType == .bidPx {
                if (bids?.count ?? 0 > 0) {
                    let orderM = bids!.first!
                    order.px = orderM.px
                }
            } else if limitType == .askPx {
                if (asks?.count ?? 0 > 0) {
                    let orderM = asks!.first!
                    order.px = orderM.px
                }
            }
            if highLimitType == .postOnly {
                order.category = .passive
            } else if highLimitType == .fillOrKill {
                order.category = .normal
                order.time_in_force = NSNumber.init(value: 2)
            } else if highLimitType == .immediateOrCance {
                order.category = .normal
                order.time_in_force = NSNumber.init(value: 3)
            }
        case .plan:
            order.px = px
            if planType == .limitPlan {
                order.category = .normal
                order.exec_px = performPx;
            } else if planType == .marketPlan {
                order.category = .market
                // 不传执行价格
                order.exec_px = px
            }
            order.trigger_type = tiggerType
            if tiggerType == .tradePriceType { // "最新价格"
                if (order.px.lessThan(itemModel!.last_px)) { // 计划价格低于当前价格
                    order.trend = .down
                } else if (order.px.greaterThan(itemModel!.last_px)) {
                    order.trend = .up
                } else {
                    order.trend = .up
                }
            } else if tiggerType == .markPriceType { // "合理价格"
                if (order.px.lessThan(itemModel!.fair_px)) { // 计划价格低于当前价格
                    order.trend = .down
                } else if (order.px.greaterThan(itemModel!.fair_px)) {
                    order.trend = .up
                } else {
                    order.trend = .up
                }
            } else { // "指数价格"
                if (order.px.lessThan(itemModel!.index_px)) { // 计划价格低于当前价格
                    order.trend = .down
                } else if (order.px.greaterThan(itemModel!.index_px)) {
                    order.trend = .up
                } else {
                    order.trend = .up
                }
            }
            let idx2 = BTStoreData.storeObject(forKey: ST_DATE_CYCLE) as? Int ?? 0
            if idx2 == 0 {
                order.cycle = NSNumber.init(value: 24)
            } else {
                order.cycle = NSNumber.init(value: 168)
            }
        }
        openOrder = BTContractsOpenModel.init(orderModel: order, contractInfo: entity.contractInfo, assets: asset)
        if openOrder != nil {
            if orderSide == .buy_OpenLong {
                var longNum = openOrder?.maxOpenLong ?? "0"
                if isCoin {
                    if orderType == .plan {
                        if order.exec_px.greaterThan(BT_ZERO) {
                            longNum = SLFormula.ticket(toCoin: longNum, price: order.exec_px, contract: entity.contractInfo)
                        } else {
                            longNum = SLFormula.ticket(toCoin: longNum, price: entity.fair_px, contract: entity.contractInfo)
                        }
                    } else {
                        if order.px != nil && order.px.greaterThan(BT_ZERO) {
                            longNum = SLFormula.ticket(toCoin: longNum, price: order.px, contract: entity.contractInfo)
                        } else {
                            longNum = SLFormula.ticket(toCoin: longNum, price: entity.fair_px, contract: entity.contractInfo)
                        }
                    }
                    longNum = longNum.toString(8) //toSmallValue(withContract: entity.instrument_id)
                } else {
                    longNum = longNum.toString(0)
                }
                canOpenMore = longNum
            } else if orderSide == .sell_OpenShort {
                var shortNum = openOrder?.maxOpenShort ?? "0"
                if isCoin {
                    if orderType == .plan {
                        if order.exec_px.greaterThan(BT_ZERO) {
                            shortNum = SLFormula.ticket(toCoin: shortNum, price: order.exec_px, contract: itemModel!.contractInfo)
                        } else {
                            shortNum = SLFormula.ticket(toCoin: shortNum, price: itemModel!.fair_px, contract: itemModel!.contractInfo)
                        }
                    } else {
                        if order.px != nil && order.px.greaterThan(BT_ZERO) {
                            shortNum = SLFormula.ticket(toCoin: shortNum, price:  order.px, contract: itemModel!.contractInfo)
                        } else {
                            shortNum = SLFormula.ticket(toCoin: shortNum, price: itemModel!.fair_px, contract: itemModel!.contractInfo)
                        }
                    }
                    shortNum = shortNum.toString(8)// shortNum.toSmallValue(withContract: itemModel!.instrument_id)
                } else {
                    shortNum = shortNum.toString(0)
                }
                canOpenShort = shortNum
            }
            order.avai = openOrder?.orderAvai?.toSmallValue(withContract: entity.instrument_id) ?? "0"
            order.freezAssets = openOrder?.freezAssets?.toSmallValue(withContract: entity.instrument_id) ?? "0"
            order.balanceAssets = asset?.contract_avail
        }
        currentOrder = order
    }
    
    //MARK:- 生成平仓单
    func loadCloseOrder(px:String="0",qty:String="0",performPx:String="0") {
        guard let entity = itemModel,let instrument_id = itemModel?.instrument_id else {
            return
        }
        let order = BTContractOrderModel()
        order.takeFeeRatio = entity.contractInfo.taker_fee_ratio;
        order.instrument_id = instrument_id
        if isCoin {
            if orderType == .plan && planType == .limitPlan {
                order.qty = SLFormula.coin(toTicket: qty, price: performPx, contract: entity.contractInfo).toString(0)
            } else {
                var carPx = px
                if orderType == .limit && limitType == .marketPx {
                    carPx = entity.last_px
                }
                order.qty = SLFormula.coin(toTicket: qty, price: carPx, contract: entity.contractInfo).toString(0)
            }
        } else {
            order.qty = qty
        }
        order.side = orderSide // 开多开空
        if orderType == .limit {
            order.category = .normal
            switch limitType {
            case .limitPx:
                if px.lessThanOrEqual(BTZERO) {
                    order.px = entity.fair_px
                } else {
                    order.px = px
                }
            case .marketPx:
                order.px = itemModel?.last_px ?? ""
                order.category = .market
            case .bidPx:
                if (bids?.count ?? 0 > 0) {
                    let orderM = bids!.first!
                    order.px = orderM.px
                }
            case .askPx:
                if (asks?.count ?? 0 > 0) {
                    let orderM = asks!.first!
                    order.px = orderM.px
                }
            }
        } else if orderType == .highLimit {
            switch limitType {
            case .limitPx:
                if px.lessThanOrEqual(BTZERO) {
                    order.px = entity.fair_px
                } else {
                    order.px = px
                }
            case .bidPx:
                if (bids?.count ?? 0 > 0) {
                    let orderM = bids!.first!
                    order.px = orderM.px
                }
            case .askPx:
                if (asks?.count ?? 0 > 0) {
                    let orderM = asks!.first!
                    order.px = orderM.px
                }
            default:break
            }
            if highLimitType == .postOnly {
                order.category = .passive
            } else if highLimitType == .fillOrKill {
                order.category = .normal
                order.time_in_force = NSNumber.init(value: 2)
            } else if highLimitType == .immediateOrCance {
                order.category = .normal
                order.time_in_force = NSNumber.init(value: 3)
            }
        } else if orderType == .plan {
            order.px = px
            if planType == .limitPlan {
                order.category = .normal;
                order.exec_px = performPx;
            } else if planType == .marketPlan {
                order.category = .market
                // 不传执行价格
                order.exec_px = px
            }
            order.trigger_type = tiggerType
            if tiggerType == .tradePriceType { // "最新价格"
                if (order.px.lessThan(itemModel!.last_px)) { // 计划价格低于当前价格
                    order.trend = .down;
                } else if (order.px.greaterThan(itemModel!.last_px)) {
                    order.trend = .up;
                } else {
                    order.trend = .up;
                }
            } else if tiggerType == .markPriceType { // "合理价格"
                if (order.px.lessThan(itemModel!.fair_px)) { // 计划价格低于当前价格
                    order.trend = .down;
                } else if (order.px.greaterThan(itemModel!.fair_px)) {
                    order.trend = .up;
                } else {
                    order.trend = .up;
                }
            } else { // "指数价格"
                if (order.px.lessThan(itemModel!.index_px)) { // 计划价格低于当前价格
                    order.trend = .down;
                } else if (order.px.greaterThan(itemModel!.index_px)) {
                    order.trend = .up;
                } else {
                    order.trend = .up;
                }
            }
            let idx2 = BTStoreData.storeObject(forKey: ST_DATE_CYCLE) as? Int ?? 0
            if idx2 == 0 {
                order.cycle = NSNumber.init(value: 24)
            } else {
                order.cycle = NSNumber.init(value: 168)
            }
        }
        currentOrder = order
    }
    
    // 点击提交订单
    func doSubmitOrder(_ sender: EXButton) {
        guard let submitOrder = currentOrder, submitOrder.qty.greaterThan(BTZERO) else {
            return
        }
        if submitOrder.category == .market {
            if orderType == .limit || orderType == .highLimit {
                submitOrder.px = nil
            } else {
                submitOrder.exec_px = nil
            }
        }
        if self.direction == 1001 { // 开仓单
            if XUserDefault.getOnComfirmSwapAlert() {
                if submitOrder.cycle != nil && submitOrder.trend.rawValue > 0 && submitOrder.trigger_type.rawValue > 0 { // 条件单订单
                    let sheet = KRProPlanOrderSheet()
                    sheet.configOrder(submitOrder)
                    sheet.clickSubmitBtnBlock = {  [weak self] in
                        self?.sendServerOrder(sender: sender,
                                              order: submitOrder,
                                              mission: nil,
                                              directionType: .defineContractOpen,
                                              submitSuccess: {
                                                EXAlert.dismissEnd {
                                                    EXAlert.showSuccess(msg: "下单成功".localized())
                                                }
                        })
                    }
                    EXAlert.showSheet(sheetView: sheet)
                } else { // 普通委托订单
                    submitOrder.currentPrice = itemModel?.last_px ?? "0"
                    let tips = KRSwapSDKManager.shared.getforceTips(submitOrder)
                    submitOrder.forceTips = tips // 价格偏离过大提示
                    
                    let sheet = KRProOrderSheet()
                    sheet.configOrder(submitOrder)
                    sheet.clickProOrderSubmitBlock = { [weak self] missionOrder in
                        self?.sendServerOrder(sender: sender,
                                              order: submitOrder,
                                              mission: missionOrder,
                                              directionType: .defineContractOpen,
                                              submitSuccess: {
                                                EXAlert.dismissEnd {
                                                    EXAlert.showSuccess(msg: "下单成功".localized())
                                                }
                                                
                        })
                    }
                    EXAlert.showSheet(sheetView: sheet)
                }
            } else {
                self.sendServerOrder(sender: sender,
                                    order: submitOrder,
                                    directionType: .defineContractOpen,
                                    submitSuccess: {
                    // 成功回调
                    EXAlert.showSuccess(msg: "下单成功".localized())
                })
            }
        } else {    // 平仓单
            if XUserDefault.getOnComfirmSwapAlert() {
                if submitOrder.cycle != nil && submitOrder.trend.rawValue > 0 && submitOrder.trigger_type.rawValue > 0 { // 条件单订单
                    let sheet = KRProPlanOrderSheet()
                    sheet.configOrder(submitOrder)
                    sheet.clickSubmitBtnBlock = {  [weak self] in
                        self?.sendServerOrder(sender: sender,
                                              order: submitOrder,
                                              mission: nil,
                                              directionType: .defineContractClose,
                                              submitSuccess: {
                                                EXAlert.dismissEnd {
                                                    EXAlert.showSuccess(msg: "下单成功".localized())
                                                }
                        })
                    }
                    EXAlert.showSheet(sheetView: sheet)
                } else {
                    let closeAlert = KRNormalAlert()
                    var side = "买入".localized()
                    if submitOrder.side == .sell_CloseLong {
                        side = "卖出".localized()
                    }
                    var px = submitOrder.px ?? ""
                    let qty = submitOrder.qty ?? ""
                    let unit = submitOrder.contractInfo?.quote_coin ?? ""
                    let symbol = submitOrder.contractInfo?.symbol ?? ""
                    var title = "限价平仓".localized()
                    var message = "限价".localized()+px+unit+side+qty+"张".localized()+symbol
                    if submitOrder.category == .market {
                        title = "市价平仓".localized()
                        px = "市价".localized()
                        message = px+side+qty+"张".localized()+symbol
                    }
                    if submitOrder.cycle != nil && submitOrder.trend.rawValue > 0 && submitOrder.trigger_type.rawValue > 0 {
                        closeAlert.configAlert(title: "计划".localized() + title, message: message, passiveBtnTitle: "取消", positiveBtnTitle: "确定")
                    } else {
                        closeAlert.configAlert(title: title, message: message, passiveBtnTitle: "取消", positiveBtnTitle: "确定")
                    }
                    closeAlert.alertCallback = {[weak self] tag in
                        if tag == 0 {
                            self?.sendServerOrder(sender: sender,
                                                  order: submitOrder,
                                                  directionType: .defineContractClose,
                                                  submitSuccess: {
                                                    // 成功回调
                                                    EXAlert.showSuccess(msg: "下单成功".localized())
                            })
                        }
                    }
                    EXAlert.showAlert(alertView: closeAlert)
                }
            } else {
                self.sendServerOrder(sender: sender,
                                    order: submitOrder,
                                    directionType: .defineContractClose,
                                    submitSuccess: {
                    // 成功回调
                    EXAlert.showSuccess(msg: "下单成功".localized())
                })
            }
        }
    }
    
    // 提交合约订单
    private func sendServerOrder(sender: EXButton,
                                order: BTContractOrderModel,
                                mission:BTProfitOrLossModel? = nil,
                                directionType: BTContractOrderType,
                                submitSuccess: (() -> Void)?) {
        let success = { [weak self] (contract_id: NSNumber?) in
            OperationQueue.main.addOperation {
                submitSuccess?()
                self?.submitContractOrderSuccess()
            }
        }
        let failure = { [weak self] (err: Any?) in
            EXAlert.dismissEnd {
                guard self != nil else { return }
                if let errMsg = (err as? String) {
                    if errMsg == LEVERAGE_MATCH_ERROR {
                        guard self?.itemModel?.instrument_id != nil else {
                            return
                        }
                        KRLeverageManager.shared.getGlobalLeverage(instrumentId: self!.itemModel!.instrument_id,
                                                                   successCallback: { (arr) in
                                                                    EXAlert.showWarning(msg: "系统已为您同步最新杠杆信息，请重新下单".localized())
                                                                    DispatchQueue.main.async {
                                                                        sender.animationStopped()
                                                                    }
                        }) { (err) in
                            DispatchQueue.main.async {
                                EXAlert.showFail(msg: "同步杠杆信息失败".localized())
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            EXAlert.showFail(msg: errMsg)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        EXAlert.showFail(msg: "下单失败，请稍后再试!".localized())
                    }
                }
            }
        }
        if self.orderType == .plan {
            BTContractTool.submitPlanOrder(order,
                                           contractOrderType: directionType,
                                           assetPassword: nil,
                                           success: success,
                                           failure: failure)
        } else {
            BTContractTool.sendContractsOrder(order,
                                              contractOrderType: directionType,
                                              profitOrLossModel: mission,
                                              assetPassword: nil,
                                              success: success,
                                              failure: failure)
        }
    }
    
    // 下单成功发送通知
    private func submitContractOrderSuccess() {
        
    }
}
