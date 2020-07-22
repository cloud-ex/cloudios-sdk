//
//  KRSwapDrawerTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapDrawerTC: UITableViewCell {
    lazy var iconV : UIImageView = {
        let object = UIImageView()
        object.image = UIImage.themeImageNamed(imageName: "asset_coin_placeholder")
        object.isHidden = true
        return object
    }()
    
    lazy var nameLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    lazy var pxLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    lazy var rateLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .right)
        return object
    }()
    
    lazy var lineV : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.ThemeTab.bg
        setupSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ entity: BTItemModel) {
        nameLabel.text = entity.contractInfo.symbol ?? "--"
        pxLabel.text = entity.last_px ?? "--"
        if entity.trend == .up {
            rateLabel.textColor = UIColor.ThemekLine.up
            rateLabel.text = "+"+(entity.change_rate?.toPercentString(2) ?? "--%")
        } else {
            rateLabel.textColor = UIColor.ThemekLine.down
            rateLabel.text = entity.change_rate?.toPercentString(2) ?? "--%"
        }
    }
}

extension KRSwapDrawerTC {
    private func setupSubviewsLayout() {
        addSubViews([nameLabel,pxLabel,rateLabel,lineV])
//        iconV.snp.makeConstraints { (make) in
//            make.left.equalTo(16)
//            make.centerY.equalToSuperview()
//            make.width.height.equalTo(20)
//        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
        }
        pxLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.width.height.centerY.equalTo(nameLabel)
        }
        rateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(pxLabel.snp.right)
            make.width.height.centerY.equalTo(nameLabel)
            make.right.equalToSuperview().offset(-16)
        }
        lineV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(1)
            make.bottom.right.equalToSuperview()
        }
    }
}
