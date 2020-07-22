//
//  KRProPlanOrderSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRProPlanOrderSheet: KRSwapBaseSheet {
    
    lazy var tiggerPxV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("触发价格".localized())
        return object
    }()
    lazy var performPxV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("执行价格".localized())
        return object
    }()
    lazy var qtyV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("数量".localized())
        return object
    }()
    lazy var valueV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("有效时长".localized())
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
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        contentView.addSubViews([tiggerPxV,performPxV,qtyV,valueV,positionV,remindBtn])
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(230)
        }
        tiggerPxV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(20)
        }
        performPxV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(tiggerPxV)
            make.top.equalTo(tiggerPxV.snp.bottom)
        }
        qtyV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(performPxV)
            make.top.equalTo(performPxV.snp.bottom)
        }
        valueV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(qtyV)
            make.top.equalTo(qtyV.snp.bottom)
        }
        positionV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(valueV)
            make.top.equalTo(valueV.snp.bottom)
        }
        remindBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(32)
            make.width.lessThanOrEqualTo(100)
            make.top.equalTo(positionV.snp.bottom).offset(8)
        }
    }
}

extension KRProPlanOrderSheet {
    
    override func clickSubmitBtn(_ sender: EXButton) {
        self.clickSubmitBtnBlock?()
    }
    
    @objc func clickRemindBtn(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        XUserDefault.setComfirmSwapAlert(!sender.isSelected)
    }
    
    public func configOrder(_ order : BTContractOrderModel) {
        var color = UIColor.ThemekLine.up
        if order.side == .buy_OpenLong {
            nameLabel.text = "条件单买入".localized()
        } else {
            nameLabel.text = "条件单卖出".localized()
            color = UIColor.ThemekLine.down
        }
        tiggerPxV.setRightText((order.px?.toSmallPrice(withContractID: order.instrument_id) ?? "0")+" "+(order.contractInfo.quote_coin ?? ""))
        var exec_px = (order.exec_px?.toSmallPrice(withContractID: order.instrument_id) ?? "0")+" "+(order.contractInfo.quote_coin ?? "")
        if order.category == .market {
            exec_px = "市价"
        }
        performPxV.setRightText(exec_px)
        tiggerPxV.rightLabel.textColor = color
        performPxV.rightLabel.textColor = color
        qtyV.setRightText(order.qty.toSmallVolume(withContractID: order.instrument_id) ?? "0")
        var dateStr = "7天".localized()
        if order.cycle.intValue == 24 {
            dateStr = "24小时".localized()
        }
        valueV.setRightText(dateStr)
        let itemModel = BTItemModel()
        itemModel.instrument_id = order.instrument_id
        let position = SLFormula.getUserPosition(with: itemModel, contractWay: order.side)
        var holdVol = order.qty ?? "0"
        holdVol = holdVol.bigAdd(position.cur_qty ?? "0")
        positionV.setRightText(holdVol+"张".localized())
    }
}
