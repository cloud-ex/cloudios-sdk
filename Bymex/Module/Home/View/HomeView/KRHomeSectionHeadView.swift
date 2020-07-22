//
//  KRHomeSectionHeadView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum KRHomeSectionHeadType {
    case swapMarket
    case dayProfit
}

class KRHomeSectionHeadView: UIView {
    
    var headeType = KRHomeSectionHeadType.swapMarket
    
    lazy var titleView : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.H3Bold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var imageView : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: "home_illustration"))
        return object
    }()
    lazy var leftLabel: UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var middleLabel: UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var rightLabel: UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .right)
        return object
    }()
    
    public convenience init(frame: CGRect, homeHeadeType : KRHomeSectionHeadType) {
        self.init()
        self.frame = frame
        self.headeType = homeHeadeType
        setupSubViewsLayout()
    }
    
    func setupSubViewsLayout() {
        setGradientlayerColors([UIColor.ThemeView.seperator.cgColor,UIColor.ThemeView.bg.cgColor])
        addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(20)
            make.height.equalTo(40)
        }
        if headeType == .swapMarket {
            addSubViews([imageView,leftLabel,middleLabel,rightLabel])
            titleView.text = "合约行情".localized()
            leftLabel.text = "名称/成交量".localized()
            middleLabel.text = "最新价".localized()
            rightLabel.text = "24h涨跌(%)".localized()
            imageView.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-15)
                make.top.equalTo(10)
                make.width.height.equalTo(70)
            }
            rightLabel.snp.makeConstraints { (make) in
                make.right.equalTo(imageView)
                make.height.equalTo(40)
                make.bottom.equalToSuperview()
                make.width.equalTo(80)
            }
            middleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(158)
                make.right.equalTo(rightLabel.snp.left).offset(-10)
                make.height.bottom.equalTo(rightLabel)
            }
            leftLabel.snp.makeConstraints { (make) in
                make.left.equalTo(titleView)
                make.height.bottom.equalTo(rightLabel)
                make.right.equalTo(middleLabel.snp.left).offset(-10)
            }
        } else if headeType == .dayProfit {
            addSubViews([titleView,leftLabel,rightLabel])
            titleView.text = "日盈利排行榜".localized()
            leftLabel.text = "昵称".localized()
            rightLabel.text = "收益额".localized()
            leftLabel.snp.makeConstraints { (make) in
                make.left.equalTo(titleView)
                make.height.equalTo(40)
                make.bottom.equalToSuperview()
            }
            rightLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-15)
                make.height.bottom.equalTo(leftLabel)
            }
        }
    }
}
