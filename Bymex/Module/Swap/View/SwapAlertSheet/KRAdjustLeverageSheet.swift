//
//  KRAdjustLeverageSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAdjustLeverageSheet: KRSwapBaseSheet {
    
    var caculateMaxOpenVolumeHandle: ((_ leverage: KRLeverageManager.Item, _ resultHandle: ((_ maxVol: String, _ needMargin: String) -> Void)?) -> Void)?
    var leverageMultipleSelected: ((_ leverage: KRLeverageManager.Item) -> Void)?
    
    /// 当前杠杆
    var currentLeverage: KRLeverageManager.Item = KRLeverageManager.shared.userContractLeverageItem
    
    var leverage : Int = 10
    
    var instrumentId: Int64?
    
    lazy var calculatorTypeV : UISegmentedControl = {
        let object = UISegmentedControl.init(titles: ["逐仓".localized(),"全仓".localized()])
        return object
    }()
    lazy var leverageLabel : UILabel = {
        let object = UILabel.init(text: "-", font: UIFont.ThemeFont.RMedium, textColor: UIColor.ThemeLabel.colorHighlight, alignment: .center)
        return object
    }()
    lazy var leverageTips : UILabel = {
        let object = UILabel.init(text: "全仓模式下，若发生强平将损失该币种所有的可用余额，请注意仓位风险控制。", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.numberOfLines = 0
        return object
    }()
    lazy var levelSlider : KRLevelSlider = {
        let object = KRLevelSlider(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 50), maxLevel: 100)
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        contentView.addSubViews([calculatorTypeV,leverageLabel,levelSlider])
        addSubview(leverageTips)
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(220)
        }
        calculatorTypeV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(20)
        }
        leverageLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(36)
            make.top.equalTo(calculatorTypeV.snp.bottom).offset(40)
        }
        levelSlider.snp.makeConstraints { (make) in
            make.left.right.equalTo(calculatorTypeV)
            make.top.equalTo(leverageLabel.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        submitBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(contentView.snp_bottom).offset(40)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM-260)
        }
        leverageTips.snp.makeConstraints { (make) in
            make.left.right.equalTo(submitBtn)
            make.bottom.equalTo(submitBtn.snp.top).offset(-10)
        }
        nameLabel.text = "调整杠杆".localized()
        configView()
    }
    
    override func onCreat() {
        _ = calculatorTypeV.rx.value.asObservable()
        .subscribe(onNext: { [weak self] tag in
            self?.handleLeverageType(tag)
        }).disposed(by: disposeBag)
        
        self.levelSlider.valueChangedCallback = {[weak self] value in
            guard let mySelf = self else {
                return
            }
            mySelf.leverage = value
            mySelf.leverageLabel.text = String(value) + "X"
        }
    }
    
    override func clickSubmitBtn(_ sender: EXButton) {
        guard instrumentId != nil else { return }
        
        let orders = SLPersonaSwapInfo.sharedInstance()?.getOrders(instrumentId!) ?? []
        let positions = SLPersonaSwapInfo.sharedInstance()?.getPositions(instrumentId!) ?? []
        if orders.count > 0 || positions.count > 0 {
            EXAlert.showWarning(msg: "存在当前持仓或委托，不可调整杠杆".localized())
            return
        }
        sender.isUserInteractionEnabled = false
        
        let levModel = (calculatorTypeV.selectedSegmentIndex == 1) ? KRLeverageModel.full : KRLeverageModel.staged
        
        let success = { [weak self] (arr: [SLGlobalLeverageEntity]?) in
            guard self != nil else { return }
            sender.isUserInteractionEnabled = true
            self?.leverageMultipleSelected?(self!.currentLeverage)
        }
        let failure = { [weak self] (err: Any?) in
            guard self != nil else { return }
            sender.isUserInteractionEnabled = true
            let errMsg = err as? String ?? "提交失败，请稍后重试".localized()
            EXAlert.showFail(msg: errMsg)
        }
        KRLeverageManager.shared.setGlobalLeverage(instrumentId: instrumentId!,
                                                   leverage: UInt8(self.leverage),
                                                   leverageModel: levModel,
                                                   successCallback: success,
                                                   failureCallback: failure)
    }
}

extension KRAdjustLeverageSheet {
    
    func configView() {
        calculatorTypeV.selectedSegmentIndex = (currentLeverage.leverage.model == .full) ? 1 : 0
        handleLeverageType(calculatorTypeV.selectedSegmentIndex)
        leverageLabel.text = String(currentLeverage.leverage.leverage)+"X"
        leverage = Int(currentLeverage.leverage.leverage)
        levelSlider.updateSliderValue(value:Float(leverage))
    }
    
    func handleLeverageType(_ tag : Int) {
        if tag == 0 {
            leverageTips.text = "*杠杆倍数越高，风险越高".localized()
        } else {
            leverageTips.text = "全仓模式下，若发生强平将损失该币种所有的可用余额，请注意仓位风险控制。".localized()
        }
    }
}
