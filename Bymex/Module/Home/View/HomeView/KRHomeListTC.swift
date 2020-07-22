//
//  KRHomeListTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import YYWebImage

class KRHomeListTC: UITableViewCell {
    
    var currentReuseIdentifier = ""
    
    lazy var nameLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var qtyLabel : UILabel = {
        let object = UILabel.init(text: "home_text_dealQty".localized()+":"+"--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var pxLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var fiatLabel : UILabel = {
        let object = UILabel.init(text: "￥--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var rateLabel : UILabel = {
        let object = UILabel.init(text: "--%", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemekLine.up, alignment: .center)
        object.extSetCornerRadius(4)
        object.backgroundColor = UIColor.ThemekLine.up15
        return object
    }()
    lazy var crownView : UIImageView = {
        let object = UIImageView()
        return object
    }()
    lazy var iconView : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: ""))
        return object
    }()
    lazy var lineV : UIView = {
        let object = UIView()
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        currentReuseIdentifier = reuseIdentifier ?? KRHomeSwapMarketTC
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupSubViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ entity : BTItemModel) {
        if currentReuseIdentifier == KRHomeSwapMarketTC {
            nameLabel.text = entity.symbol
            qtyLabel.text = "home_text_dealQty".localized()+":"+entity.qty24
            pxLabel.text = entity.last_px
            if KRBasicParameter.isHan() {
                fiatLabel.text = "￥"+"--"
            } else {
                fiatLabel.text = "$"+"--"
            }
            
        } else if currentReuseIdentifier == KRHomeDayProfitTC {
            
        }
    }
}

extension KRHomeListTC {
    private func setupSubViewsLayout() {
        if currentReuseIdentifier == KRHomeSwapMarketTC {
            contentView.addSubViews([nameLabel,qtyLabel,pxLabel,fiatLabel,rateLabel])
            nameLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(10)
                make.height.equalTo(18)
                make.right.equalTo(pxLabel.snp.left).offset(10)
            }
            qtyLabel.snp.makeConstraints { (make) in
                make.left.right.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom)
                make.bottom.equalTo(-10)
            }
            pxLabel.snp.makeConstraints { (make) in
                make.left.equalTo(158)
                make.centerY.height.equalTo(nameLabel)
                make.right.equalTo(rateLabel.snp.left).offset(10)
            }
            fiatLabel.snp.makeConstraints { (make) in
                make.left.right.equalTo(pxLabel)
                make.centerY.height.equalTo(qtyLabel)
            }
            rateLabel.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.height.equalTo(35)
                make.centerY.equalTo(contentView.height * 0.5)
                make.width.equalTo(70)
            }
        } else if currentReuseIdentifier == KRHomeDayProfitTC {
            contentView.addSubViews([crownView,iconView,nameLabel,pxLabel])
            iconView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.centerY.equalTo(contentView.height * 0.5)
                make.width.height.equalTo(32)
            }
            crownView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalTo(15)
                make.width.height.equalTo(28)
            }
            nameLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(10)
            }
            pxLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(nameLabel)
                make.right.equalTo(-15)
                make.height.equalTo(20)
            }
            nameLabel.textColor = UIColor.ThemeLabel.colorDark
            pxLabel.textAlignment = .right
        }
    }
}
