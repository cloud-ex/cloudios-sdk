//
//  KRSignupView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import YYText
import RxSwift

class KRSignupView: KRBaseV {
    
    var signupVM: KRSignVM?
    
    var dialingCode = ""
    
    var nameType = 1
    
    var userName = ""
    
    lazy var titleView : UILabel = {
        let object = UILabel.init(text: "register_action_phone".localized(), font: UIFont.ThemeFont.H2Bold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var emailName : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endNone)
        object.setPlaceHolder(placeHolder: "register_text_mail".localized(), font: 16)
        object.titleLabel.text = "register_text_mail".localized()
        object.isHidden = true
        return object
    }()
    lazy var regionCode : KRSelectedField = {
        let object = KRSelectedField.init(frame: .zero)
        object.textfieldDidTapBlock = {
            self.clickRegion()
        }
        let defaultCountryCode = PublicInfoEntity.sharedInstance.default_country_code
        let defaultCountryCodeReal = PublicInfoEntity.sharedInstance.default_country_code_real
        if let region = CountryList.getRegionWithNumber(defaultCountryCodeReal){
            if KRBasicParameter.isHan() == true{
                object.input.text = region.cnName + " " + region.dialingCode
            }else{
                object.input.text = region.enName + " " + region.dialingCode
            }
            dialingCode = region.dialingCode
        }else if let region = CountryList.getRegion(defaultCountryCode){
            if KRBasicParameter.isHan() == true{
                object.input.text = region.cnName + " " + region.dialingCode
            }else{
                object.input.text = region.enName + " " + region.dialingCode
            }
            dialingCode = region.dialingCode
        }
        return object
    }()
    lazy var phoneName : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endNone)
        object.titleLabel.text = "register_text_phone".localized()
        object.setPlaceHolder(placeHolder: "register_text_phone".localized(), font: 16)
        return object
    }()
    lazy var password : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endEye)
        object.titleLabel.text = "register_action_setPassword".localized()
        object.setPlaceHolder(placeHolder: "register_action_setPassword".localized(), font: 16)
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
    lazy var agreementLabel : YYLabel = {
        let object = YYLabel()
        object.extUseAutoLayout()
        object.numberOfLines = 0
        return object
    }()
    lazy var signupBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("login_action_register".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.isEnabled = false
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.toSignIn()
        }).disposed(by: disposeBag)
        return object
    }()
    lazy var switchSign : UIButton = {
        let object = UIButton()
        object.extSetTitle("register_action_email".localized(), 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.extSetTitle("register_action_phone".localized(), 14, UIColor.ThemeLabel.colorHighlight, .selected)
        object.extSetAddTarget(self, #selector(tapSwitchSign))
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bingVM(phoneName.input.rx.text.orEmpty.asObservable())
    }
    
    func bingVM(_ username: Observable<String>) {
        self.signupVM = KRSignVM.init(input:
            (username: username,
             password: password.input.rx.text.orEmpty.asObservable(),
             repeatedPassword: repeatedPassword.input.rx.text.orEmpty.asObservable(),
             loginTaps: signupBtn.rx.tap.asObservable()
            ))

        self.signupVM!.signupEnabled
            .subscribe(onNext: { [weak self] valid  in
                self?.signupBtn.isEnabled = valid
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([titleView,emailName,phoneName,password,repeatedPassword,agreementLabel,signupBtn,switchSign,regionCode])
        titleView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalToSuperview()
            make.height.equalTo(24)
        }
        regionCode.snp.makeConstraints { (make) in
            make.left.equalTo(titleView)
            make.right.equalToSuperview().offset(-MARGIN_LEFT)
            make.height.equalTo(Margin_FieldH)
            make.top.equalTo(titleView.snp.bottom).offset(40)
        }
        emailName.snp.makeConstraints { (make) in
            make.edges.equalTo(regionCode)
        }
        phoneName.snp.makeConstraints { (make) in
            make.width.height.left.equalTo(regionCode)
            make.top.equalTo(regionCode.snp.bottom).offset(MarginSpace)
        }
        password.snp.makeConstraints { (make) in
            make.width.height.left.equalTo(phoneName)
            make.top.equalTo(phoneName.snp.bottom).offset(MarginSpace)
        }
        repeatedPassword.snp.makeConstraints { (make) in
            make.width.height.left.equalTo(emailName)
            make.top.equalTo(password.snp.bottom).offset(MarginSpace)
        }
        agreementLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleView)
            make.right.equalToSuperview().offset(-MARGIN_LEFT)
            make.top.equalTo(repeatedPassword.snp.bottom).offset(20)
        }
        signupBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(emailName)
            make.top.equalTo(agreementLabel.snp.bottom).offset(40)
            make.height.equalTo(44)
        }
        switchSign.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(signupBtn.snp.bottom).offset(30)
        }
        addAttTap()
    }
}

extension KRSignupView {
    
    private func requestSignup(_ code :String) {
        let password = self.password.input.text ?? ""
        appAPI.rx.request(AppAPIEndPoint.register(registerType: self.nameType, userName: self.userName, password: password, code: code, inviter_id: "")).MJObjectMap(KRAccountEntity.self).subscribe(onSuccess: { [weak self] (entity) in
            EXAlert.dismiss()
            entity.dwq = password
            PublicInfoManager.handleLoginSuccess(entity)
            self?.yy_viewController?.navigationController?.popToRootViewController(animated: true)
        }) { (error) in
            print(error)
        }.disposed(by: disposeBag)
    }
    
    private func toSignIn() {
        signupBtn.showLoading()
        let verifyTool = KRVerifyCodeTool.sharedInstance
        verifyTool.showNetsVerifyCodeOnView(self)
        verifyTool.finishVerifyBlock = {[weak self] (result,validate,message) in
            guard let mySelf = self else {return}
            if result {
                mySelf.userName = String(format: "%@ %@",mySelf.dialingCode,mySelf.phoneName.input.text ?? "")
                if mySelf.switchSign.isSelected == true { // 邮箱
                    mySelf.nameType = 2
                    mySelf.userName = mySelf.emailName.input.text ?? ""
                }
                SendVerificationCode().registerRequestCode(userNameType: mySelf.nameType, mySelf.userName, action: SendVerificationCode.RegistVerifyCode, validate: validate).asObservable().subscribe(onNext:{(res) in
                    if res == 1 {
                        let verifySheet = KRVerifySheet(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 380))
                        verifySheet.setUserInfo(mySelf.nameType, mySelf.userName, SendVerificationCode.RegistVerifyCode)
                        verifySheet.clickFinishVerifyBlock = { code in
                            mySelf.requestSignup(code)
                        }
                        EXAlert.showSheet(sheetView: verifySheet)
                    }
                    mySelf.signupBtn.hideLoading()
                }, onError: {(error) in
                    mySelf.signupBtn.hideLoading()
                }, onCompleted: nil, onDisposed: nil).disposed(by: mySelf.disposeBag)
            } else {
                mySelf.signupBtn.hideLoading()
            }
        }
        verifyTool.cancelVerifyBlock = {[weak self] in
            self?.signupBtn.hideLoading()
        }
    }
    
    private func clickRegion() {
        let vc = KRRegionVc()
        vc.clickRegionCellBlock = {[weak self](entity) in
            if KRBasicParameter.isHan() == true{
                self?.regionCode.input.text = entity.cnName + " " + entity.dialingCode
            }else{
                self?.regionCode.input.text = entity.enName + " " + entity.dialingCode
            }
            self?.dialingCode = entity.dialingCode
        }
        vc.modalPresentationStyle = .fullScreen
        self.yy_viewController?.navigationController?.present(vc, animated: true, completion: nil)
    }
    @objc func tapSwitchSign(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        regionCode.isHidden = sender.isSelected
        phoneName.isHidden = sender.isSelected
        emailName.isHidden = !sender.isSelected
        if switchSign.isSelected == true { // 邮箱注册
            UIView.animate(withDuration: 0.3) {
                self.password.snp.remakeConstraints { (make) in
                    make.width.height.left.equalTo(self.emailName)
                    make.top.equalTo(self.emailName.snp.bottom).offset(self.MarginSpace)
                }
                self.titleView.text = "register_action_email".localized()
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
            bingVM(emailName.input.rx.text.orEmpty.asObservable())
        } else { // 手机注册
            UIView.animate(withDuration: 0.3) {
                self.password.snp.remakeConstraints { (make) in
                    make.width.height.left.equalTo(self.phoneName)
                    make.top.equalTo(self.phoneName.snp.bottom).offset(self.MarginSpace)
                }
                self.titleView.text = "register_action_phone".localized()
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
           bingVM(phoneName.input.rx.text.orEmpty.asObservable())
        }
    }
}

extension KRSignupView {
    
    //添加手势
    func addAttTap(){
        let accatt = NSMutableAttributedString.init().add(string: "register_tip_agreement".localized(), attrDic: [.foregroundColor : UIColor.ThemeLabel.colorMedium, .font : UIFont.ThemeFont.SecondaryRegular]).add(string: "register_action_agreement".localized(), attrDic: [.foregroundColor : UIColor.ThemeLabel.colorHighlight , .font : UIFont.ThemeFont.SecondaryRegular]).add(string: "register_tip_and".localized(), attrDic: [.foregroundColor : UIColor.ThemeLabel.colorMedium, .font : UIFont.ThemeFont.SecondaryRegular]).add(string: "register_action_declaration".localized(), attrDic: [.foregroundColor : UIColor.ThemeLabel.colorHighlight , .font : UIFont.ThemeFont.SecondaryRegular])
        // 用户协议
        accatt.highLightTap((accatt.string as NSString).range(of: "register_action_agreement".localized()), {[weak self] (view, attstr, range, rect) in
            guard let mySelf = self else{return}
//            let statementVC = StatementVC()
//            statementVC.titleStr = "register_action_agreement".localized()
//            mySelf.yy_viewController?.navigationController?.pushViewController(statementVC, animated: true)
        })
        accatt.highLightTap((accatt.string as NSString).range(of: "register_action_declaration".localized()), {[weak self] (view, attstr, range, rect) in
                    guard let mySelf = self else{return}
        //            let statementVC = StatementVC()
        //            statementVC.titleStr = "register_action_agreement".localized()
        //            mySelf.yy_viewController?.navigationController?.pushViewController(statementVC, animated: true)
                })
        agreementLabel.attributedText = accatt
    }
}
