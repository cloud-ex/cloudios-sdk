//
//  KRSwapLightBtn.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/7.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  闪电模式下单按钮

import Foundation

class KRSwapLightBtn: UIButton {
    lazy var nameLabel : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .center)
        return object
    }()
    lazy var pxLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .center)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([nameLabel,pxLabel])
        setupSubViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setName(_ name : String) {
        nameLabel.text = name
    }
    
    func setPx(_ px : String) {
        pxLabel.text = px
    }
}

extension KRSwapLightBtn {
    func setupSubViewsLayout() {
        nameLabel.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(4)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        })
        pxLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-4)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
            make.width.lessThanOrEqualToSuperview()
        }
    }
}
