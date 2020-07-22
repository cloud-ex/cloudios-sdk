//
//  KRTransactionRecordTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

/// 详情页 - 成交记录列表
class KRTransactionRecordTC: UITableViewCell {
    
    var row: Int = 0
    
    /// 时间
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorMedium, fontSize: 12)
        label.text = "--"
        return label
    }()
    lazy var sideLabel : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .left)
        return object
    }()
    /// 数量
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorMedium, fontSize: 12)
        label.layoutIfNeeded()
        label.textAlignment = .right
        label.text = "--"
        return label
    }()
    
    /// 价格
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorMedium, fontSize: 12)
        label.text = "--"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([timeLabel, numLabel, priceLabel,sideLabel])
        self.initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initLayout() {
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(sideLabel.snp.left).offset(-10)
            make.height.equalTo(13)
            make.centerY.equalToSuperview()
        }
        sideLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.centerX).offset(-15)
            make.height.equalTo(timeLabel)
            make.centerY.equalTo(timeLabel)
            make.width.equalTo(timeLabel)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(15)
            make.height.equalTo(timeLabel)
            make.centerY.equalTo(timeLabel)
        }
        numLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(priceLabel.snp.right).offset(10)
            make.height.equalTo(timeLabel)
            make.centerY.equalTo(timeLabel)
        }
    }
    
    /// 数据更新
    func updateCell(_ model: BTContractTradeModel?) {
        if let _model = model {
            self.timeLabel.text = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: _model.created_at), format: "HH:mm:ss")
            self.priceLabel.text = _model.px
            self.numLabel.text = _model.qty
            
            if _model.side == BTContractTradeWay.CONTRACT_TRADE_WAY_BUY_OLOS_1 || _model.side == BTContractTradeWay.CONTRACT_TRADE_WAY_BUY_OLCL_2 || _model.side == BTContractTradeWay.CONTRACT_TRADE_WAY_BUY_CSOS_3 || _model.side == BTContractTradeWay.CONTRACT_TRADE_WAY_BUY_CSCL_4 {
                sideLabel.textColor = UIColor.ThemekLine.up
                sideLabel.text = "买入".localized()
            } else {
                sideLabel.textColor = UIColor.ThemekLine.down
                sideLabel.text = "卖出".localized()
            }
            
        } else {
            self.timeLabel.text = "--"
            self.sideLabel.text = "--"
            self.priceLabel.text = "--"
            self.numLabel.text = "--"
        }
    }
}

/// 详情页 - 成交记录列表顶部标题
class KRTransactionRecordTitleCell: UITableViewCell {
    
    private lazy var leftLabel: UILabel = UILabel(text: "时间".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
    
    lazy var sideLabel : UILabel = {
        let object = UILabel.init(text: "方向".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    private lazy var middleLabel: UILabel = UILabel(text: "价格(USDT)".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .center)
    
    private lazy var rightLabel: UILabel = UILabel(text: "数量(张)".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .right)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([leftLabel, middleLabel, rightLabel,sideLabel])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(sideLabel.snp.left).offset(-10)
            make.height.equalTo(13)
            make.centerY.equalToSuperview()
        }
        sideLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.centerX).offset(-15)
            make.height.equalTo(leftLabel)
            make.centerY.equalTo(leftLabel)
            make.width.equalTo(leftLabel)
        }
        middleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(15)
            make.height.equalTo(leftLabel)
            make.centerY.equalTo(leftLabel)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(middleLabel.snp.right).offset(10)
            make.height.equalTo(leftLabel)
            make.centerY.equalTo(leftLabel)
        }
    }
    
    func setPriceUnit(_ unit : String) {
        middleLabel.text = String(format: "价格(%@)".localized(), unit)
    }
}
