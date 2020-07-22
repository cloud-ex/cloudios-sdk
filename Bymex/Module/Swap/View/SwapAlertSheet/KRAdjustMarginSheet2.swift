//
//  KRAdjustMarginSheet2.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAdjustMarginSheet2: KRSwapBaseSheet {
    
    typealias ClickAdjustMarginBlock = (Bool) -> ()
    var clickAdjustMarginBlock : ClickAdjustMarginBlock?
    
    var positionModel : BTPositionModel?
    
    var less_qty = ""
    
    var most_qty = ""
    
    var asset : BTItemCoinModel? {
        get {
            return SLPersonaSwapInfo.sharedInstance()?.getSwapAssetItem(withCoin: positionModel?.contractInfo.margin_coin)
        }
    }
    
    var unit = ""
    
    var currentTag = 0
    lazy var depositTypeView : UISegmentedControl = {
        let object = UISegmentedControl.init(titles: ["追加".localized(),"减少".localized()])
        _ = object.rx.value.asObservable()
            .subscribe(onNext: { [weak self] tag in
                guard let mySelf = self else {return}
                mySelf.currentTag = tag
                if tag == 0 {
                    mySelf.marginInput.titleLabel.text = "追加保证金".localized()
                    mySelf.marginRangeLabel.text = "最大可增加" + mySelf.most_qty + mySelf.unit
                } else {
                    mySelf.marginInput.titleLabel.text = "减少保证金".localized()
                    mySelf.marginRangeLabel.text = "最大可减少" + mySelf.less_qty + mySelf.unit
                }
            }).disposed(by: disposeBag)
        return object
    }()
    lazy var currentPositionView : KRSheetInfoView = {
        let object = KRSheetInfoView()
        object.setLeftLabel("当前仓位".localized())
        object.rightBtn.bottomLine.isHidden = true
        return object
    }()
    lazy var depositView : KRSheetInfoView = {
        let object = KRSheetInfoView()
        object.setLeftLabel("保证金".localized())
        object.rightBtn.bottomLine.isHidden = true
        return object
    }()
    lazy var currentClosePxView : KRSheetInfoView = {
        let object = KRSheetInfoView()
        object.setLeftLabel("当前强平价格".localized())
        object.rightBtn.bottomLine.isHidden = true
        return object
    }()
    lazy var closePxView : KRSheetInfoView = {
        let object = KRSheetInfoView()
        object.setLeftLabel("调整后强平价格".localized())
        object.rightBtn.bottomLine.isHidden = true
        return object
    }()
    lazy var marginInput : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endBtn)
        object.setPlaceHolder(placeHolder: "请输入保证金数量".localized(), font: 16)
        object.input.keyboardType = .decimalPad
        object.endBtn.extSetTitle("全部", 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
             mySelf.textFieldValueHasChanged(textField: object.input)
        }
        object.endBtn.rx.tap.subscribe(onNext:{ [weak self] in
            if self?.currentTag == 0 {
                self?.marginInput.input.text = self?.most_qty ?? "0"
            } else {
                self?.marginInput.input.text = self?.less_qty ?? "0"
            }
        }).disposed(by: disposeBag)
        return object
    }()
    lazy var marginRangeLabel : UILabel = {
        let object = UILabel.init(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        contentView.addSubViews([depositTypeView,currentPositionView,depositView,closePxView,currentClosePxView,marginInput,marginRangeLabel])
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(340)
        }
        depositTypeView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.height.equalTo(32)
        }
        currentPositionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.top.equalTo(depositTypeView.snp.bottom).offset(14)
            make.height.equalTo(40)
        }
        depositView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(currentPositionView)
            make.top.equalTo(currentPositionView.snp.bottom)
        }
        currentClosePxView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(depositView)
            make.top.equalTo(depositView.snp.bottom)
        }
        closePxView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(depositView)
            make.top.equalTo(currentClosePxView.snp.bottom)
        }
        marginInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(closePxView)
            make.height.equalTo(56)
            make.top.equalTo(closePxView.snp.bottom).offset(20)
        }
        marginRangeLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(marginInput)
            make.height.equalTo(16)
            make.top.equalTo(marginInput.snp.bottom).offset(4)
        }
        nameLabel.text = "调整保证金".localized()
    }
    
    func textFieldValueHasChanged(textField:UITextField) {
        guard positionModel != nil else { return }
        let text = textField.text ?? "0"
        let position = BTPositionModel.mj_object(withKeyValues: self.positionModel!.mj_keyValues())
        if currentTag == 0 { //  增加保证金
            position?.im = text.bigAdd(position?.im ?? "0")
            if text.greaterThan(most_qty) {
                marginRangeLabel.text = "超过最大可增加保证金".localized()
                marginRangeLabel.textColor = .red
            } else {
                marginRangeLabel.text = "最大可增加" + most_qty + unit
                marginRangeLabel.textColor = UIColor.ThemeLabel.colorDark
            }
        } else {
            position?.im = position?.im.bigSub(text)
            if text.greaterThan(less_qty) {
                marginRangeLabel.text = "超过最大可减少保证金".localized()
                marginRangeLabel.textColor = .red
            } else {
                marginRangeLabel.text = "最大可减少" + less_qty + unit
                marginRangeLabel.textColor = UIColor.ThemeLabel.colorDark
            }
        }
        closePxView.setRightLabel((position!.liquidate_price ?? "--")+" "+unit)
    }
    
    override func clickSubmitBtn(_ sender: EXButton) {
        guard positionModel != nil else {
            sender.animationStopped()
            return
        }
        var oper_type = 2
        let qty = marginInput.input.text ?? "0"
        if currentTag == 0 { // 增加
            oper_type = 1
        } else {
            oper_type = 2
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

extension KRAdjustMarginSheet2 {
    func updatePositionModel(_ positionModel : BTPositionModel) {
        let unitLen = String(positionModel.contractInfo.value_unit.kr_length-2)
        marginInput.decimal = unitLen
        self.positionModel = BTPositionModel.mj_object(withKeyValues: positionModel.mj_keyValues())
        unit = positionModel.contractInfo.margin_coin
        currentPositionView.setRightLabel(positionModel.cur_qty+" "+"张".localized())
        depositView.setRightLabel((positionModel.im.toSmallValue(withContract: positionModel.instrument_id) ?? "")+" "+positionModel.contractInfo.margin_coin)
        currentClosePxView.setRightLabel((positionModel.liquidate_price)+" "+unit)
        closePxView.setRightLabel((positionModel.liquidate_price)+" "+unit)

        most_qty = self.asset!.contract_avail.toSmallValue(withContract: self.positionModel!.instrument_id) ?? "0" // 最大可增加
        less_qty = positionModel.reduceDeposit_Max.toSmallValue(withContract: self.positionModel!.instrument_id) ?? "0" // 最大可减少
        marginRangeLabel.text = "最大可增加" + most_qty + unit
    }
    
    private func clickInputAllDeposit() {
        if currentTag == 0 {
            marginInput.input.text = most_qty
        } else {
            marginInput.input.text = less_qty
        }
        textFieldValueHasChanged(textField: marginInput.input)
    }
}
