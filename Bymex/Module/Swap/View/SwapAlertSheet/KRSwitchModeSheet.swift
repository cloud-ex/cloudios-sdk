//
//  KRSwitchModeSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwitchModeSheet: KRBaseV {
    
    typealias SwitchModeCallbackBlock = (String) -> ()
    var switchModeCallbackBlock : SwitchModeCallbackBlock?
    
    var mode = XUserDefault.getSwapMode()
    
    lazy var professionalBtn : UIButton = {
        let object = UIButton()
        object.setImage(UIImage.themeImageNamed(imageName: "swap_actionMode_normal"), for: .normal)
        object.setImage(UIImage.themeImageNamed(imageName: "swap_actionMode_selected"), for: .selected)
        object.extSetTitle(" "+"swap_actionMode_professional".localized(), 16, UIColor.ThemeLabel.colorLite, .normal)
        object.extSetTitle(" "+"swap_actionMode_professional".localized(), 16, UIColor.ThemeLabel.colorHighlight, .selected)
        object.extSetAddTarget(self, #selector(switchMode))
        return object
    }()
    
    lazy var lightningBtn : UIButton = {
        let object = UIButton()
        object.setImage(UIImage.themeImageNamed(imageName: "swap_actionMode_normal"), for: .normal)
        object.setImage(UIImage.themeImageNamed(imageName: "swap_actionMode_selected"), for: .selected)
        object.extSetTitle(" "+"swap_actionMode_lightning".localized(), 16, UIColor.ThemeLabel.colorLite, .normal)
        object.extSetTitle(" "+"swap_actionMode_lightning".localized(), 16, UIColor.ThemeLabel.colorHighlight, .selected)
        object.extSetAddTarget(self, #selector(switchMode))
        return object
    }()
    
    lazy var professionalExplain : UILabel = {
        let object = UILabel()
        let str = "专业模式为专业用户设计涵盖全部功能，包括仓位模式的选择，保证金调整，仓位的止损止盈设置，条件单等功能，且在行情页面中，展示更多的相关信息。"
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 5
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12),
                          NSAttributedString.Key.paragraphStyle: paraph]
        object.attributedText = NSAttributedString(string: str, attributes: attributes)
        object.textColor = UIColor.ThemeLabel.colorDark
        object.numberOfLines = 0
        return object
    }()
    
    lazy var lightningExplain : UILabel = {
        let object = UILabel()
        let str = "闪电模式为日内高频交易客户设计，可帮助客户进行快速交易，因市价单在极端行情下会有损失的可能，因此只可使用逐仓模式进行交易。"
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 5
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12),
                          NSAttributedString.Key.paragraphStyle: paraph]
        object.attributedText = NSAttributedString(string: str, attributes: attributes)
        object.textColor = UIColor.ThemeLabel.colorDark
        object.numberOfLines = 0
        return object
    }()
    
    lazy var confirmBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("common_text_btnComfirm".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            guard let mySelf = self else {return}
            XUserDefault.setSwapMode(mySelf.mode)
            mySelf.switchModeCallbackBlock?(mySelf.mode)
            EXAlert.dismiss()
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func setupSubViewsLayout() {
        backgroundColor = UIColor.ThemeTab.bg
        addSubViews([professionalBtn,lightningBtn,professionalExplain,lightningExplain,confirmBtn])
        professionalBtn.snp.makeConstraints { (make) in
            make.left.equalTo(MarginSpace)
            make.top.equalTo(40)
            make.height.equalTo(24)
            make.width.lessThanOrEqualTo(120)
        }
        professionalExplain.snp.makeConstraints { (make) in
            make.left.equalTo(MarginSpace)
            make.right.equalTo(-MarginSpace)
            make.top.equalTo(professionalBtn.snp.bottom).offset(10)
        }
        lightningBtn.snp.makeConstraints { (make) in
            make.left.height.equalTo(professionalBtn)
            make.top.equalTo(professionalExplain.snp.bottom).offset(10)
            make.width.lessThanOrEqualTo(120)
        }
        lightningExplain.snp.makeConstraints { (make) in
            make.left.right.equalTo(professionalExplain)
            make.top.equalTo(lightningBtn.snp.bottom).offset(10)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(lightningExplain)
            make.top.equalTo(lightningExplain.snp.bottom).offset(40)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM - 20)
        }
        configMode()
    }
    
    func configMode() {
        if mode == "1" {
            professionalBtn.isSelected = true
            lightningBtn.isSelected = false
        } else {
            professionalBtn.isSelected = false
            lightningBtn.isSelected = true
        }
    }
}

extension KRSwitchModeSheet {
    @objc func switchMode(_ sender:UIButton) {
        sender.isSelected = true
        if professionalBtn == sender { // 选择专业
            lightningBtn.isSelected = false
            mode = "1"
        } else if lightningBtn == sender { // 选择闪电
            professionalBtn.isSelected = false
            mode = "0"
        }
    }
}
