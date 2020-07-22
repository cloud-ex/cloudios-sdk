//
//  KRProfitOrLossSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRProfitOrLossSheet: KRSwapBaseSheet {
    
    typealias ClickStopProfitLossBlock = (Bool) -> ()
    var clickStopProfitLossBlock : ClickStopProfitLossBlock?
    var px_unit : String = "-"
    // 周期
    var cy = (BTStoreData.storeObject(forKey: ST_DATE_CYCLE) as? Int ?? 0) == 0 ? "24" : "168"
    // 触发类型 (默认都以最新价触发)
    var tiggerIndex : BTContractOrderPriceType = .tradePriceType
    // 止盈订单
    var stopProfitOrder : BTContractOrderModel?
    // 止损订单
    var stopLossOrder : BTContractOrderModel?
    
    var submitCount = 0
    
    var itemBS: BehaviorSubject<BTItemModel>? {
        didSet {
            itemBS?.asObserver().subscribe(onNext: {[unowned self] (itemModel) in
                if itemModel.trend == .up {
                    self.lastValueLabel.textColor = UIColor.ThemekLine.up
                } else {
                    self.lastValueLabel.textColor = UIColor.ThemekLine.down
                }
                self.lastValueLabel.text = self.positionModel?.lastPrice ?? "0"
                self.closeValueLabel.text = self.positionModel?.liquidate_price ?? "0"
            }).disposed(by: self.disposeBag)
        }
    }
    
    var positionModel: BTPositionModel? {
        didSet {
            guard positionModel != nil, positionModel!.instrument_id > 0 else {
                return
            }
            stopProfitOrder = positionModel?.plan_order_stop_p
            stopLossOrder = positionModel?.plan_order_stop_l
            self.lastValueLabel.text = positionModel?.lastPrice ?? "0"
            self.closeValueLabel.text = positionModel?.liquidate_price ?? "0"
        }
    }
    lazy var lastPxLabel : UILabel = {
        let object = UILabel.init(text: "最新价".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var lastValueLabel : UILabel = {
        let object = UILabel.init(text: "--".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .left)
        return object
    }()
    lazy var closePxLabel : UILabel = {
        let object = UILabel.init(text: "预估强平价".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var closeValueLabel : UILabel = {
        let object = UILabel.init(text: "--".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        return object
    }()
    lazy var profitV : KRProfitOrLossView = {
        let object = KRProfitOrLossView()
        object.editBtn.setTitle("止盈", for: .normal)
        object.editInput.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
             mySelf.textFieldValueHasChanged(textField: object.editInput.input)
        }
        object.editInput2.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
             mySelf.textFieldValueHasChanged(textField: object.editInput2.input)
        }
        return object
    }()
    lazy var lossV : KRProfitOrLossView = {
        let object = KRProfitOrLossView()
        object.editBtn.setTitle("止损", for: .normal)
        object.editInput.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
             mySelf.textFieldValueHasChanged(textField: object.editInput.input)
        }
        object.editInput2.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
             mySelf.textFieldValueHasChanged(textField: object.editInput2.input)
        }
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        contentView.addSubViews([profitV,lossV,lastPxLabel,lastValueLabel,closePxLabel,closeValueLabel])
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(300)
        }
        lastPxLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(17)
            make.width.lessThanOrEqualTo(80)
        }
        lastValueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lastPxLabel.snp.right).offset(2)
            make.height.centerY.equalTo(lastPxLabel)
            make.width.lessThanOrEqualTo(80)
        }
        closePxLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lastValueLabel.snp.right).offset(5)
            make.height.centerY.equalTo(lastPxLabel)
            make.width.lessThanOrEqualTo(80)
        }
        closeValueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(closePxLabel.snp.right).offset(2)
            make.height.centerY.equalTo(lastPxLabel)
            make.width.lessThanOrEqualTo(80)
        }
        profitV.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.top.equalTo(lastPxLabel.snp.bottom).offset(20)
        }
        lossV.snp.makeConstraints { (make) in
            make.left.right.equalTo(profitV)
            make.top.equalTo(profitV.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
        nameLabel.text = "止盈止损".localized()
    }
}

extension KRProfitOrLossSheet {
    
    func configPositionModel(entity : BTPositionModel) {
        positionModel = entity
        var decimal = "0"
        if entity.contractInfo.px_unit.kr_length > 3 {
            decimal = String(entity.contractInfo.px_unit.kr_length-3)
        }
        profitV.editInput.decimal = decimal
        profitV.editInput2.decimal = decimal
        lossV.editInput.decimal = decimal
        lossV.editInput2.decimal = decimal
        if stopProfitOrder != nil {
            profitV.clickEditBtn(profitV.editBtn)
            profitV.editInput.input.text = stopProfitOrder!.px ?? ""
            if stopProfitOrder!.category != .market {
                profitV.editInput2.input.text = stopProfitOrder!.exec_px ?? ""
                profitV.setMarketStatus(false)
            }
            textFieldValueHasChanged(textField:profitV.editInput.input)
        }
        
        if stopLossOrder != nil {
            lossV.clickEditBtn(lossV.editBtn)
            lossV.editInput.input.text = stopLossOrder?.px ?? ""
            textFieldValueHasChanged(textField:lossV.editInput.input)
            if stopLossOrder!.category != .market {
                lossV.editInput2.input.text = stopLossOrder!.exec_px ?? ""
                lossV.setMarketStatus(false)
            }
        }
    }
    
    func textFieldValueHasChanged(textField:UITextField) {
        guard let position = positionModel else {
            return
        }
        if textField == profitV.editInput.input {
            if profitV.isMarket {
                if textField.text?.length ?? 0 > 0 {
                    profitV.tipsLabel.isHidden = false
                    SLFormula.carculatePositionAnticipateProfit(position, performPrice: textField.text!) {[weak self] (value, rate) in
                        let valueStr = value.toSmallValue(withContract:position.instrument_id) ?? "0"
                        let rateStr = rate.toPercentString(2) ?? "0"
                        let tipsStr = String(format: "预计盈利 %@ %@，回报率 %@", valueStr,position.contractInfo.margin_coin ?? "-",rateStr)
                        self?.profitV.tipsLabel.text = tipsStr
                    }
                } else {
                    profitV.tipsLabel.isHidden = true
                }
            }
        } else if textField == lossV.editInput.input {
            if lossV.isMarket {
                if textField.text?.length ?? 0 > 0 {
                    lossV.tipsLabel.isHidden = false
                    SLFormula.carculatePositionAnticipateLoss(position, performPrice: textField.text!) {[weak self] (value, rate) in
                        let valueStr = value.toSmallValue(withContract:position.instrument_id) ?? "0"
                        let rateStr = rate.toPercentString(2) ?? "0"
                        let tipsStr = String(format: "预计亏损 -%@ %@，回报率 -%@", valueStr,position.contractInfo.margin_coin ?? "-",rateStr)
                        self?.lossV.tipsLabel.text = tipsStr
                    }
                } else {
                    lossV.tipsLabel.isHidden = true
                }
            }
        } else if textField == profitV.editInput2.input {
            if textField.text?.length ?? 0 > 0 {
                profitV.tipsLabel.isHidden = false
                SLFormula.carculatePositionAnticipateProfit(position, performPrice: textField.text!) {[weak self] (value, rate) in
                    let valueStr = value.toSmallValue(withContract:position.instrument_id) ?? "0"
                    let rateStr = rate.toPercentString(2) ?? "0"
                    let tipsStr = String(format: "预计盈利 %@ %@，回报率 %@", valueStr,position.contractInfo.margin_coin ?? "-",rateStr.toPercentString(2))
                    self?.profitV.tipsLabel.text = tipsStr
                }
            } else {
                profitV.tipsLabel.isHidden = true
            }
        } else if textField == lossV.editInput2.input {
            if textField.text?.length ?? 0 > 0 {
                lossV.tipsLabel.isHidden = false
                SLFormula.carculatePositionAnticipateLoss(position, performPrice: textField.text!) {[weak self] (value, rate) in
                    let valueStr = value.toSmallValue(withContract:position.instrument_id) ?? "0"
                    let rateStr = rate.toPercentString(2) ?? "0"
                    let tipsStr = String(format: "预计亏损 -%@ %@，回报率 -%@", valueStr,position.contractInfo.margin_coin ?? "-",rateStr.toPercentString(2))
                    self?.lossV.tipsLabel.text = tipsStr
                }
            } else {
                lossV.tipsLabel.isHidden = true
            }
        }
    }
    
    override func clickSubmitBtn(_ sender: EXButton) {
        guard let entity = self.positionModel else {
            return
        }
        if profitV.editBtn.isSelected == true {
            if self.profitV.editInput.input.text?.count == 0 {
                EXAlert.showFail(msg: "请输入止盈触发价格")
                return
            }
        } else if lossV.editBtn.isSelected == true {
            if self.lossV.editInput.input.text?.count == 0 {
                EXAlert.showFail(msg: "请输入止损触发价格")
                return
            }
        }
        let profitResult = takeProfitOrder()
        let lossResult = takeLossOrder()
        let profitOrder = profitResult.profit
        let lossOrder = lossResult.loss
        if profitResult.hasError == true || lossResult.hasError == true {
            return
        }
        // 预警价格筛选
        if lossOrder != nil  {
            if entity.side == .openMore {
                if (lossOrder?.px ?? "0").lessThan(entity.liquidate_price ?? "0") {
                    EXAlert.showFail(msg: "止损触发价格和执行价格需要高于强平价格".localized());
                    return
                }
                if (lossOrder?.px ?? "0").lessThan(entity.earlyWarningPx) {
                    let alert = KRNormalAlert()
                    let earlyWarningPx = entity.earlyWarningPx ?? "0"
                    alert.configAlert(title: "", message: "止损触发价格或执行价格低于预警价格 \(earlyWarningPx)，可能会导致止损失败，是否继续提交？", passiveBtnTitle: "取消", positiveBtnTitle: "继续提交")
                    alert.alertCallback = {[weak self] tag in
                        if tag == 0 {
                            self?.submitOrderOrCancelOrder(profitOrder,lossOrder)
                        }
                    }
                    EXAlert.showAlert(alertView: alert)
                    return
                }
            } else {
                if (lossOrder?.px ?? "0").greaterThan(entity.liquidate_price ?? "0") {
                    EXAlert.showFail(msg: "止损触发价格和执行价格需要低于强平价格".localized());
                    return
                }
                if (lossOrder?.px ?? "0").greaterThan(entity.earlyWarningPx) {
                    let alert = KRNormalAlert()
                    let earlyWarningPx = entity.earlyWarningPx ?? "0"
                    alert.configAlert(title: "", message: "止损触发价格或执行价格高于预警价格 \(earlyWarningPx)，可能会导致止损失败，是否继续提交？", passiveBtnTitle: "取消", positiveBtnTitle: "继续提交")
                    alert.alertCallback = {[weak self] tag in
                        if tag == 0 {
                            self?.submitOrderOrCancelOrder(profitOrder,lossOrder)
                        }
                    }
                    EXAlert.showAlert(alertView: alert)
                    return
                }
            }
        }
        submitOrderOrCancelOrder(profitOrder,lossOrder)
    }
    
    // 提交或者取消订单
    func submitOrderOrCancelOrder(_ profitOrder: BTContractOrderModel?,_ lossOrder: BTContractOrderModel?) {
        if profitOrder != nil {
            submitOrder(profitOrder!)
        } else {
            if stopProfitOrder != nil && profitV.editBtn.isSelected == false {
                cancelOrders(stopProfitOrder!)
            }
        }
        if lossOrder != nil {
            submitOrder(lossOrder!)
        } else {
            if stopLossOrder != nil && lossV.editBtn.isSelected == false {
                cancelOrders(stopLossOrder!)
            }
        }
    }
    
    
    /// 创建止盈单
    private func takeProfitOrder() -> (profit: BTContractOrderModel?, hasError:Bool)  {
        let tigg_px = self.profitV.editInput.input.text ?? "0"
        let ex_px = self.profitV.editInput2.input.text ?? "0"
        if tigg_px.greaterThan("0") && (self.profitV.isMarket || ex_px.greaterThan("0")) &&
            ((tigg_px != self.stopProfitOrder?.px) ||
            (ex_px != self.stopProfitOrder?.exec_px)) {
            let side = (positionModel!.side == .openMore) ? BTContractOrderWay.sell_CloseLong : BTContractOrderWay.buy_CloseShort
            let pxWay = BTContractOrderPriceType.tradePriceType
            var trend = BTContractOrderPriceWay.up
            // 触发标准
            let tiggerStandardS = positionModel!.lastPrice
            if (tigg_px.lessThan(tiggerStandardS)) { // 计划价格低于触发标准价格
                trend = .down;
            } else if (tigg_px.greaterThan(tiggerStandardS)) {
                trend = .up;
            } else {
                trend = .up;
            }
            /// 价格合理判断
            if positionModel?.side == .openMore { // 多头仓位 止盈
                if tigg_px.lessThan(tiggerStandardS) {
                    EXAlert.showFail(msg: "止盈价格需要高于当前最新价")
                    return (nil,true)
                }
            } else if positionModel?.side == .openEmpty { // 空头仓位 止盈
                if tigg_px.greaterThan(tiggerStandardS) {
                    EXAlert.showFail(msg:"止盈价格需要低于当前最新价")
                    return (nil,true)
                }
            }
            var exec_px = ex_px
            var category = BTContractOrderCategory.normal
            if self.profitV.isMarket {
                category = .market
                exec_px = ""
            }
            let profitOrder = BTContractOrderModel.createPlanProfitOrLossOrder(withContractId: positionModel!.instrument_id,
                                                                               category: category,
                                                                                     way: side,
                                                                                     trigger_type: pxWay,
                                                                                     trend: trend,
                                                                                     exec_px: exec_px,
                                                                                     cycle: cy,
                                                                                     positionID: positionModel!.pid,
                                                                                     profitOrLossType: .profitType,
                                                                                     price: tigg_px)
            return (profitOrder,false)
        }
        return (nil,false)
    }
    
    /// 创建止损单
    private func takeLossOrder() -> (loss:BTContractOrderModel?,hasError:Bool) {
        let tigg_px = self.lossV.editInput.input.text ?? "0"
        let ex_px = self.lossV.editInput2.input.text ?? "0"
        if tigg_px.greaterThan("0") && (self.lossV.isMarket || ex_px.greaterThan("0")) &&
            ((tigg_px != self.stopLossOrder?.px) &&
            (ex_px != self.stopLossOrder?.exec_px)) {
            let side = (positionModel!.side == .openMore) ? BTContractOrderWay.sell_CloseLong : BTContractOrderWay.buy_CloseShort
            let pxWay = BTContractOrderPriceType.tradePriceType
            var trend = BTContractOrderPriceWay.up
            // 触发标准
            let tiggerStandardS = positionModel!.lastPrice
            if (tigg_px.lessThan(tiggerStandardS)) { // 计划价格低于当前价格
                trend = .down;
            } else if (tigg_px.greaterThan(tiggerStandardS)) {
                trend = .up;
            } else {
                trend = .up;
            }
            /// 价格合理判断
            if positionModel?.side == .openMore { // 多头仓位 止损
                if tigg_px.greaterThan(tiggerStandardS) {
                    EXAlert.showFail(msg: "止损价格需要低于当前最新价")
                    return (nil,true)
                }
            } else if positionModel?.side == .openEmpty { // 空头仓位 止损
                if tigg_px.lessThan(tiggerStandardS) {
                    EXAlert.showFail(msg:"止损价格需要高于当前最新价")
                    return (nil,true)
                }
            }
            var exec_px = ex_px
            var category = BTContractOrderCategory.normal
            if self.lossV.isMarket {
                category = .market
                exec_px = ""
            }
            let lossOrder = BTContractOrderModel.createPlanProfitOrLossOrder(withContractId: positionModel!.instrument_id,
                                                                             category: category,
                                                                                     way: side,
                                                                                     trigger_type: pxWay,
                                                                                     trend: trend,
                                                                                     exec_px: exec_px,
                                                                                     cycle: cy,
                                                                                     positionID: positionModel!.pid,
                                                                                     profitOrLossType: .lossType,
                                                                                     price: tigg_px)
            return (lossOrder,false)
        }
        return (nil,false)
    }
}


extension KRProfitOrLossSheet {
    // 提交止盈止损单
    private func submitOrder(_ order : BTContractOrderModel) {
        submitCount += 1
        BTContractTool.submitProfitOrLossOrder(order, assetPassword: nil, success: {[weak self] (idx) in
            guard let mySelf = self else {return}
            mySelf.submitCount -= 1
            if mySelf.submitCount == 0 {
                mySelf.clickStopProfitLossBlock?(true)
            }
        }) {[weak self] (error) in
            guard let mySelf = self else {return}
            mySelf.submitCount -= 1
            guard let errStr = error as? String else {
                return
            }
            EXAlert.showFail(msg: errStr)
        }
    }
    // 取消止盈止损单
    private func cancelOrders(_ order : BTContractOrderModel) {
        submitCount += 1
        BTContractTool.cancelProfitOrLossOrder(order, assetPassword: nil, success: {[weak self] (idx) in
            guard let mySelf = self else {return}
            mySelf.submitCount -= 1
            if mySelf.submitCount == 0 {
                mySelf.clickStopProfitLossBlock?(true)
            }
        }) {[weak self] (error) in
            guard let mySelf = self else {return}
            mySelf.submitCount -= 1
            guard let errStr = error as? String else {
                return
            }
            EXAlert.showFail(msg: errStr)
        }
    }
}
