//
//  KRBorderField.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRBorderField: KRBaseField {
    
    lazy var bgView : UIView = {
        let object = UIView()
        object.layer.borderWidth = 0.5
        object.layer.borderColor = UIColor.ThemeView.border.cgColor
        object.extSetCornerRadius(4)
        return object
    }()
    
    lazy var input : UITextField = {
        let object = UITextField()
        object.backgroundColor = UIColor.ThemeView.bg
        object.textColor = UIColor.ThemeLabel.colorLite
        object.keyboardType = .decimalPad
        object.keyboardAppearance = .dark
        object.delegate = self
        return object
    }()
    
    lazy var unitLabel : UILabel = {
        let object = UILabel.init(text: "", frame: .zero, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
        return object
    }()
    
    let style = KRTextFieldStyle.commonStyle
    fileprivate lazy var presenter : KRTextFieldPresenter = {
        return KRTextFieldPresenter.init(presenter: self)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onCreate() {
        super.onCreate()
        style.bindHighlight(textField: input, effectView: bgView,isBorder:true)
        presenter.configWithTextField(input: input)
        self.presenter.configWithTextField(input: input)
    }
    
    func setupLayout() {
        self.addSubViews([bgView])
        bgView.addSubViews([unitLabel,input])
        bgView.snp.makeConstraints { (make) in
            make.top.right.bottom.left.equalToSuperview()
        }
        unitLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-MARGIN_SPACE)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(50)
            make.centerY.equalToSuperview()
        }
        input.snp.makeConstraints { (make) in
            make.left.equalTo(MARGIN_SPACE)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(unitLabel.snp.left).offset(-10)
        }
    }
    
    override func setText(text: String) {
        input.text = text
        input.sendActions(for: .valueChanged)
    }
    
    override func setPlaceHolder(placeHolder: String , font : CGFloat = 16) {
        input.setPlaceHolderAtt(placeHolder, color: UIColor.ThemeLabel.colorDark, font: font)
    }
}

extension KRBorderField : KRTextFieldProtocol {
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

extension KRBorderField : KRTextFieldConfigurable {
    var baseField: UITextField {
        return self.input
    }
    
    var baseHighlight: UIView {
        return self
    }
}

class KRPerformInputView: KRBaseV {
    lazy var performInput : KRBorderField = {
        let object = KRBorderField()
        object.setPlaceHolder(placeHolder: "执行价格", font: 16)
        object.unitLabel.isHidden = true
        return object
    }()
    lazy var performMarketBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("市价", 16, UIColor.ThemeLabel.colorDark,UIColor.ThemeLabel.colorHighlight)
//        object.rx.tap.subscribe(onNext:{ [weak self] sender in
//
//        }).disposed(by: disposeBag)
        return object
    }()
    lazy var performLabel : KRSpaceLabel = {
        let object = KRSpaceLabel.init(text: "市价执行".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        object.showTapLabel()
        object.isHidden = true
        return object
    }()
    
    override func setupSubViewsLayout() {
        addSubViews([performInput,performMarketBtn,performLabel])
        performInput.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-68)
        }
        performMarketBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        performLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(performInput)
        }
    }
}
