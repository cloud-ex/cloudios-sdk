//
//  KRSignInView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSignInView: KRBaseV {
    
    typealias ClickSignInCellBlock = ()->()
    var clickSignInCellBlock : ClickSignInCellBlock?
    
    lazy var titleView : UILabel = {
        let object = UILabel.init(text: "login_action_login".localized(), font: UIFont.ThemeFont.H2Bold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var accountName : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endNone)
        object.setPlaceHolder(placeHolder: "login_text_phoneOrMail".localized(), font: 16)
        object.titleLabel.text = "login_text_phoneOrMail".localized()
        return object
    }()
    lazy var password : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endEye)
        object.titleLabel.text = "login_text_loginPwd".localized()
        object.setPlaceHolder(placeHolder: "login_text_loginPwd".localized(), font: 16)
        object.enablePrivacyModel = true
        return object
    }()
    lazy var forgetPwd : UIButton = {
        let object = UIButton()
        object.extSetAddTarget(self, #selector(tapForgetPassword))
        object.extSetTitle("login_text_forgetPwd".localized(), 12,UIColor.ThemeLabel.colorHighlight,.normal)
        return object
    }()
    lazy var signInBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("login_action_login".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.isEnabled = false
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.accountName.input.resignFirstResponder()
            self?.password.input.resignFirstResponder()
            self?.clickSignInCellBlock?()
        }).disposed(by: disposeBag)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bingVM()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bingVM() {
        let signupVM = KRSignVM.init(signInput:
            (username: accountName.input.rx.text.orEmpty.asObservable(),
             password: password.input.rx.text.orEmpty.asObservable(),
             loginTaps: signInBtn.rx.tap.asObservable()
            ))

        signupVM.signupEnabled
            .subscribe(onNext: { [weak self] valid  in
                self?.signInBtn.isEnabled = valid
            })
            .disposed(by: disposeBag)
        
//        signupVM.signupResult
//            .subscribe(onNext: {result in
//                print(result)
//            })
//            .disposed(by: disposeBag)
    }
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([titleView,accountName,password,forgetPwd,signInBtn])
        titleView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalToSuperview()
            make.height.equalTo(24)
        }
        accountName.snp.makeConstraints { (make) in
            make.left.equalTo(titleView)
            make.right.equalToSuperview().offset(-MARGIN_LEFT)
            make.height.equalTo(Margin_FieldH)
            make.top.equalTo(titleView.snp.bottom).offset(40)
        }
        password.snp.makeConstraints { (make) in
            make.width.height.left.equalTo(accountName)
            make.top.equalTo(accountName.snp.bottom).offset(MarginSpace)
        }
        forgetPwd.snp.makeConstraints { (make) in
            make.top.equalTo(password.snp.bottom).offset(20)
            make.left.equalTo(titleView)
            make.height.equalTo(16)
        }
        signInBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(accountName)
            make.top.equalTo(forgetPwd.snp.bottom).offset(40)
            make.height.equalTo(44)
        }
    }
}

extension KRSignInView {
    @objc func tapForgetPassword() {
        let resertVc = KRResertVc()
        self.yy_viewController?.navigationController?.pushViewController(resertVc, animated: true)
    }
}

