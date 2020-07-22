//
//  KRSheetInfoView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/22.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSheetInfoView: KRBaseV {
    lazy var leftLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        return object
    }()
    
    lazy var rightBtn : KRTipBtn = {
        let object = KRTipBtn()
        return object
    }()
    
    override func setupSubViewsLayout() {
        backgroundColor = UIColor.ThemeTab.bg
        addSubViews([leftLabel,rightBtn])
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(36)
            make.centerY.equalTo(20)
            make.height.equalTo(14)
            make.width.lessThanOrEqualTo(150)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-36)
            make.centerY.equalTo(leftLabel)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(14)
        }
    }
    
    public func setLeftLabel(_ str : String) {
        leftLabel.text = str
    }
    
    public func setRightLabel(_ str : String) {
        rightBtn.setTitle(str)
        rightBtn.layoutBottomLine()
    }
}

class KRSwapEmptyView: KRBaseV {
    lazy var emptyImage : UIImageView = {
        let object = UIImageView()
        object.image = UIImage.themeImageNamed(imageName: "swap_data_empty")
        return object
    }()
    lazy var emptyTips : UILabel = {
        let object = UILabel.init(text: "赶快开仓吧，你离暴富只差一步", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .center)
        object.numberOfLines = 0
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([emptyImage,emptyTips])
        emptyImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.top.equalTo(60)
            make.centerX.equalToSuperview()
        }
        emptyTips.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(emptyImage.snp.bottom).offset(24)
        }
    }
}
