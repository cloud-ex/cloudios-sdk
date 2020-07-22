//
//  KRSwapFundRateTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapFundRateTC: UITableViewCell {
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorDark
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var middleLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([leftLabel, middleLabel, rightLabel])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        self.middleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        self.rightLabel.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.lessThanOrEqualTo(self.snp.centerX)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    func setFundRateCell(_ entity : BTIndexDetailModel) {
        leftLabel.text = BTFormat.timeOnlyDate(fromDateStr: entity.timestamp.stringValue)
        middleLabel.text = "每8小时".localized()
        rightLabel.text = ((entity.rate ?? "--") as NSString).toPercentString(4)
    }
}

class KRSwapInfoHeaderView: KRBaseV {
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorDark
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var middleLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorDark
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.isHidden = true
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorDark
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textAlignment = .right
        return label
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        initLayout()
    }
    
    private func initLayout() {
        addSubViews([leftLabel,middleLabel,rightLabel])
        self.leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        self.middleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        self.rightLabel.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.lessThanOrEqualTo(self.snp.centerX)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
}
