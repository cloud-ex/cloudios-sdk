//
//  KRSwapVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

let limitIdentify = "KRSwapLimitOrderTC"
let planIdentify = "KRSwapPlanOrderTC"
let limitHistoryIdentify = "KRSwapLimitHistoryOrderTC"
let planHistoryIdentify = "KRSwapPlanHistoryOrderTC"

class KRSwapVM: NSObject {
    
    var cellIdentifier = limitIdentify
    
    let disposeBag = DisposeBag()
    
    var itemModel: BTItemModel? {
        didSet {
            if itemModel != nil && itemModel!.instrument_id > 0 {
                if self.proV != nil && self.proV?.isHidden == false {                   // 专业模式
                    proV?.makeOrderTC.makeOrderV.makerOrderVM.itemModel = itemModel
                    self.updataPriceInfo(itemModel!)
                    if oldValue?.instrument_id != itemModel!.instrument_id {
                        self.proV?.makeOrderTC.priceInfoV.refreshPriceUnit()
                        self.proV?.makeOrderTC.priceInfoV.clearOrderBook()
                        // 请求仓位
                        self.requestPositionData(itemModel!.instrument_id)
                        // 请求订单
                        self.requestTransitionData(cellIdentifier)
                    } else {
                        // 更新仓位信息
                        do {
                            let positions = try self.swapPositionList.value()
                            if positions.count > 0 {
                                self.swapPositionList.onNext(positions)
                            }
                        } catch {
                            
                        }
                    }
                } else if self.lightV != nil && self.lightV?.isHidden == false {          // 闪电模式
                    if oldValue?.instrument_id != itemModel!.instrument_id {
                        // 请求K线
                        lightV?.kLineView.itemModel = itemModel
                        // 请求仓位
                        requestPositionData(itemModel!.instrument_id)
                    } else {
                        // 更新仓位信息
                        do {
                            let positions = try self.swapPositionList.value()
                            if positions.count > 0 {
                                self.swapPositionList.onNext(positions)
                            }
                        } catch {
                            
                        }
                    }
                }
            }
        }
    }
    
    let swapOrdersList = BehaviorSubject<[BTContractOrderModel]>(value: [])
    let swapPositionList = BehaviorSubject<[BTPositionModel]>(value: [])
    
    weak var proV : KRSwapProView?
    func setProV(_ proV : KRSwapProView){
        self.proV = proV
    }
    
    weak var lightV : KRSwapLightView?
    func setLightV(_ lV : KRSwapLightView){
        self.lightV = lV
    }
}

extension KRSwapVM {
    
    func updataPriceInfo(_ itemModel : BTItemModel) {
        proV?.makeOrderTC.priceInfoV.updataPriceInfo(itemModel)
    }
}

extension KRSwapVM {
    
    //MARK:- 请求当前委托、条件单
    func requestTransitionData(_ identifyID : String,_ completeHandle: ((Bool) -> ())?=nil) {
        guard let instrument_id = itemModel?.instrument_id , instrument_id > 0 else {
            return
        }
        if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil {
            return
        }
        if identifyID == limitIdentify {
            BTContractTool.getUserContractOrders(withContractID: instrument_id, status: .allWait, offset: 0, size: 0, success: { (models: [BTContractOrderModel]?) in
                self.swapOrdersList.onNext(models ?? [])
                completeHandle?(true)
            }) { (error) in
                completeHandle?(false)
            }
        } else if identifyID == planIdentify {
            BTContractTool.getUserPlanContractOrders(withContractID: instrument_id, status: .allWait, offset: 0, size: 0, success: { (models: [BTContractOrderModel]?) in
                 self.swapOrdersList.onNext(models ?? [])
                completeHandle?(true)
            }) { (error) in
                self.swapOrdersList.onNext([])
                completeHandle?(false)
            }
        }
    }
    //MARK:- 撤销当前委托、条件单
    func cancelTransitionOrders(_ identifyID : String, _ orders : [BTContractOrderModel],_ completeHandle: ((Bool) -> ())?) {
        guard SLPlatformSDK.sharedInstance().activeAccount != nil else {
            return
        }
        if identifyID == limitIdentify {
            BTContractTool.cancelContractOrders(orders, contractOrderType: .defineContractOpen, assetPassword: nil, success: {(oid) in
                EXAlert.showSuccess(msg: "撤单成功".localized())
                completeHandle?(true)
            }) { (error) in
                EXAlert.showFail(msg: "撤单失败".localized())
                completeHandle?(false)
            }
        } else if identifyID == planIdentify {
            BTContractTool.cancelPlanOrders(orders, contractOrderType: .defineContractOpen, assetPassword: nil, success: { (oid) in
                EXAlert.showSuccess(msg: "撤单成功".localized())
                completeHandle?(true)
            }) { (error) in
                print(error ?? "error is nil")
                completeHandle?(false)
                EXAlert.showFail(msg: "撤单失败".localized())
            }
        }
    }
    //MARK:- 根据合约id请求仓位
    func requestPositionData(_ instrument_id : Int64,_ completeHandle: ((Bool) -> ())?=nil) {
        guard XUserDefault.getToken() != nil,SLPlatformSDK.sharedInstance().activeAccount != nil,instrument_id > 0 else {
            return
        }
        BTContractTool.getUserPosition(withContractID: instrument_id,
                                       status: BTPositionStatus.holdSystem,
                                       offset: 0,
                                       size: 0,
                                       success: {[weak self] (models: [BTPositionModel]?) in
                                        self?.swapPositionList.onNext(models ?? [])
                                        completeHandle?(true)
        }) { (error) in
            completeHandle?(false)
            print(error as Any)
        }
    }
    
    //MARK:- 闪电模式闪电平仓
    func requestClosePositionData(_ entity : BTPositionModel) {
        guard XUserDefault.getToken() != nil,SLPlatformSDK.sharedInstance().activeAccount != nil,entity.instrument_id > 0 else {
            return
        }
        guard let qty = entity.cur_qty, qty.length > 0 else {
            return
        }
        
        
        let closeAlert = KRNormalAlert()
        
        let symbol = entity.contractInfo?.symbol ?? ""
        let title = "闪电平仓".localized()
        let message = "确定".localized()+title+qty+"张".localized()+symbol
        closeAlert.configAlert(title: title, message: message, passiveBtnTitle: "取消", positiveBtnTitle: "确定")
        closeAlert.alertCallback = {[weak self] tag in
            if tag == 0 {
                if entity.freeze_qty.greaterThan(BTZERO) {// 先取消对应的委托单
                    guard let entrustOrders = SLFormula.getCloseEntrustOrder(withPosition: entity) as? [BTContractOrderModel] else {
                        return
                    }
                    self?.handleCancelAllEntrustOrders(entity,entrustOrders, qty, .market, "")
                } else {
                    self?.handleCloseOrder(entity,price: "", volume: qty, category: .market)
                }
            }
        }
        EXAlert.showAlert(alertView: closeAlert)
    }
    
    func handleCancelAllEntrustOrders(_ entity : BTPositionModel,_ entrustOrders : [BTContractOrderModel],_ volume:String,_ category:BTContractOrderCategory,_ px: String) {
        BTContractTool.cancelContractOrders(entrustOrders, contractOrderType: .defineContractClose, assetPassword: nil, success: {[weak self] (number) in
            if category == .market {
                let newprice = BTMaskFutureTool.marketPrice(withContractID: entity.instrument_id) ?? "0"
                self?.handleCloseOrder(entity,price: newprice, volume: volume, category: .market)
            } else {
                self?.handleCloseOrder(entity,price: px, volume: volume, category: .normal)
            }
        }) { (error) in
        }
    }
    
    func handleCloseOrder(_ entity : BTPositionModel, price:String,volume:String, category:BTContractOrderCategory) {
        var way : BTContractOrderWay
        if entity.side == .openMore {
            way = .sell_CloseLong
        } else {
            way = .buy_CloseShort
        }
        let orderModel = BTContractOrderModel.newContractCloseOrder(withContractId: entity.instrument_id, category: category, way: way, positionID: entity.pid, price: price, vol: volume)
        orderModel!.position_type = entity.position_type
        BTContractTool.sendContractsOrder(orderModel!, contractOrderType: .defineContractClose, assetPassword: nil, success: {[weak self] (oid) in
            EXAlert.showSuccess(msg: "平仓成功")
            if SLContractSocketManager.shared().isConnected == false {
                self?.requestPositionData(entity.instrument_id)
            }
        }) { (error) in
            guard let errStr = error as? String else {
                EXAlert.showFail(msg: "平仓失败")
                return
            }
            EXAlert.showFail(msg: errStr)
        }
    }
    
    //MARK:- 提交订单
    // 提交闪电合约订单
    func sendServerOrder(order: BTContractOrderModel,
                         submitSuccess: ((Bool) -> Void)?) {
        let success = { [weak self] (contract_id: NSNumber?) in
            OperationQueue.main.addOperation {
                submitSuccess?(true)
                self?.submitContractOrderSuccess()
            }
        }
        let failure = { [weak self] (err: Any?) in
            submitSuccess?(false)
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
        BTContractTool.sendContractsOrder(order,
                                          contractOrderType: .defineContractOpen,
                                          profitOrLossModel: nil,
                                          assetPassword: nil,
                                          success: success,
                                          failure: failure)
    }
    
    // 下单成功发送通知
    private func submitContractOrderSuccess() {
        
    }
}

// MARK: - ws
extension KRSwapVM {
    func wsDealOrder(_ sockerModels : [BTWebSocketModel]) {
        do {
            var orders = try swapOrdersList.value()
            var isChanged = false
            
            for socketModel in sockerModels {
                guard let socketOrderModel = socketModel.order else {
                    continue
                }
                // 如果订单结束
                if socketOrderModel.status == .finished {
                    for idx in 0..<orders.count {
                        if orders[idx].oid == socketOrderModel.oid {
                            if BTFormat.getTimeStr(with: socketOrderModel.updated_at) >= BTFormat.getTimeStr(with: orders[idx].updated_at) {
                                orders.remove(at: idx)
                                isChanged = true
                            }
                            break
                        }
                    }
                } else if orders.count == 0 {
                    if socketOrderModel.instrument_id == self.itemModel?.instrument_id {
                        orders.append(socketOrderModel)
                        isChanged = true
                    }
                } else {
                    for idx in 0..<orders.count {
                        if orders[idx].oid == socketOrderModel.oid {
                            if BTFormat.getTimeStr(with: socketOrderModel.updated_at) >= BTFormat.getTimeStr(with: orders[idx].updated_at) {
                                orders[idx] = socketOrderModel
                                isChanged = true
                            }
                            break
                        }
                        if idx == orders.count - 1 && socketOrderModel.instrument_id == self.itemModel?.instrument_id {
                            orders.insert(socketOrderModel, at: 0)
                            isChanged = true
                        }
                    }
                }
            }
            if isChanged == true {
                DispatchQueue.main.async { [weak self] in
                    self?.swapOrdersList.onNext(orders)
                }
            }
        } catch {
            
        }
    }
    
    func wsDealPosition(_ sockerModels : [BTWebSocketModel]) {
        do {
            var positions = try swapPositionList.value()
            var isChanged = false
            
            for socketModel in sockerModels {
                guard let socketPositionModel = socketModel.position else {
                    continue
                }
                // 已平仓
                if socketPositionModel.status == .close {
                    for idx in 0..<positions.count {
                        if positions[idx].pid == socketPositionModel.pid {
                            // 如果websocket推送过来的是最新的
                            if BTFormat.getTimeStr(with: socketPositionModel.updated_at) >= BTFormat.getTimeStr(with: positions[idx].updated_at) {
                                positions.remove(at: idx)
                                isChanged = true
                            }
                            break
                        }
                    }
                } else if positions.count == 0 {
                    if socketPositionModel.instrument_id == self.itemModel?.instrument_id {
                        positions.append(socketPositionModel)
                        isChanged = true
                    }
                } else {
                    for idx in 0..<positions.count {
                        if positions[idx].pid == socketPositionModel.pid {
                            if BTFormat.getTimeStr(with: socketPositionModel.updated_at) >= BTFormat.getTimeStr(with: positions[idx].updated_at) {
                                positions[idx] = socketPositionModel
                                isChanged = true
                            }
                            break
                        }
                        if idx == positions.count - 1 && socketPositionModel.instrument_id == self.itemModel?.instrument_id {
                            positions.insert(socketPositionModel, at: 0)
                            isChanged = true
                        }
                    }
                }
            }
            if isChanged == true {
                DispatchQueue.main.async { [weak self] in
                    self?.swapPositionList.onNext(positions)
                }
            }
        } catch {
            
        }
    }
}
