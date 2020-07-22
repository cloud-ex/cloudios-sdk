//
//  KRCalculatorSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/25.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRCalculatorSheet: KRSwapBaseSheet {
    var calculatorType : Int = 0
    var leveageType : Int = 0
    var sideType : Int = 0
    
    var itemModel : BTItemModel? {
        didSet {
            handleCalculatorType(0)
        }
    }
    
    var less_qty = ""
    
    var most_qty = ""
    
    lazy var calculatorTypeV : UISegmentedControl = {
        let object = UISegmentedControl.init(titles: ["盈亏计算".localized(),"目标收益率".localized(),"强平价格".localized()])
        return object
    }()
    lazy var leveageTypeV : UISegmentedControl = {
        let object = UISegmentedControl.init(titles: ["逐仓".localized(),"全仓".localized()])
        _ = object.rx.value.asObservable()
            .subscribe(onNext: { [weak self] tag in
                self?.leveageType = tag
            }).disposed(by: disposeBag)
        object.isHidden = true
        return object
    }()
    lazy var sideTypeV : UISegmentedControl = {
        let object = UISegmentedControl.init(titles: ["多".localized(),"空".localized()])
        _ = object.rx.value.asObservable()
            .subscribe(onNext: { [weak self] tag in
                self?.sideType = tag
            }).disposed(by: disposeBag)
        return object
    }()
    lazy var resultInfoV : KRSheetInfoView = {
        let object = KRSheetInfoView()
        object.setLeftLabel("保证金".localized())
        object.rightBtn.bottomLine.isHidden = true
        return object
    }()
    lazy var resultInfoV1 : KRSheetInfoView = {
        let object = KRSheetInfoView()
        object.setLeftLabel("收益".localized())
        object.rightBtn.bottomLine.isHidden = true
        return object
    }()
    lazy var resultInfoV2 : KRSheetInfoView = {
        let object = KRSheetInfoView()
        object.setLeftLabel("收益率".localized())
        object.rightBtn.bottomLine.isHidden = true
        return object
    }()
    lazy var leveageInput : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .baseLine)
        object.titleLabel.text = "杠杆倍数".localized()
        object.setPlaceHolder(placeHolder: object.titleLabel.text!, font: 16)
        object.input.placeholder = object.titleLabel.text
        object.input.keyboardType = .decimalPad
        object.extraLabel.text = "X"
        return object
    }()
    lazy var openQty : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .baseLine)
        object.titleLabel.text = "开仓数量".localized()
        object.setPlaceHolder(placeHolder: object.titleLabel.text!, font: 16)
        object.input.placeholder = object.titleLabel.text
        object.input.keyboardType = .decimalPad
        object.extraLabel.text = "张".localized()
        return object
    }()
    lazy var openPx : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .baseLine)
        object.titleLabel.text = "开仓价格".localized()
        object.setPlaceHolder(placeHolder: object.titleLabel.text!, font: 16)
        object.input.placeholder = object.titleLabel.text
        object.input.keyboardType = .decimalPad
        object.extraLabel.text = "USDT"
        return object
    }()
    lazy var repayRate : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .baseLine)
        object.titleLabel.text = "平仓价格".localized()
        object.setPlaceHolder(placeHolder: object.titleLabel.text!, font: 16)
        object.input.placeholder = object.titleLabel.text
        object.input.keyboardType = .decimalPad
        object.extraLabel.text = "USDT"
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = calculatorTypeV.rx.value.asObservable()
        .subscribe(onNext: { [weak self] tag in
            self?.handleCalculatorType(tag)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        contentView.addSubViews([calculatorTypeV,leveageTypeV,sideTypeV,resultInfoV,resultInfoV1,resultInfoV2,leveageInput,openQty,openPx,repayRate])
        calculatorTypeV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(32)
        }
        resultInfoV.snp.makeConstraints { (make) in
            make.left.right.equalTo(calculatorTypeV)
            make.height.equalTo(40)
            make.top.equalTo(calculatorTypeV.snp.bottom).offset(20)
        }
        leveageTypeV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(calculatorTypeV)
            make.top.equalTo(resultInfoV.snp.bottom).offset(20)
        }
        resultInfoV1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(resultInfoV)
            make.top.equalTo(resultInfoV.snp.bottom)
        }
        resultInfoV2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(resultInfoV)
            make.top.equalTo(resultInfoV1.snp.bottom)
        }
        sideTypeV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(calculatorTypeV)
            make.top.equalTo(resultInfoV.snp.bottom).offset(100)
        }
        leveageInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(calculatorTypeV)
            make.height.equalTo(56)
            make.top.equalTo(sideTypeV.snp.bottom).offset(16)
        }
        openQty.snp.makeConstraints({ (make) in
            make.left.right.height.equalTo(leveageInput)
            make.top.equalTo(leveageInput.snp.bottom)
        })
        openPx.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(leveageInput)
            make.top.equalTo(openQty.snp.bottom)
        }
        repayRate.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(leveageInput)
            make.top.equalTo(openPx.snp.bottom)
            make.bottom.equalToSuperview().offset(-10)
        }
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(500)
        }
        nameLabel.text = "计算器".localized()
        submitBtn.setTitle("计算".localized(), for: .normal)
    }
    
    override func clickSubmitBtn(_ sender: EXButton) {
        guard let leverage = leveageInput.input.text,leverage.length > 0,
            let qty = openQty.input.text, qty.length > 0,
            let px = openPx.input.text, px.length > 0,
            let markPrice = repayRate.input.text, markPrice.length > 0 else {
            return
        }
        guard let entity = self.itemModel else {
            return
        }
        let pxUnit = " "+entity.contractInfo.quote_coin ?? ""
        let valUnit = " "+entity.contractInfo.margin_coin ?? ""
        let order = BTContractOrderModel()
        order.position_type = (leveageType == 0) ? .pursueType : .allType
        order.qty = qty
        order.px = px
        order.leverage = leverage
        order.instrument_id = entity.instrument_id
        if sideType == 0 {
            order.side = BTContractOrderWay.buy_OpenLong
        } else {
            order.side = BTContractOrderWay.sell_OpenShort
        }
        let openModel = BTContractsOpenModel.init(orderModel: order, contractInfo: itemModel?.contractInfo ?? nil, assets: nil)
        if calculatorTypeV.selectedSegmentIndex == 0 {
            var profit = "0"
            if sideType == 0 {
                profit = SLFormula.calculateCloseLongProfitAmount(order.qty, holdAvgPrice: order.px, markPrice: markPrice, contractSize: entity.contractInfo.face_value, isReverse: entity.contractInfo!.is_reverse).toSmallValue(withContract: entity.instrument_id)
            } else {
                profit = SLFormula.calculateCloseShortProfitAmount(order.qty, holdAvgPrice: order.px, markPrice: markPrice, contractSize: entity.contractInfo!.face_value, isReverse: entity.contractInfo!.is_reverse).toSmallValue(withContract: entity.instrument_id)
            }
            var deposit = openModel?.im ?? "0"
            if "1".bigDiv(order.leverage).greaterThan(order.imr) {
                deposit = openModel!.orderAvai.bigMul("1".bigDiv(order.leverage))
            }
            deposit = deposit.toSmallValue(withContract: entity.instrument_id)+pxUnit
            let value = ((openModel?.orderAvai ?? "0").toSmallValue(withContract: entity.instrument_id) ?? "0")+valUnit
            let rate = profit.bigDiv(deposit).toPercentString(2) ?? "0.00 %"
            updataInfo(deposit, value, profit, rate)
        } else if calculatorTypeV.selectedSegmentIndex == 1 {
            var deposit = openModel?.im ?? "0"
            var value = (openModel?.orderAvai ?? "0").toSmallValue(withContract:entity.instrument_id) ?? "0"
            if DecimalOne.bigDiv(order.leverage).greaterThan(order.leverage) {
                deposit = value.bigMul(DecimalOne.bigDiv(order.leverage))
            }
            deposit = deposit.toSmallValue(withContract: entity.instrument_id)+valUnit
            if entity.contractInfo.is_reverse {
                if sideType == 0 {
                    value = value.bigAdd(markPrice)
                } else {
                    value = value.bigSub(markPrice)
                }
            } else {
                if sideType == 0 {
                    value = value.bigSub(markPrice)
                } else {
                    value = value.bigAdd(markPrice)
                }
            }
            let targetPrice = (SLFormula.calculateQuotePrice(withValue: value, vol: order.qty, contract: entity.contractInfo!).toSmallPrice(withContractID:entity.instrument_id) ?? "0")+pxUnit
            updataInfo(targetPrice, deposit,"","")
        } else if calculatorTypeV.selectedSegmentIndex == 2 {
            let closePx = (openModel?.liquidatePrice ?? "0")+pxUnit
            let value = (openModel?.orderAvai ?? "0").toSmallValue(withContract: entity.instrument_id) ?? "0"
            let start = order.imr.bigDiv("100").toPercentString(2) ?? "0.00 %"
            let end = order.mmr.toPercentString(2) ?? "0.00 %"
            updataInfo(closePx, value, start, end)
        }
    }
}

extension KRCalculatorSheet {
    
    // MARK:- interface
    func updataInfo(_ result1 : String, _ result2 : String, _ result3 : String, _ result4 : String) {
        if calculatorTypeV.selectedSegmentIndex == 0 {
            resultInfoV.setRightLabel(result1)
            resultInfoV1.setRightLabel(result2)
            resultInfoV2.setRightLabel(result3)
        } else if calculatorTypeV.selectedSegmentIndex == 1 {
            resultInfoV.setRightLabel(result1)
            resultInfoV1.setRightLabel(result2)
            resultInfoV2.setRightLabel(result3)
        } else if calculatorTypeV.selectedSegmentIndex == 2 {
            resultInfoV.setRightLabel(result1)
        }
    }
    
    func handleCalculatorType(_ type:Int) {
        switch type {
        case 0:
            resultInfoV.setLeftLabel("保证金".localized())
            resultInfoV2.setLeftLabel("收益率".localized())
            resultInfoV1.isHidden = false
            resultInfoV2.isHidden = false
            leveageTypeV.isHidden = true
            openPx.extraLabel.text = itemModel?.contractInfo?.quote_coin ?? "-"
            repayRate.extraLabel.text = itemModel?.contractInfo?.quote_coin ?? "-"
            repayRate.titleLabel.text = "平仓价格".localized()
            repayRate.input.placeholder = repayRate.titleLabel.text
            sideTypeV.snp.remakeConstraints { (make) in
                make.left.right.height.equalTo(calculatorTypeV)
                make.top.equalTo(resultInfoV.snp.bottom).offset(100)
            }
            break
        case 1:
            resultInfoV.setLeftLabel("平仓价格".localized())
            resultInfoV1.setLeftLabel("占用保证金".localized())
            resultInfoV1.isHidden = false
            resultInfoV2.isHidden = true
            leveageTypeV.isHidden = true
            openPx.extraLabel.text = itemModel?.contractInfo?.quote_coin ?? "-"
            repayRate.extraLabel.text = itemModel?.contractInfo?.margin_coin ?? "-"
            repayRate.titleLabel.text = "收益额".localized()
            repayRate.input.placeholder = repayRate.titleLabel.text
            sideTypeV.snp.remakeConstraints { (make) in
                make.left.right.height.equalTo(calculatorTypeV)
                make.top.equalTo(resultInfoV.snp.bottom).offset(60)
            }
            break
        case 2:
            resultInfoV.setLeftLabel("强平价格".localized())
            resultInfoV1.isHidden = true
            resultInfoV2.isHidden = true
            leveageTypeV.isHidden = false
            openPx.extraLabel.text = itemModel?.contractInfo?.quote_coin ?? "-"
            repayRate.extraLabel.text = "%"
            repayRate.titleLabel.text = "回报率".localized()
            repayRate.input.placeholder = repayRate.titleLabel.text
            sideTypeV.snp.remakeConstraints { (make) in
                make.left.right.height.equalTo(calculatorTypeV)
                make.top.equalTo(resultInfoV.snp.bottom).offset(72)
            }
            break
        default:
            break
        }
    }
}
