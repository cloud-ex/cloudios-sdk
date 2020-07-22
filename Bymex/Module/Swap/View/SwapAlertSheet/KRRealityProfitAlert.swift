//
//  KRRealityProfitAlert.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/4.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  已实现盈亏弹窗

import Foundation

class KRRealityProfitAlert : KRBaseV {
    typealias AlertCallback = (Int) -> ()
    var alertCallback : AlertCallback?
    
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "已实现盈亏明细", font: UIFont.ThemeFont.HeadMedium, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        return object
    }()
    lazy var msgLabel : UILabel = {
        let object = UILabel.init(text: "已实现盈亏包含已平仓部分的平仓盈亏、当前持仓的开仓手续费、平仓手续费、资金费用，费用明细如下:", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.numberOfLines = 0
        object.autoresizingMask = .flexibleHeight
        return object
    }()
    lazy var fundRateLebel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("资金费用")
        return object
    }()
    lazy var feeLebel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("手续费")
        return object
    }()
    lazy var closeFeeLebel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("平仓盈亏")
        return object
    }()
    lazy var passiveBtn : EXButton = {
        let object = EXButton()
        object.extSetAddTarget(self, #selector(passtiveAction))
        object.setTitle("资金费用详情", for: .normal)
        return object
    }()
    
    lazy var positiveBtn : EXButton = {
        let object = EXButton()
        object.extSetAddTarget(self, #selector(positveAction))
        object.setTitle("我知道了", for: .normal)
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([titleLabel,msgLabel,fundRateLebel,feeLebel,closeFeeLebel,passiveBtn,positiveBtn])
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.width.lessThanOrEqualToSuperview()
        }
        msgLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        fundRateLebel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(30)
            make.top.equalTo(msgLabel.snp.bottom).offset(15)
        }
        feeLebel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(fundRateLebel)
            make.top.equalTo(fundRateLebel.snp.bottom)
        }
        closeFeeLebel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(fundRateLebel)
            make.top.equalTo(feeLebel.snp.bottom)
        }
        
        positiveBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.right.equalTo(-15)
            make.height.equalTo(36)
            make.top.equalTo(closeFeeLebel.snp.bottom).offset(15)
        }
        passiveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(positiveBtn.snp.left).offset(-25)
            make.height.top.equalTo(positiveBtn)
        }
        passiveBtn.clearColors()
        positiveBtn.clearColors()
        
        positiveBtn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
        passiveBtn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
        passiveBtn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        positiveBtn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
    }
    
    func configPosition(_ entity: BTPositionModel) {
        if entity.tax.lessThan(BT_ZERO) {
            fundRateLebel.setRightText(entity.tax?.bigMul("-1").toDecimalString(8) ?? "0")
        } else {
            fundRateLebel.setRightText(entity.tax?.bigMul("-1").toDecimalUp(8) ?? "0")
        }
        if entity.total_fee.lessThan(BT_ZERO) {
            feeLebel.setRightText(entity.total_fee?.toDecimalUp(8) ?? "0")
        } else {
            feeLebel.setRightText(entity.total_fee?.toDecimalString(8) ?? "0")
        }
        if entity.close_PNL.lessThan(BT_ZERO) {
            closeFeeLebel.setRightText(entity.close_PNL?.toDecimalUp(8) ?? "0")
        } else {
            closeFeeLebel.setRightText(entity.close_PNL?.toDecimalString(8) ?? "0")
        }
    }
}

extension KRRealityProfitAlert {
    @objc func positveAction(_ sender: EXButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(0)
        }
        EXAlert.dismiss()
    }
    
    @objc func passtiveAction(_ sender: EXButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(1)
        }
        EXAlert.dismiss()
    }
}

