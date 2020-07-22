//
//  KRResertPwdView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRResertPwdView: KRBaseV {
    typealias ClickNextBtnBlock = ()->()
    var clickNextBtnBlock : ClickNextBtnBlock?
    
    lazy var password : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endEye)
        object.titleLabel.text = "register_action_setPassword".localized()
        object.setPlaceHolder(placeHolder: "resert_text_passwordGroup".localized(), font: 16)
        object.enablePrivacyModel = true
        return object
    }()
    lazy var repeatedPassword : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endEye)
        object.titleLabel.text = "register_action_repeatedPassword".localized()
        object.setPlaceHolder(placeHolder: "register_action_repeatedPassword".localized(), font: 16)
        object.enablePrivacyModel = true
        return object
    }()
    lazy var tipsLabel : UILabel = {
        let object = UILabel.init(text: "resert_text_forbbiden".localized(), font: UIFont.ThemeFont.SecondaryBold, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        object.numberOfLines = 0
        return object
    }()
    lazy var submitBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("login_action_login".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.clickNextBtnBlock?()
        }).disposed(by: disposeBag)
        object.isEnabled = false
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bingVM()
    }
    
    func bingVM() {
        let resertVM = KRSignVM.init(resertInput:
            (password: password.input.rx.text.orEmpty.asObservable(),
             repeatedPassword:repeatedPassword.input.rx.text.orEmpty.asObservable(),
             loginTaps: submitBtn.rx.tap.asObservable()
            ))
        resertVM.signupEnabled
            .subscribe(onNext: { [weak self] valid  in
                self?.submitBtn.isEnabled = valid
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([password,repeatedPassword,tipsLabel,submitBtn])
        password.snp.makeConstraints { (make) in
            make.left.equalTo(MARGIN_LEFT)
            make.right.equalTo(-MARGIN_LEFT)
            make.top.equalToSuperview()
            make.height.equalTo(56)
        }
        repeatedPassword.snp.makeConstraints { (make) in
            make.width.height.left.equalTo(password)
            make.top.equalTo(password.snp.bottom).offset(MarginSpace)
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(password)
            make.top.equalTo(repeatedPassword.snp.bottom).offset(40)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(password)
            make.height.equalTo(44)
            make.top.equalTo(tipsLabel.snp.bottom).offset(10)
        }
    }
}
