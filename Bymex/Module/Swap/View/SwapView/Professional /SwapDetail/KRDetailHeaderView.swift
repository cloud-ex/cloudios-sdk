//
//  KRDetailHeaderView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRDetailHeaderView: KRBaseV {
    lazy var lastPxLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.H3Medium, textColor: UIColor.ThemekLine.up, alignment: .left)
        return object
    }()
    lazy var equalLabel : UILabel = {
        let object = UILabel.init(text: "≈--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var rateLabel : UILabel = {
        let object = UILabel.init(text: "--%", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .center)
        object.extSetCornerRadius(3)
        return object
    }()
    lazy var indexPxBtn : KRTipBtn = {
        let object = KRTipBtn()
        object.setImgLayout("swap_indexPx", .left)
        object.setTitle("--")
        object.titleLabel.font = UIFont.ThemeFont.MinimumRegular
        object.clickShowTipBlock = {[weak self] in
            let sheet = KRTextSheet()
            sheet.configTextAlert("swap_indexpx", title: "指数价格".localized(), content: "资金费率为正数，多头仓位向空头仓位支付仓位价值乘资金费率 的资金费。资金费率为负数，多头仓位向空头仓位收取仓位价值乘资金费率的资金费。".localized())
            EXAlert.showSheet(sheetView: sheet)
        }
        return object
    }()
    lazy var fairPxBtn : KRTipBtn = {
        let object = KRTipBtn()
        object.setImgLayout("swap_fairPx", .right)
        object.setTitle("--")
        object.titleLabel.font = UIFont.ThemeFont.MinimumRegular
        object.clickShowTipBlock = {[weak self] in
            let sheet = KRTextSheet()
            sheet.configTextAlert("swap_fairPx", title: "合理价格".localized(), content: "合理价格等于标的指数价格加上随时间递减的资金费用基差，主要为了避免高杠杆发生的不必要平仓。合理价格影响强平，即当合理价格达到爆仓价格时，系统将执行强制平仓操作。".localized())
            EXAlert.showSheet(sheetView: sheet)
        }
        return object
    }()
    lazy var highLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("最高价".localized())
        object.rightLabel.font = UIFont.ThemeFont.SecondaryRegular
        object.rightLabel.textColor = UIColor.ThemeLabel.colorDark
        return object
    }()
    
    lazy var lowLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("最低价".localized())
        object.rightLabel.font = UIFont.ThemeFont.SecondaryRegular
        object.rightLabel.textColor = UIColor.ThemeLabel.colorDark
        return object
    }()
    
    lazy var dayQtyLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("24h量".localized())
        object.rightLabel.font = UIFont.ThemeFont.SecondaryRegular
        object.rightLabel.textColor = UIColor.ThemeLabel.colorDark
        return object
    }()
    
    override func setupSubViewsLayout() {
        addSubViews([lastPxLabel,equalLabel,rateLabel,indexPxBtn,fairPxBtn,highLabel,lowLabel,dayQtyLabel])
        lastPxLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(2)
            make.height.equalTo(24)
            make.width.lessThanOrEqualTo(100)
        }
        equalLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(lastPxLabel)
            make.height.equalTo(18)
            make.left.equalTo(lastPxLabel.snp.right).offset(3)
            make.width.lessThanOrEqualTo(100)
        }
        rateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
            make.width.equalTo(50)
            make.top.equalTo(lastPxLabel.snp.bottom).offset(6)
        }
        indexPxBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(rateLabel.snp.bottom).offset(10)
            make.height.equalTo(16)
            make.width.equalTo(70)
        }
        fairPxBtn.snp.makeConstraints { (make) in
            make.left.equalTo(indexPxBtn.snp.right).offset(10)
            make.height.top.height.equalTo(indexPxBtn)
        }
        highLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(18)
            make.top.equalToSuperview().offset(8)
            make.width.equalTo((SCREEN_WIDTH - 36) * 0.4)
        }
        lowLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(18)
            make.top.equalTo(highLabel.snp.bottom).offset(8)
            make.width.equalTo(highLabel)
        }
        dayQtyLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(18)
            make.top.equalTo(lowLabel.snp.bottom).offset(8)
            make.width.equalTo(highLabel)
        }
    }
    
    func setView(_ itemModel : BTItemModel?) {
        guard let entity = itemModel else {
            return
        }
        lastPxLabel.text = entity.last_px?.toSmallEditPriceContractID(entity.instrument_id) ?? "-"
        let color = (entity.trend == .up) ? UIColor.ThemekLine.up : UIColor.ThemekLine.down
        lastPxLabel.textColor = color
        rateLabel.textColor = color
        rateLabel.backgroundColor = color.withAlphaComponent(0.2)
        rateLabel.text = (entity.change_rate.kr_length) > 0 ? entity.change_rate?.toPercentString(2) : "--"
        indexPxBtn.titleLabel.text = entity.index_px?.toSmallEditPriceContractID( entity.instrument_id) ?? "-"
        fairPxBtn.titleLabel.text = entity.fair_px?.toSmallEditPriceContractID( entity.instrument_id) ?? "-"
        highLabel.setRightText(entity.high?.toSmallEditPriceContractID( entity.instrument_id) ?? "-")
        lowLabel.setRightText(entity.low?.toSmallEditPriceContractID( entity.instrument_id) ?? "-")
        let qty = (entity.qty24.count > 0 ? BTFormat.totalVolume(fromNumberStr: entity.qty24) : "0") ?? "0"
        dayQtyLabel.setRightText(qty)
    }
}
