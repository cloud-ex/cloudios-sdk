//
//  KRProfitInfoView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRProfitInfoView: KRBaseV {
    lazy var infoTitle : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var contentLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var bottomLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    lazy var endBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("撤销".localized(), 12, UIColor.ThemeLabel.colorHighlight, .normal)
        object.color = UIColor.ThemeView.highlight
        object.highlightedColor = UIColor.ThemeView.bg
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func setupSubViewsLayout() {
        addSubViews([infoTitle,contentLabel,bottomLine,endBtn])
        infoTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(16)
            make.width.lessThanOrEqualToSuperview()
        }
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(infoTitle.snp.bottom).offset(3)
            make.height.equalTo(24)
            make.width.lessThanOrEqualTo(200)
        }
        endBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(contentLabel)
            make.width.equalTo(45)
            make.height.equalTo(24)
        }
    }
}
