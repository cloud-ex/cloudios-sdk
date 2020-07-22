//
//  KRLightOrderSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/22.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRLightOrderSheet: KRSwapBaseSheet {
    
    typealias ClickSwapLightSubmitBlock = (BTContractOrderModel?) -> ()
    var clickSwapLightSubmitBlock : ClickSwapLightSubmitBlock?
    
    var leverage : Int = 10
    
    weak var itemModel : BTItemModel?
    
    var order = BTContractOrderModel()
    
    var globalLeverage : KRLeverageStruct?
    
    var hasGlobalLeverage = false
    
    lazy var tradePxView : KRSheetInfoView = {
        let object = KRSheetInfoView()
        object.setLeftLabel("预估成交价".localized())
        object.setRightLabel("-- USDT")
        object.rightBtn.clickShowTipBlock = {[weak self] in
            guard let mySelf = self else {return}
            mySelf.tipsV.isHidden = false
            mySelf.tipsV.showTips("预估成交价使用对手盘第三档实时变动价格，帮助您确定立刻成交可能的交易价格。闪电模式会以该价格核算提交订单所需信息（价格/张数），并提交高级限价单立即成交或取消，用来保护您的订单成交价格不被偏离，在大部分情况实际成交价小于等于该价格".localized(), .topRight(70, 60))
        }
        return object
    }()
    lazy var volumeView : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .baseLine)
        object.titleLabel.text = "下单本金".localized()
        object.setPlaceHolder(placeHolder: "请输入下单本金(最大下单本金5000)".localized(), font: 16)
        object.input.keyboardType = .decimalPad
        object.extraLabel.text = "USDT"
        object.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
             mySelf.textFieldValueHasChanged(textField: object.input)
        }
        return object
    }()
    lazy var leverageLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("杠杆倍数")
        object.setRightText("10X") // 默认杠杆
        return object
    }()
    lazy var levelSlider : KRLevelSlider = {
        let object = KRLevelSlider(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 50), maxLevel: 100)
        return object
    }()
    lazy var globalLeverageTips : UILabel = {
        let object = UILabel.init(text: "当前存在持仓或挂单，暂不能修改杠杆倍数".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.red, alignment: .left)
        object.isHidden = true
        return object
    }()
    lazy var avaiLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("可用余额".localized())
        object.setRightText("0.00 USDT")
        object.leftLabel.font = UIFont.ThemeFont.BodyBold
        return object
    }()
    lazy var fundLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("资金费率".localized())
        object.setRightText("22.22%")
        object.leftLabel.font = UIFont.ThemeFont.BodyBold
        object.addTapLabel()
        object.clickRightLabelBlock = {[weak self] in
            self?.tipsV.isHidden = false
            self?.tipsV.showTips("资金费率为正数，多头仓位向空头仓位支付 仓位价值乘资金费率 的资金费。\r\n资金费率为负数，多头仓位向空头仓位收取 仓位价值乘资金费率 的资金费。".localized(), .bottomRight(20, 80))
        }
        return object
    }()
    
    lazy var dealQtyLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("预估成交数量".localized())
        object.setRightText("100张")
        object.leftLabel.font = UIFont.ThemeFont.BodyBold
        object.addTapLabel()
        object.clickRightLabelBlock = {[weak self] in
            self?.tipsV.isHidden = false
            self?.tipsV.showTips("闪电模式使用永续合约作为底层交易资产，永续合约使用撮合引擎进行订单的接受，仅接受价格与数量进行订单申报。预估成交数量使用预估成交价进行计算，实际成交会小于等于该数量".localized(), .bottomRight(20, 50))
        }
        return object
    }()
    
    lazy var tipsV : KRSheetTipsView = {
        let object = KRSheetTipsView()
        object.isHidden = true
        object.addTap()
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        contentView.addSubViews([tradePxView,volumeView,leverageLabel,levelSlider,globalLeverageTips,avaiLabel,fundLabel,dealQtyLabel,tipsV])
        tradePxView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(16)
        }
        volumeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(tradePxView)
            make.height.equalTo(56)
            make.top.equalTo(tradePxView.snp.bottom).offset(10)
        }
        leverageLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.height.equalTo(30)
            make.top.equalTo(volumeView.snp.bottom).offset(16)
        }
        levelSlider.snp.makeConstraints { (make) in
            make.left.right.equalTo(tradePxView)
            make.height.equalTo(40)
            make.top.equalTo(leverageLabel.snp.bottom).offset(15)
        }
        globalLeverageTips.snp.makeConstraints { (make) in
            make.left.right.equalTo(tradePxView)
            make.height.equalTo(16)
            make.top.equalTo(levelSlider.snp.bottom).offset(5)
        }
        avaiLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(leverageLabel)
            make.top.equalTo(levelSlider.snp.bottom).offset(10)
        }
        fundLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(leverageLabel)
            make.top.equalTo(avaiLabel.snp.bottom)
        }
        dealQtyLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(leverageLabel)
            make.top.equalTo(fundLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-20)
        }
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(360)
        }
        tipsV.snp.makeConstraints { (make) in
            make.left.right.equalTo(tradePxView)
            make.top.bottom.equalToSuperview()
        }
        submitBtn.setTitle("闪电开仓", for: .normal)
        self.levelSlider.valueChangedCallback = {[weak self] value in
            self?.leverage = value
            self?.leverageLabel.setRightText(String(value)+"X")
            self?.carculateDealVolume()
        }
    }
    
    override func clickSubmitBtn(_ sender: EXButton) {
        super.clickSubmitBtn(sender)
        let asset = SLPersonaSwapInfo.sharedInstance()?.getSwapAssetItem(withCoin: order.contractInfo.margin_coin)
        if (volumeView.input.text?.kr_length ?? 0) <= 0 {
            EXAlert.showWarning(msg: "请输入下单本金".localized())
            return
        } else if ((volumeView.input.text ?? "0").greaterThan(asset?.contract_avail)) {
            EXAlert.showWarning(msg: "超过最大可用金额".localized())
            return
        }
        // 如果当前杠杆跟全局杠杆不同则先设置杠杆
        if order.leverage != globalLeverage?.leverage {
            let model = (order.position_type == .allType) ? KRLeverageModel.full : KRLeverageModel.staged
            KRLeverageManager.shared.setGlobalLeverage(instrumentId: order.instrument_id, leverage: UInt8(self.leverage), leverageModel: model, successCallback: {[weak self] (entity) in
                guard let mySelf = self else {return}
                mySelf.clickSwapLightSubmitBlock?(mySelf.order)
            }) { (error) in
                if let errMsg = (error as? String) {
                    DispatchQueue.main.async {
                        EXAlert.showFail(msg: errMsg)
                    }
                } else {
                    DispatchQueue.main.async {
                        EXAlert.showFail(msg: "下单失败，请稍后再试!".localized())
                    }
                }
            }
        } else {
            clickSwapLightSubmitBlock?(order)
        }
    }
}

extension KRLightOrderSheet {
    
    func textFieldValueHasChanged(textField:UITextField) {
        carculateDealVolume()
    }
    
    func configOrder(_ px: String, _ side: BTContractOrderWay,_ entity : BTItemModel?) {
        guard let swapInfo = entity?.contractInfo else {return}
        self.itemModel = entity
        let unitLen = String(swapInfo.value_unit.kr_length-2)
        volumeView.decimal = unitLen
        order.instrument_id = swapInfo.instrument_id
        order.px = px
        order.side = side
        order.category = .market
        if side == .buy_OpenLong {
            nameLabel.text = swapInfo.symbol+"开多".localized()
        } else if side == .sell_OpenShort {
            nameLabel.text = swapInfo.symbol+"开空".localized()
        }
        tradePxView.setRightLabel(px+swapInfo.quote_coin)
        volumeView.extraLabel.text = swapInfo.quote_coin
        let asset = SLPersonaSwapInfo.sharedInstance()?.getSwapAssetItem(withCoin: swapInfo.margin_coin)
        let balance = (asset?.contract_avail.toSmallValue(withContract: swapInfo.instrument_id) ?? "0") + (asset?.coin_code ?? "")
        avaiLabel.setRightText(balance)
        let fundRate = entity?.funding_rate?.toPercentString(2) ?? "-"
        fundLabel.setRightText(fundRate)
        carculateDealVolume()
        globalLeverage = KRLeverageManager.shared.getleverageInfo(swapInfo.instrument_id)
        let leverage = Float(globalLeverage?.leverage ?? "1") ?? 1
        levelSlider.updateSliderValue(value:leverage)
        let orders = SLPersonaSwapInfo.sharedInstance()?.getOrders(swapInfo.instrument_id) ?? []
        let positions = SLPersonaSwapInfo.sharedInstance()?.getPositions(swapInfo.instrument_id) ?? []
        if orders.count > 0 || positions.count > 0 {
            hasGlobalLeverage = true
            levelSlider.slider.isUserInteractionEnabled = false
            levelSlider.isUserInteractionEnabled = false
            globalLeverageTips.isHidden = false
            avaiLabel.snp.remakeConstraints { (make) in
                make.left.right.height.equalTo(leverageLabel)
                make.top.equalTo(levelSlider.snp.bottom).offset(30)
            }
        }
        order.position_type = (globalLeverage?.typeStr == "全仓".localized()) ? .allType :  .pursueType
    }
    
    func carculateDealVolume() {
        guard let entity = itemModel else {return}
        order.leverage = String(self.leverage)
        let orderSize = BTContractTool.getOpenOrderSize(withContractID: entity.instrument_id, side:order.side)
        let qty = SLFormula.calculateVolume(withAsset: volumeView.input.text ?? "0", price: order.px, lever: String(self.leverage), advance: orderSize!, position: BTPositionModel(), positionType: .openMore, contractInfo: entity.contractInfo)
        dealQtyLabel.setRightText(qty.toDecimalString(0) + "张".localized())
        order.qty = qty.toDecimalString(0)
    }
}
