//
//  KRAdjustMarginSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/27.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAdjustMarginSheet: KRSwapBaseSheet {
    
    typealias ClickAdjustMarginBlock = (Bool) -> ()
    var clickAdjustMarginBlock : ClickAdjustMarginBlock?
    
    var positionModel : BTPositionModel?
    
    var asset : BTItemCoinModel? {
        get {
            return SLPersonaSwapInfo.sharedInstance()?.getSwapAssetItem(withCoin: positionModel?.contractInfo.margin_coin)
        }
    }
    
    var less_qty = ""
    
    var most_qty = ""
    
    lazy var closePxView : KRSheetInfoView = {
        let object = KRSheetInfoView()
        object.setLeftLabel("调整后强平价格".localized())
        object.rightBtn.bottomLine.isHidden = true
        return object
    }()
    lazy var leverageView : KRSheetInfoView = {
        let object = KRSheetInfoView()
        object.setLeftLabel("调整后杠杆".localized())
        object.rightBtn.bottomLine.isHidden = true
        return object
    }()
    lazy var marginInput : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .baseLine)
        object.titleLabel.text = "保证金数量".localized()
        object.input.placeholder = "请输入保证金数量".localized()
        object.input.keyboardType = .decimalPad
        object.extraLabel.text = "USDT"
        object.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
             mySelf.textFieldValueHasChanged(textField: object.input)
        }
        return object
    }()
    lazy var marginRangeLabel : UILabel = {
        let object = UILabel.init(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        contentView.addSubViews([closePxView,leverageView,marginInput,marginRangeLabel])
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(210)
        }
        closePxView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(40)
        }
        leverageView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(closePxView)
            make.top.equalTo(closePxView.snp.bottom)
        }
        marginInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(closePxView)
            make.height.equalTo(56)
            make.top.equalTo(leverageView.snp.bottom).offset(20)
        }
        marginRangeLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(marginInput)
            make.height.equalTo(16)
            make.top.equalTo(marginInput.snp.bottom).offset(4)
        }
        nameLabel.text = "调整保证金".localized()
    }
}

extension KRAdjustMarginSheet {
    
    func updatePositionModel(_ positionModel : BTPositionModel) {
        self.positionModel = BTPositionModel.mj_object(withKeyValues: positionModel.mj_keyValues())
        closePxView.setRightLabel(positionModel.liquidate_price + positionModel.contractInfo.quote_coin)
        let im = positionModel.im.toSmallValue(withContract: positionModel.instrument_id) ?? ""
        self.marginInput.input.text = im
        self.marginInput.extraLabel.text = positionModel.contractInfo.margin_coin
        if self.positionModel!.reduceDeposit_Max.greaterThan(im) {
            return
        }
        less_qty = im.bigSub(positionModel.reduceDeposit_Max).toSmallValue(withContract: self.positionModel!.instrument_id)
        less_qty = less_qty.bigAdd(self.positionModel?.contractInfo?.value_unit ?? "0") // 进一位
        most_qty = im.bigAdd(self.asset!.contract_avail).toSmallValue(withContract: self.positionModel!.instrument_id)
        marginRangeLabel.text = String(format:"%@ %@-%@%@","保证金范围".localized(),less_qty,most_qty,positionModel.contractInfo.margin_coin)
        
        var reality = self.positionModel?.realityLeverage ?? "1"
        let arrLeverage = reality.components(separatedBy: ".")
        if arrLeverage.count == 2 {
            reality = arrLeverage[0].bigAdd(DecimalOne)
        }
        leverageView.setRightLabel( String(format:"%@X",reality))
    }
    
    func textFieldValueHasChanged(textField:UITextField) {
        guard positionModel != nil else { return }
        let text = textField.text ?? "0"
        if text.lessThan(less_qty) || text.greaterThan(most_qty) {
            closePxView.setRightLabel("--")
            leverageView.setRightLabel("1X")
            return
        }
        let position = BTPositionModel.mj_object(withKeyValues: self.positionModel!.mj_keyValues())
        position!.im = text
        closePxView.setRightLabel(position!.liquidate_price ?? "--")
        if position!.position_type == .allType { // 全仓
            return
        }
        var reality = position?.realityLeverage ?? "1"
        let arrLeverage = reality.components(separatedBy: ".")
        if arrLeverage.count == 2 {
            reality = arrLeverage[0].bigAdd(DecimalOne)
        }
        leverageView.setRightLabel( String(format:"%@X",reality))
    }
    
    override func clickSubmitBtn(_ sender: EXButton) {
        guard positionModel != nil else {
            sender.animationStopped()
            return
        }
        var oper_type = 2
        let im = positionModel!.im ?? "0"
        let currentIM = marginInput.input.text ?? "0"
        var qty = "0"
        if im.lessThan(currentIM) {
            oper_type = 1
            qty = currentIM.bigSub(im)
        } else if im.greaterThan(currentIM)  {
            qty = im.bigSub(currentIM)
        }
        if qty.isLessThanOrEqualZero() == true || (qty.lessThan(positionModel?.contractInfo?.value_unit)) {
            sender.animationStopped()
            clickAdjustMarginBlock?(false)
            return
        }
        sender.isUserInteractionEnabled = false
        BTContractTool.marginDeposit(withContractID: self.positionModel!.instrument_id, positionID: self.positionModel!.pid, vol: qty, operType: oper_type, success: {[weak self]  (result) in
            guard let mySelf = self else {return}
            sender.isUserInteractionEnabled = true
            sender.animationStopped()
            mySelf.clickAdjustMarginBlock?(true)
        }) { (error) in
            sender.isUserInteractionEnabled = true
            sender.animationStopped()
            self.clickAdjustMarginBlock?(false)
        }
    }
}
