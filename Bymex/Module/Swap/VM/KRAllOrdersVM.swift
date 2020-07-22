//
//  KRAllOrdersVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum KRSwapTransactionStatus: Int {
    /// 全部类型
    case allTypes = 0
    /// 已完成
    case finished
    /// 已撤销
    case Cancel
    /// 部分成交
    case subDeal
}

class KRAllOrdersVM : NSObject {
    var cellIdentifier = limitIdentify
    
    var itemModel: BTItemModel?
    
    var orderWay : BTContractOrderWay = .unkown
    
    var status : KRSwapTransactionStatus = .allTypes
    
    var tableViewRowDatas : [BTContractOrderModel] = [] {
        didSet{
            vc?.reloadTableView()
        }
    }
    
    weak var vc : KRAllTransactionsVc?
    func setVc(_ vc : KRAllTransactionsVc){
        self.vc = vc
        setNotification()
    }
    
    func setNotification() {
        // MARK:- 合约私有信息
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: BTSocketDataUpdate_Contract_Unicast_Notification))
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: {[weak self] notification in
                guard let mySelf = self else {return}
                guard let socketModelArray = notification.userInfo?["data"] as? [BTWebSocketModel] else {
                    return
                }
                if mySelf.cellIdentifier == limitIdentify {
                    mySelf.wsDealOrder(socketModelArray)
                }
            })
    }
}

extension KRAllOrdersVM {
    //MARK:- 请求订单信息
    func requestTransitionData() {
        guard let instrument_id = itemModel?.instrument_id else {
            return
        }
        if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil {
            return
        }
        if cellIdentifier == limitIdentify {
            BTContractTool.getUserContractOrders(withContractID: instrument_id, status: .allWait, way: orderWay,offset: 0, size: 0, success: {[weak self] (models: [BTContractOrderModel]?) in
                self?.tableViewRowDatas = models ?? []
            }) { (error) in
            }
        } else if cellIdentifier == planIdentify {
            BTContractTool.getUserPlanContractOrders(withContractID: instrument_id, status: .allWait,way: orderWay, offset: 0, size: 0, success: {[weak self]  (models: [BTContractOrderModel]?) in
                 self?.tableViewRowDatas = models ?? []
            }) { (error) in
            }
        } else if cellIdentifier == limitHistoryIdentify {
            BTContractTool.getUserContractOrders(withContractID: instrument_id, status: .finished,way: orderWay, offset: 0, size: 0, success: {[weak self]  (models: [BTContractOrderModel]?) in
                guard let mySelf = self else {return}
                mySelf.tableViewRowDatas = mySelf.handleHistorySift(models: models ?? [])
            }) { (error) in
            }
        } else if cellIdentifier == planHistoryIdentify {
            BTContractTool.getUserPlanContractOrders(withContractID: instrument_id, status: .finished,way: orderWay, offset: 0, size: 0, success: {[weak self]  (models: [BTContractOrderModel]?) in
                guard let mySelf = self else {return}
                mySelf.tableViewRowDatas = mySelf.handleHistorySift(models: models ?? [])
            }) { (error) in
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
                EXAlert.showSuccess(msg: "contract_cancelorder_success".localized())
                completeHandle?(true)
            }) { (error) in
                print(error ?? "error is nil")
                EXAlert.showFail(msg: "contract_cancelorder_failure".localized())
                completeHandle?(false)
            }
        } else if identifyID == planIdentify {
            BTContractTool.cancelPlanOrders(orders, contractOrderType: .defineContractOpen, assetPassword: nil, success: { (oid) in
                EXAlert.showSuccess(msg: "contract_cancelorder_success".localized())
                completeHandle?(true)
            }) { (error) in
                print(error ?? "error is nil")
                completeHandle?(false)
                EXAlert.showFail(msg: "contract_cancelorder_failure".localized())
            }
        }
    }
    
    func handleHistorySift(models: [BTContractOrderModel]) -> [BTContractOrderModel] {
        var tempModels: [BTContractOrderModel] = []
        switch status {
            case .allTypes:
                tempModels = models
            case .finished:
                tempModels = self.findHistoryModels(finishTypes: [.noNoErr], models: models)
            case .Cancel:
                tempModels = self.findHistoryModels(finishTypes: [.cancel,.timeout, .ASSETS, .CLOSE, .reduce, .compensate, .positionErr, .UNDO, .FORBBIDN, .OPPSITE, .FOK , .FORCE , .MARKET, .IOC , .PLAY,.HANDOVER,.PASSIVE], models: models)
            case .subDeal:
                tempModels = self.findSubDealModels(models: models)
        }
        return tempModels
    }
    
    private func findHistoryModels(finishTypes: [BTContractOrderErrNO], models: [BTContractOrderModel]) -> [BTContractOrderModel] {
        var res = [BTContractOrderModel]()
        for model in models {
            for type in finishTypes {
                if model.errorno == type {
                    res.append(model)
                }
            }
        }
        return res
    }
    /// 获取部分成交记录
    private func findSubDealModels(models: [BTContractOrderModel]) -> [BTContractOrderModel] {
        var res = [BTContractOrderModel]()
        // 判断订单是否存在已成交
        for model in models {
            if model.errorno == .cancel && KRBasicParameter.handleDouble(model.cum_qty ?? "0") > 0 && KRBasicParameter.handleDouble(model.qty ?? "0") > KRBasicParameter.handleDouble(model.cum_qty ?? "0") {
                res.append(model)
            }
        }
        return res
    }
}

extension KRAllOrdersVM {
    func wsDealOrder(_ sockerModels : [BTWebSocketModel]) {
        var orders: [BTContractOrderModel] = Array(tableViewRowDatas)
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
            tableViewRowDatas = orders
        }
    }
}
