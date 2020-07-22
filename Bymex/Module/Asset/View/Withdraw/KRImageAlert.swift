//
//  KRImageAlert.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRImageAlert: KRBaseV {
    lazy var mainView : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeTab.bg
        object.layer.cornerRadius = 10
        return object
    }()
    
    lazy var iconV : UIImageView = {
        let object = UIImageView()
        object.image = UIImage.themeImageNamed(imageName: "asset_status_wait")
        return object
    }()
    
    lazy var statusLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.H3Medium, textColor: UIColor.ThemeLabel.colorLite, alignment: .center)
        return object
    }()
    
    lazy var contentLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .center)
        object.numberOfLines = 0
        return object
    }()
    lazy var middleLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    lazy var cancelBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("common_action_iknow".localized(), 16, UIColor.ThemeLabel.colorHighlight, .normal)
        object.rx.tap.subscribe(onNext:{
            EXAlert.dismiss()
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func setupSubViewsLayout() {
        backgroundColor = UIColor.clear
        mainView.addSubViews([iconV,statusLabel,contentLabel,middleLine,cancelBtn])
        iconV.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconV.snp.bottom).offset(16)
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(statusLabel)
            make.top.equalTo(statusLabel.snp.bottom).offset(8)
        }
        middleLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-44)
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(middleLine.snp.bottom)
        }
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    func configAlertView(_ imgStr:String="asset_status_wait",_ name:String="审核中".localized(),_ content:String="您的提现申请已提交，请耐心等待可在提现记录中查看提现进度".localized(),_ positive:String="我知道了".localized()) {
        iconV.image = UIImage.themeImageNamed(imageName: imgStr)
        statusLabel.text = name
        contentLabel.text = content
        cancelBtn.extSetTitle(positive, titleColor: UIColor.ThemeLabel.colorHighlight)
        layoutIfNeeded()
    }
}
