//
//  KRNormalAlert.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/22.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRNormalAlert: UIView {
    
    typealias AlertCallback = (Int) -> ()
    var alertCallback : AlertCallback?
    
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.BodyBold, textColor: UIColor.ThemeBtn.colorTitle, alignment: .left)
        return object
    }()
    
    lazy var msgLabel : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.numberOfLines = 0
        object.autoresizingMask = .flexibleHeight
        return object
    }()
    
    lazy var passiveBtn : EXButton = {
        let object = EXButton()
        object.extSetAddTarget(self, #selector(passtiveAction))
        return object
    }()
    
    lazy var positiveBtn : EXButton = {
        let object = EXButton()
        object.extSetAddTarget(self, #selector(positveAction))
        return object
    }()
    
    lazy var lineV : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    var topHeight :CGFloat = 0
    
    func configMessage(message:String,passiveBtnTitle:String = "common_action_iknow".localized()) {
        backgroundColor = UIColor.ThemeTab.bg
        msgLabel.text = message
        msgLabel.extSetTextColor(UIColor.ThemeLabel.colorDark, fontSize: 14, textAlignment: .center,numberOfLines:0)
        addSubViews([msgLabel,lineV,passiveBtn])
        msgLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(36)
        }
        lineV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(msgLabel.snp.bottom).offset(20)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview().offset(-44)
        }
        passiveBtn.setTitle(passiveBtnTitle, for: .normal)
        passiveBtn.clearColors()
        passiveBtn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
        passiveBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        layoutIfNeeded()
    }
    
    func configAlert(title:String?,
                     message:String,
                     passiveBtnTitle:String = "common_text_btnCancel".localized(),
                     positiveBtnTitle:String="common_text_btnComfirm".localized()) {
        if let altTitle = title,!altTitle.isEmpty {
            topHeight = 48
            titleLabel.text = altTitle
        }else {
            topHeight = 20
        }
        msgLabel.text = message
        passiveBtn.setTitle(passiveBtnTitle, for: .normal)
        positiveBtn.setTitle(positiveBtnTitle, for: .normal)
        onCreate()
        setSubViewsLayout()
    }
    
    func onCreate() {
        backgroundColor = UIColor.ThemeTab.bg
        titleLabel.headBold()
        titleLabel.textColor = UIColor.ThemeLabel.colorLite
        msgLabel.textColor = UIColor.ThemeLabel.colorLite
        passiveBtn.clearColors()
        positiveBtn.clearColors()
        
        passiveBtn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
        positiveBtn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
    }
    
    func setSubViewsLayout() {
        if topHeight > 25 {
            addSubViews([titleLabel,msgLabel,passiveBtn,positiveBtn])
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(15)
                make.height.equalTo(18)
            }
        } else {
            addSubViews([msgLabel,passiveBtn,positiveBtn])
        }
        
        msgLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(topHeight)
        }
        
        positiveBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.right.equalTo(-15)
            make.height.equalTo(36)
            make.top.equalTo(msgLabel.snp.bottom).offset(15)
        }
        passiveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(positiveBtn.snp.left).offset(-25)
            make.height.top.equalTo(positiveBtn)
        }
    }
}

extension KRNormalAlert {
    @objc func positveAction(_ sender: EXButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(0)
        }
        EXAlert.dismiss()
    }
    
    @objc func passtiveAction(_ sender: EXButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(1)
        }
        EXAlert.dismiss()
    }
}
