//
//  KRLineField.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import RxSwift

enum LineFieldType {
    case baseLine
    case iconLine
    case endNone
    case endEye
    case endBtn
}

class KRLineField: KRBaseField {
    
    var enablePrivacyModel:Bool = false
    
    private let centerYMargin:CGFloat = 28
    
    let style = KRTextFieldStyle.commonStyle
    
    var fieldType : LineFieldType = .baseLine
    
    lazy var input : UITextField = {
        let object = UITextField()
        object.font = UIFont.ThemeFont.HeadRegular
        object.textColor = UIColor.ThemeLabel.colorLite
        object.clearButtonMode = .always
        object.keyboardAppearance = .dark
        object.delegate = self
        return object
    }()
    
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "Title", frame: .zero, font: UIFont.ThemeFont.HeadRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        object.isHidden = true
        return object
    }()
    
    lazy var extraLabel : UILabel = {
        let object = UILabel.init(text: "Label", frame: .zero, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .right)
        return object
    }()
    
    lazy var baseLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.border
        return object
    }()
    
    lazy var iconView : UIImageView = {
        let object = UIImageView()
        return object
    }()
    
    lazy var endBtn: UIButton = {
        let object = UIButton()
        return object
    }()
    
    public convenience init(frame: CGRect, lineFieldType : LineFieldType) {
        self.init()
        self.fieldType = lineFieldType
        if lineFieldType == .baseLine {
            self.addSubViews([input,titleLabel,baseLine,extraLabel])
        } else if lineFieldType == .iconLine {
            self.addSubViews([input,titleLabel,baseLine,extraLabel,iconView])
        } else if lineFieldType == .endEye {
            self.addSubViews([input,titleLabel,baseLine,endBtn])
            endBtn.setImage(UIImage.themeImageNamed(imageName: "visible"), for: .normal)
            endBtn.setImage(UIImage.themeImageNamed(imageName: "hide"), for: .selected)
            endBtn.extSetAddTarget(self, #selector(privacyDidTap))
        } else if lineFieldType == .endNone {
            self.addSubViews([input,titleLabel,baseLine])
        } else if lineFieldType == .endBtn {
            self.addSubViews([input,titleLabel,baseLine,endBtn])
        }
        onCreate2()
        setupLayout()
    }
    
    fileprivate lazy var presenter : KRTextFieldPresenter = {
        return KRTextFieldPresenter.init(presenter: self)
    }()
    
    func onCreate2() {
//        self.backgroundColor = UIColor.ThemeView.bg
        if fieldType == .baseLine || fieldType == .iconLine {
            extraLabel.font = UIFont.ThemeFont.SecondaryRegular
            extraLabel.textColor = UIColor.ThemeLabel.colorMedium
            style.bindLineFieldHighlight(textField: input, lineView: baseLine, titleLabel: titleLabel, extraLabel: extraLabel)
        } else if fieldType == .endEye {
            style.bindLineFieldHighlight(textField: input, lineView: baseLine, titleLabel: titleLabel, extraLabel: endBtn)
            input.isSecureTextEntry = true
        } else if fieldType == .endNone {
            style.bindLineFieldHighlight(textField: input, lineView: baseLine, titleLabel: titleLabel, extraLabel: nil)
        } else if fieldType == .endBtn {
            style.bindLineFieldHighlight(textField: input, lineView: baseLine, titleLabel: titleLabel, extraLabel: nil)
        }
        self.presenter.configWithTextField(input: input)
    }
    
    override func setPlaceHolder(placeHolder: String="" , font : CGFloat = 16) {
        input.setPlaceHolderAtt(placeHolder, color: UIColor.ThemeLabel.colorDark, font: font)
    }
    
    override func setText(text: String) {
        input.text = text
        input.sendActions(for: .valueChanged)
    }
    
    override func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setExtraText(_ text:String) {
        extraLabel.text = text
    }
    
    @objc func privacyDidTap(_ sender: UIButton) {
        if self.enablePrivacyModel == false {
            return
        }
        if(sender.isSelected == true) {
            input.isSecureTextEntry = false
        } else {
            input.isSecureTextEntry = true
        }
        sender.isSelected = !sender.isSelected
    }
}

extension KRLineField {
    private func setupLayout() {
        baseLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        if fieldType == .endNone {
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.height.equalTo(16)
                make.centerY.equalTo(28)
            }
            input.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.centerY.equalTo(centerYMargin)
                make.right.equalToSuperview()
                make.height.equalTo(30)
            }
        } else if fieldType == .baseLine {
            extraLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.centerY.equalTo(centerYMargin)
                make.width.lessThanOrEqualTo(100)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.height.equalTo(16)
                make.centerY.equalTo(28)
            }
            input.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.centerY.equalTo(centerYMargin)
                make.right.equalTo(extraLabel.snp.left).offset(-10)
                make.height.equalTo(30)
            }
        } else if fieldType == .iconLine {
            extraLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.centerY.equalTo(centerYMargin)
                make.width.lessThanOrEqualTo(50)
            }
            iconView.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.height.equalTo(21.2)
                make.centerY.equalTo(centerYMargin)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(iconView.snp.right).offset(12)
                make.height.equalTo(16)
                make.centerY.equalTo(24)
            }
            input.snp.makeConstraints { (make) in
                make.left.equalTo(iconView.snp.right).offset(12)
                make.centerY.equalTo(centerYMargin)
                make.right.equalTo(extraLabel.snp.left).offset(-10)
                make.height.equalTo(30)
            }
        } else if fieldType == .endEye {
            endBtn.snp.makeConstraints { (make) in
                make.centerY.equalTo(28)
                make.right.equalToSuperview()
                make.width.height.equalTo(24)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.height.equalTo(16)
                make.centerY.equalTo(28)
            }
            input.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.centerY.equalTo(centerYMargin)
                make.right.equalTo(endBtn.snp.left).offset(-10)
                make.height.equalTo(30)
            }
        } else if fieldType == .endBtn {
            endBtn.snp.makeConstraints { (make) in
                make.centerY.equalTo(28)
                make.right.equalToSuperview()
                make.height.equalTo(24)
                make.width.lessThanOrEqualTo(50)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.height.equalTo(16)
                make.centerY.equalTo(28)
            }
            input.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.centerY.equalTo(centerYMargin)
                make.right.equalTo(endBtn.snp.left).offset(-10)
                make.height.equalTo(30)
            }
        }
    }
}

extension KRLineField : KRTextFieldProtocol {
    func textValueChanged(value: String) {
        self.textfieldValueChangeBlock?(value)
    }
    
    func inputDidBeginEditing() {
        self.hideError(input)
        self.textfieldDidBeginBlock?()
    }
    
    func inputDidEndEditing() {
        self.textfieldDidEndBlock?()
    }
}

extension KRLineField : KRTextFieldConfigurable {
    var baseField: UITextField {
        return self.input
    }
    
    var baseHighlight: UIView {
        return self
    }
}
