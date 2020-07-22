//
//  KRAssetInfoView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRDepositInfoView: KRBaseV {
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var contentLabel : UILabel = {
        let object = UILabel.init(text: "".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        object.numberOfLines = 0
        return object
    }()
    lazy var copyBtn : UIButton = {
        let object = UIButton()
        object.setImage(UIImage.themeImageNamed(imageName: "asset_copy"), for: .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            UIPasteboard.general.string = self?.contentLabel.text
            EXAlert.showSuccess(msg: "common_tip_copySuccess".localized())
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func setupSubViewsLayout() {
        addSubViews([titleLabel,contentLabel,copyBtn])
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(16)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalToSuperview()
        }
        copyBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalTo(contentLabel)
        }
    }
}


class KRTipsInfoView: KRBaseV {
    lazy var imgV : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: "asset_tips"))
        return object
    }()
    
    lazy var contentLabel : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    override func setupSubViewsLayout() {
        addSubViews([imgV,contentLabel])
        backgroundColor = UIColor.ThemeLabel.colorHighlight.withAlphaComponent(0.08)
        imgV.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.equalTo(6)
            make.width.height.equalTo(24)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(imgV.snp.right).offset(5)
            make.right.equalTo(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func setContent(_ content:String) {
        contentLabel.text = content
    }
}
