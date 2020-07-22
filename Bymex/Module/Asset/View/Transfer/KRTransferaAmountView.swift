//
//  KRTransferaAmountView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/25.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRTransferaAmountView: KRBaseV {
    
    override func setupSubViewsLayout() {
        layer.cornerRadius = 10
        backgroundColor = UIColor.ThemeTab.bg
        addSubViews([transferVolume,balanceVolume])
        transferVolume.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(20)
            make.height.equalTo(56)
        }
        balanceVolume.snp.makeConstraints { (make) in
            make.left.right.equalTo(transferVolume)
            make.top.equalTo(transferVolume.snp.bottom).offset(5)
            make.height.equalTo(16)
        }
    }
    
    func setAmount(_ amount : String, _ unit : String) {
        balanceVolume.text = String(format: "%@:%@%@", "余额".localized(),amount,unit)
    }
    
    // MARK:- lazy
    // 划转数量
    lazy var transferVolume : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .baseLine)
        object.titleLabel.text = "划转数量".localized()
        object.extraLabel.text = "全部".localized()
        object.setPlaceHolder(placeHolder: "请输入划转数量".localized(), font: 16)
        object.backgroundColor = UIColor.ThemeTab.bg
        object.input.backgroundColor = UIColor.ThemeTab.bg
        return object
    }()
    
    // 余额
    lazy var balanceVolume : UILabel = {
        let object = UILabel.init(text: "余额：--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
}
