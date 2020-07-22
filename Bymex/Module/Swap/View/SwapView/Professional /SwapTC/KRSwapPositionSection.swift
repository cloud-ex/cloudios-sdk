//
//  KRSwapPositionSection.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapPositionSection: KRBaseV {
    
    lazy var mainView : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeTab.bg
        return object
    }()
    lazy var lastBtn : UIButton = {
        let object = UIButton()
        object.setImage(UIImage.themeImageNamed(imageName: "swap_lastpx"), for: .normal)
        object.extSetTitle(" "+"最新价".localized(), 12, UIColor.ThemeLabel.colorDark, .normal)
        object.isUserInteractionEnabled = false
        return object
    }()
    lazy var lastLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .left)
        return object
    }()
    lazy var fairPxBtn : UIButton = {
        let object = UIButton()
        object.setImage(UIImage.themeImageNamed(imageName: "swap_fairPx"), for: .normal)
        object.extSetTitle(" "+"合理价".localized(), 12, UIColor.ThemeLabel.colorDark, .normal)
        object.isUserInteractionEnabled = false
        return object
    }()
    lazy var fairLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(28)
            make.centerY.equalToSuperview()
        }
        mainView.addSubViews([lastBtn,lastLabel,fairPxBtn,fairLabel])
        lastBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(17)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(100)
        }
        lastLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lastBtn.snp.right).offset(5)
            make.height.centerY.equalTo(lastBtn)
            make.width.lessThanOrEqualTo(100)
        }
        fairPxBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lastLabel.snp.right).offset(17)
            make.height.centerY.equalTo(lastBtn)
            make.width.lessThanOrEqualTo(100)
        }
        fairLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fairPxBtn.snp.right).offset(5)
            make.height.centerY.equalTo(lastBtn)
            make.width.lessThanOrEqualTo(100)
        }
    }
}

extension KRSwapPositionSection {
    
    func setView(_ entity : BTItemModel) {
        if entity.trend == .up {
            lastLabel.textColor = UIColor.ThemekLine.up
        } else {
            lastLabel.textColor = UIColor.ThemekLine.down
        }
        self.setFairPx(entity.fair_px.toSmallPrice(withContractID:entity.instrument_id) ?? "-")
        self.setLastPx(entity.last_px.toSmallEditPriceContractID(entity.instrument_id) ?? "-")
    }
    
    func setLastPx(_ px : String) {
        lastLabel.text = px
    }
    
    func setFairPx(_ px : String) {
        fairLabel.text = px
    }
}
