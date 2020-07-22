//
//  KRCapitalCostTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/4.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  资金费用cell

import Foundation

class KRCapitalCostTC: UITableViewCell {
    
    var px_Code = ""
    var instrument_id : Int64 = 0
    
    lazy var fundCostLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("资金费用")
        return object
    }()
    lazy var positionQtyLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("仓位数量")
        return object
    }()
    lazy var fairPxLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("合理价格")
        return object
    }()
    lazy var timeLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("时间")
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.ThemeView.bg
        contentView.backgroundColor = UIColor.ThemeTab.bg
        selectionStyle = .none
        contentView.extSetCornerRadius(5)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        setupSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviewsLayout() {
        contentView.addSubViews([fundCostLabel,positionQtyLabel,fairPxLabel,timeLabel])
        fundCostLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(8)
        }
        positionQtyLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(fundCostLabel)
            make.top.equalTo(fundCostLabel.snp.bottom)
        }
        fairPxLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(fundCostLabel)
            make.top.equalTo(positionQtyLabel.snp.bottom)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(fundCostLabel)
            make.top.equalTo(fairPxLabel.snp.bottom)
        }
    }
    
    func setCell(_ entity : BTIndexDetailModel) {
        //资金费用
        let fee = entity.tax?.toString(8) ?? "0"
        fundCostLabel.setRightText(fee + px_Code)
        //仓位数量
        positionQtyLabel.setRightText((entity.qty ?? "--")+"张")
        //合理价格
        let price = entity.fair_px?.toSmallPrice(withContractID: instrument_id) ?? "0"
        fairPxLabel.setRightText(price + px_Code)
        
        //时间
        let timeStr = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: entity.created_at), format: "yyyy/MM/dd HH:mm:ss") ?? "-"
        timeLabel.setRightText(timeStr)
    }
}
