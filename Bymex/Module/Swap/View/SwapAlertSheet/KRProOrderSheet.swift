//
//  KRProfessionOrderSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/22.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRProOrderSheet: KRSwapBaseSheet {
    
    typealias ClickProOrderSubmitBlock = (BTProfitOrLossModel?) -> ()
    var clickProOrderSubmitBlock : ClickProOrderSubmitBlock?
    
    weak var order : BTContractOrderModel?
    var itemModel : BTItemModel?
    var itemBS: BehaviorSubject<BTItemModel> = KRSwapSDKManager.shared.currentBS
    
    var isProfitMarket = true
    var isLossMarket = true
    
    lazy var stopProfitOrLoss : KRTipBtn = {
        let object = KRTipBtn()
        object.titleLabel.font = UIFont.ThemeFont.BodyRegular
        object.setTitle("止盈止损")
        object.layoutBottomLine()
        object.clickShowTipBlock = {[weak self] in
            guard let mySelf = self else {return}
            mySelf.tipsV.isHidden = false
            mySelf.tipsV.showTips("当开启止损/止盈需要设定触发价格，当最新价格到达触发价格，以市价单平仓100%仓位".localized(), .topLeft(30, 50))
        }
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
        object.profitOrLossViewback = {[weak self] isMarket in
            self?.isProfitMarket = isMarket
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
        object.profitOrLossViewback = {[weak self] isMarket in
            self?.isLossMarket = isMarket
            guard let mySelf = self else{return}
            mySelf.textFieldValueHasChanged(textField: object.editInput2.input)
        }
        return object
    }()
    lazy var lastPxLabel : UILabel = {
        let object = UILabel.init(text: "最新价".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .right)
        return object
    }()
    lazy var lastValueLabel : UILabel = {
        let object = UILabel.init(text: "--".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .right)
        return object
    }()
    lazy var closePxLabel : UILabel = {
        let object = UILabel.init(text: "预估强平价".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .right)
        return object
    }()
    lazy var closeValueLabel : UILabel = {
        let object = UILabel.init(text: "--".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
        return object
    }()
    lazy var middleLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    lazy var forceTipsLabel : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.red, alignment: .left)
        object.numberOfLines = 0
        object.isHidden = true
        return object
    }()
    lazy var priceV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("价格".localized())
        return object
    }()
    lazy var volumeV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("数量".localized())
        return object
    }()
    lazy var leverageV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("杠杆".localized())
        return object
    }()
    lazy var valueV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("委托价值".localized())
        return object
    }()
    lazy var costV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("委托成本".localized())
        return object
    }()
    lazy var positionV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("成交后仓位".localized())
        return object
    }()
    lazy var remindBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("不再显示", 14, UIColor.ThemeLabel.colorMedium, .normal)
        object.extSetImages([UIImage.themeImageNamed(imageName: "swap_board_unSelected"),UIImage.themeImageNamed(imageName: "swap_board_selected")], controlStates: [.normal,.selected])
        object.extSetAddTarget(self, #selector(clickRemindBtn))
        object.imageView?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        })
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
        contentView.addSubViews([stopProfitOrLoss,
                                 profitV,lossV,
                                 middleLine,forceTipsLabel,
                                 priceV,volumeV,leverageV,valueV,costV,positionV,
                                 remindBtn,
                                 tipsV,
                                 lastPxLabel,lastValueLabel,closePxLabel,closeValueLabel])
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(470)
        }
        contentView.isScrollEnabled = true
        stopProfitOrLoss.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(200)
        }
        closeValueLabel.snp.makeConstraints { (make) in
            make.right.equalTo(SCREEN_WIDTH - 16)
            make.height.equalTo(16)
            make.centerY.equalTo(stopProfitOrLoss)
            make.width.lessThanOrEqualTo(80)
        }
        closePxLabel.snp.makeConstraints { (make) in
            make.right.equalTo(closeValueLabel.snp.left).offset(-2)
            make.height.centerY.equalTo(closeValueLabel)
            make.width.lessThanOrEqualTo(80)
        }
        lastValueLabel.snp.makeConstraints { (make) in
            make.right.equalTo(closePxLabel.snp.left).offset(-5)
            make.height.centerY.equalTo(closeValueLabel)
            make.width.lessThanOrEqualTo(80)
        }
        lastPxLabel.snp.makeConstraints { (make) in
            make.right.equalTo(lastValueLabel.snp.left).offset(-2)
            make.height.centerY.equalTo(closeValueLabel)
            make.width.lessThanOrEqualTo(80)
        }
        profitV.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.top.equalTo(stopProfitOrLoss.snp.bottom).offset(22)
        }
        lossV.snp.makeConstraints { (make) in
            make.left.right.equalTo(profitV)
            make.top.equalTo(profitV.snp.bottom).offset(10)
        }
        middleLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(profitV)
            make.top.equalTo(lossV.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        forceTipsLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(middleLine)
            make.top.equalTo(middleLine.snp.bottom).offset(16)
            make.height.equalTo(16)
        }
        priceV.snp.makeConstraints { (make) in
            make.left.right.equalTo(middleLine)
            make.height.equalTo(30)
            make.top.equalTo(middleLine.snp.bottom).offset(16)
        }
        volumeV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(priceV)
            make.top.equalTo(priceV.snp.bottom)
        }
        leverageV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(priceV)
            make.top.equalTo(volumeV.snp.bottom)
        }
        valueV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(priceV)
            make.top.equalTo(leverageV.snp.bottom)
        }
        costV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(priceV)
            make.top.equalTo(valueV.snp.bottom)
        }
        positionV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(priceV)
            make.top.equalTo(costV.snp.bottom)
        }
        remindBtn.snp.makeConstraints { (make) in
            make.left.equalTo(stopProfitOrLoss)
            make.height.equalTo(32)
            make.width.lessThanOrEqualTo(100)
            make.top.equalTo(positionV.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-20)
        }
        tipsV.snp.makeConstraints { (make) in
            make.left.right.equalTo(profitV)
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        itemBS.asObserver().subscribe(onNext: {[weak self] (itemModel) in
            guard let mySelf = self else {return}
            mySelf.itemModel = itemModel
            if itemModel.trend == .up {
                mySelf.lastValueLabel.textColor = UIColor.ThemekLine.up
            } else {
                mySelf.lastValueLabel.textColor = UIColor.ThemekLine.down
            }
            mySelf.lastValueLabel.text = itemModel.last_px ?? "0"
            mySelf.closeValueLabel.text =  mySelf.order?.liquidatePrice.toSmallEditPriceContractID(mySelf.order?.instrument_id ?? 0) ?? "0"
        }).disposed(by: self.disposeBag)
    }
}

extension KRProOrderSheet {
    
    override func clickSubmitBtn(_ sender: EXButton) {
        self.handleProfitOrLoss()
    }
    
    @objc func clickRemindBtn(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        XUserDefault.setComfirmSwapAlert(!sender.isSelected)
    }
    
    public func configOrder(_ order : BTContractOrderModel) {
        self.order = order
        let priceUnit = order.contractInfo?.quote_coin ?? ""
        let valueUnit = order.contractInfo?.margin_coin ?? ""
        if order.contractInfo.px_unit.kr_length > 3 {
            let decimal = String(order.contractInfo.px_unit.kr_length - 3)
            profitV.setDecimal(decimal)
            lossV.setDecimal(decimal)
        } else {
            profitV.setDecimal("0")
            lossV.setDecimal("0")
        }
        closeValueLabel.text = order.liquidatePrice.toSmallEditPriceContractID(order.instrument_id) ?? "0"
        var titleStr = "限价单".localized()
        if order.category == .market {
            priceV.setRightText("市价")
            titleStr = "市价单".localized()
        } else {
            if order.time_in_force?.intValue ?? 0 > 0 {
                titleStr = "高级限价单".localized()
            }
            let px = (order.px?.toSmallEditPriceContractID(order.instrument_id) ?? "0")+" "+priceUnit
            priceV.setRightText(px)
        }
        
        if order.side == .buy_OpenLong {
            titleStr = titleStr + "买入".localized()
        } else {
            titleStr = titleStr + "卖出".localized()
        }
        nameLabel.text = titleStr
        let vol = (order.qty.toSmallVolume(withContractID: order.instrument_id) ?? "0")+"张".localized()
        volumeV.setRightText(vol)
        let leStr = (order.leverage ?? "")+"X"
        leverageV.setRightText(leStr)
        let valueStr = (order.avai.toSmallValue(withContract: order.instrument_id) ?? "0") + " " + valueUnit
        valueV.setRightText(valueStr)
        let costStr = (order.freezAssets.toSmallValue(withContract: order.instrument_id) ?? "0") + " " + valueUnit
        costV.setRightText(costStr)
        let itemModel = BTItemModel()
        itemModel.instrument_id = order.instrument_id
        let position = SLFormula.getUserPosition(with: itemModel, contractWay: order.side)
        var holdVol = order.qty ?? "0"
        holdVol = holdVol.bigAdd(position.cur_qty ?? "0")
        positionV.setRightText(holdVol+"张".localized())
        
        if order.forceTips.kr_length > 0 {
            forceTipsLabel.isHidden = false
            forceTipsLabel.text = order.forceTips
            priceV.snp.remakeConstraints { (make) in
                make.left.right.equalTo(middleLine)
                make.height.equalTo(30)
                make.top.equalTo(forceTipsLabel.snp.bottom).offset(10)
            }
        }
    }
    
    func handleProfitOrLoss() {
        let plOrder = BTProfitOrLossModel()
        if profitV.editBtn.isSelected {
            if let px = profitV.editInput.input.text ,px != "" {
                plOrder.profit_price_type = .tradePriceType
                plOrder.missionType = .SWAPMISSIONORDER_TYPE_PROFIT
                plOrder.profit_price = px
                if isProfitMarket {
                    plOrder.profit_category = 2
                    if plOrder.profit_price.kr_length <= 0 {
                        plOrder.missionType = .SWAPMISSIONORDER_TYPE_NONE
                    }
                } else {
                    plOrder.profit_category = 1
                    plOrder.profit_ex_price = profitV.editInput2.input.text ?? ""
                    if plOrder.profit_ex_price.kr_length <= 0 || plOrder.profit_price.kr_length <= 0 {
                        plOrder.missionType = .SWAPMISSIONORDER_TYPE_NONE
                    }
                }
            }
        }
        if lossV.editBtn.isSelected {
            if let px = lossV.editInput.input.text , px != "" {
                if plOrder.missionType == .SWAPMISSIONORDER_TYPE_NONE {
                    plOrder.missionType = .SWAPMISSIONORDER_TYPE_LOSS
                } else {
                    plOrder.missionType = .SWAPMISSIONORDER_TYPE_ALL
                }
                plOrder.loss_price_type = .tradePriceType
                plOrder.loss_price = px
                if isLossMarket {
                    plOrder.loss_category = 2
                    if plOrder.loss_price.kr_length <= 0 {
                        if plOrder.missionType == .SWAPMISSIONORDER_TYPE_LOSS {
                            plOrder.missionType = .SWAPMISSIONORDER_TYPE_NONE
                        } else {
                            plOrder.missionType = .SWAPMISSIONORDER_TYPE_PROFIT
                        }
                    }
                } else {
                    plOrder.loss_category = 1
                    plOrder.loss_ex_price = lossV.editInput2.input.text ?? ""
                    if plOrder.loss_ex_price.kr_length <= 0 || plOrder.loss_price.kr_length <= 0 {
                        if plOrder.missionType == .SWAPMISSIONORDER_TYPE_LOSS {
                            plOrder.missionType = .SWAPMISSIONORDER_TYPE_NONE
                        } else {
                            plOrder.missionType = .SWAPMISSIONORDER_TYPE_PROFIT
                        }
                    }
                }
            }
        }
        if plOrder.missionType == .SWAPMISSIONORDER_TYPE_NONE {
            self.clickProOrderSubmitBlock?(nil)
        } else {
            if plOrder.missionType.rawValue > 1 {
                // 预警价格筛选
                if order?.side == .buy_OpenLong {
                    if (plOrder.loss_price ?? "0").lessThan(order?.liquidatePrice ?? "0") {
                        EXAlert.showFail(msg: "止损触发价格和执行价格需要高于强平价格".localized());
                        return
                    }
                } else {
                    if (plOrder.loss_price ?? "0").greaterThan(order?.liquidatePrice ?? "0") {
                        EXAlert.showFail(msg: "止损触发价格和执行价格需要低于强平价格".localized());
                        return
                    }
                }
            }
            self.clickProOrderSubmitBlock?(plOrder)
        }
    }
    
    func textFieldValueHasChanged(textField:UITextField) {
        if textField == profitV.editInput.input {
            if isProfitMarket {
                if profitV.editInput.input.text?.length ?? 0 > 0 {
                    profitV.tipsLabel.isHidden = false
                    SLFormula.carculateOrderAnticipateProfit(self.order!, performPrice: profitV.editInput.input.text!) {[weak self] (value, rate) in
                        let valueStr = value.toSmallValue(withContract:self?.order?.instrument_id ?? 0) ?? "0"
                        let rateStr = rate.toPercentString(2) ?? "0"
                        let tipsStr = String(format: "预计盈利 %@ %@，回报率 %@", valueStr,self?.order?.contractInfo.margin_coin ?? "-",rateStr)
                        self?.profitV.tipsLabel.text = tipsStr
                    }
                } else {
                    profitV.tipsLabel.isHidden = true
                }
            }
        } else if textField == lossV.editInput.input {
            if isLossMarket {
                if lossV.editInput.input.text?.length ?? 0 > 0 {
                    lossV.tipsLabel.isHidden = false
                    SLFormula.carculateOrderAnticipateLoss(self.order!, performPrice: lossV.editInput.input.text!) {[weak self] (value, rate) in
                        let valueStr = value.toSmallValue(withContract:self?.order?.instrument_id ?? 0) ?? "0"
                        let rateStr = rate.toPercentString(2) ?? "0"
                        let tipsStr = String(format: "预计亏损 -%@ %@，回报率 -%@", valueStr,self?.order?.contractInfo.margin_coin ?? "-",rateStr)
                        self?.lossV.tipsLabel.text = tipsStr
                    }
                } else {
                    lossV.tipsLabel.isHidden = true
                }
            }
        } else if textField == profitV.editInput2.input {
            if isProfitMarket { // 市价执行止盈
                if profitV.editInput.input.text?.length ?? 0 > 0 {
                    profitV.tipsLabel.isHidden = false
                    SLFormula.carculateOrderAnticipateProfit(self.order!, performPrice: profitV.editInput.input.text!) {[weak self] (value, rate) in
                        let valueStr = value.toSmallValue(withContract:self?.order?.instrument_id ?? 0) ?? "0"
                        let rateStr = rate.toPercentString(2) ?? "0"
                        let tipsStr = String(format: "预计盈利 %@ %@，回报率 %@", valueStr,self?.order?.contractInfo.margin_coin ?? "-",rateStr)
                        self?.profitV.tipsLabel.text = tipsStr
                    }
                } else {
                    profitV.tipsLabel.isHidden = true
                }
            } else {
                if textField.text?.length ?? 0 > 0 {
                    profitV.tipsLabel.isHidden = false
                    SLFormula.carculateOrderAnticipateProfit(self.order!, performPrice: textField.text!) {[weak self] (value, rate) in
                        let valueStr = value.toSmallValue(withContract:self?.order?.instrument_id ?? 0) ?? "0"
                        let rateStr = rate.toPercentString(2) ?? "0"
                        let tipsStr = String(format: "预计盈利 %@ %@，回报率 %@", valueStr,self?.order?.contractInfo.margin_coin ?? "-",rateStr)
                        self?.profitV.tipsLabel.text = tipsStr
                    }
                } else {
                    profitV.tipsLabel.isHidden = true
                }
            }
        } else if textField == lossV.editInput2.input {
            if isLossMarket { // 市价执行止损
                if lossV.editInput.input.text?.length ?? 0 > 0 {
                    lossV.tipsLabel.isHidden = false
                    SLFormula.carculateOrderAnticipateLoss(self.order!, performPrice: lossV.editInput.input.text!) {[weak self] (value, rate) in
                        let valueStr = value.toSmallValue(withContract:self?.order?.instrument_id ?? 0) ?? "0"
                        let rateStr = rate.toPercentString(2) ?? "0"
                        let tipsStr = String(format: "预计亏损 -%@ %@，回报率 -%@", valueStr,self?.order?.contractInfo.margin_coin ?? "-",rateStr)
                        self?.lossV.tipsLabel.text = tipsStr
                    }
                } else {
                    lossV.tipsLabel.isHidden = true
                }
            } else {
                if textField.text?.length ?? 0 > 0 {
                    lossV.tipsLabel.isHidden = false
                    SLFormula.carculateOrderAnticipateLoss(self.order!, performPrice: textField.text!) {[weak self] (value, rate) in
                        let valueStr = value.toSmallValue(withContract:self?.order?.instrument_id ?? 0) ?? "0"
                        let rateStr = rate.toPercentString(2) ?? "0"
                        let tipsStr = String(format: "预计亏损 -%@ %@，回报率 -%@", valueStr,self?.order?.contractInfo.margin_coin ?? "-",rateStr)
                        self?.lossV.tipsLabel.text = tipsStr
                    }
                } else {
                    lossV.tipsLabel.isHidden = true
                }
            }
        }
    }
}

class KRProfitOrLossView: KRBaseV {
    
    typealias ProfitOrLossViewback = (Bool) -> ()
    var profitOrLossViewback : ProfitOrLossViewback?
    
    var isMarket : Bool = true
    
    lazy var editBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("止盈".localized(), 16, UIColor.ThemeLabel.colorDark, UIColor.ThemeLabel.colorHighlight)
        object.extSetImages([UIImage.themeImageNamed(imageName: "swap_board_unSelected"),UIImage.themeImageNamed(imageName: "swap_board_selected")], controlStates: [.normal,.selected])
        object.extSetAddTarget(self, #selector(clickEditBtn))
        object.imageView?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        })
        return object
    }()
    lazy var editInput : KRBorderField = {
        let object = KRBorderField()
        object.setPlaceHolder(placeHolder: "请输入触发价格".localized(), font: 16)
        object.isUserInteractionEnabled = false
        return object
    }()
    lazy var editInput2 : KRBorderField = {
        let object = KRBorderField()
        object.setPlaceHolder(placeHolder: "请输入执行价格".localized(), font: 16)
        object.unitLabel.extSetText("市价".localized(), textColor: UIColor.ThemeLabel.colorHighlight, fontSize: 14)
        object.unitLabel.isUserInteractionEnabled = true
        object.isHidden = true
        let tapGesture = UITapGestureRecognizer()
        object.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: {[weak self] recognizer in
            guard let mySelf = self else {return}
            mySelf.isMarket = !mySelf.isMarket
            mySelf.percentLabel.isHidden = !mySelf.isMarket
            mySelf.profitOrLossViewback?(mySelf.isMarket)
        }).disposed(by: disposeBag)
        return object
    }()
    lazy var tipsLabel : UILabel = {
        let object = UILabel.init(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.isHidden = true
        return object
    }()
    
    lazy var percentLabel : KRSpaceLabel = {
        let object = KRSpaceLabel.init(text: "市价".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        object.showTapLabel()
        object.isHidden = true
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([editBtn,editInput,editInput2,tipsLabel,percentLabel])
        editBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(15)
            make.width.lessThanOrEqualTo(60)
        }
        editInput.snp.makeConstraints { (make) in
            make.left.equalTo(editBtn.snp.right).offset(14)
            make.height.equalTo(44)
            make.centerY.equalTo(editBtn)
            make.right.equalToSuperview().offset(-1)
            make.bottom.equalToSuperview().offset(-1)
        }
        editInput2.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(editInput)
            make.top.equalTo(editInput.snp.bottom).offset(16)
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(editInput)
            make.height.equalTo(16)
            make.top.equalTo(editInput2.snp.bottom).offset(4)
        }
        percentLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(editInput2).offset(1)
            make.bottom.equalTo(editInput2).offset(-1)
            make.right.equalTo(editInput2).offset(-50)
        }
        percentLabel.extSetBorderWidth(1, color: UIColor.clear)
    }
    
    @objc func clickEditBtn(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        editInput.isUserInteractionEnabled = sender.isSelected
        if !sender.isSelected {
            editInput2.isHidden = true
            percentLabel.isHidden = true
            editInput.input.text = ""
            tipsLabel.text = ""
            editInput.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-1)
            }
        } else {
            isMarket = true
            percentLabel.isHidden = false
            editInput2.isHidden = false
            editInput.input.becomeFirstResponder()
            editInput.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-81)
            }
        }
    }
    
    func setMarketStatus(_ status:Bool) {
        if status {
            isMarket = true
            percentLabel.isHidden = false
        } else {
            isMarket = false
            percentLabel.isHidden = true
        }
    }
    
    func setDecimal(_ decimal : String) {
        editInput.decimal = decimal
        editInput2.decimal = decimal
    }
}
