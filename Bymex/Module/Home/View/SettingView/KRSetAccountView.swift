//
//  KRSetAccountView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/23.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRSetAccountView: UIScrollView {
    
    typealias ClickComfirmBlock = ([String:String]) -> () 
    var clickComfirmBlock : ClickComfirmBlock?
    
    var vcType : KRSetAccountType = KRSetAccountType.nikeName
    
    public convenience init(_ type : KRSetAccountType) {
        self.init()
        self.bounces = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.ThemeView.bg
        self.vcType = type
        self.setAccountViewData()
        self.initLayout()
        self.bindInput()
    }
    
    func initLayout() {
        if vcType == .nikeName {
            field.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
                make.top.equalTo(40)
                make.height.equalTo(56)
            }
            confirmBtn.snp.makeConstraints { (make) in
                make.left.right.equalTo(field)
                make.top.equalTo(field.snp.bottom).offset(40)
                make.height.equalTo(44)
            }
        } else if vcType == .bingPhone {
            regionCode.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
                make.top.equalTo(40)
                make.height.equalTo(56)
            }
            field.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
                make.top.equalTo(regionCode.snp.bottom).offset(10)
                make.height.equalTo(56)
            }
            field1.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
                make.top.equalTo(field.snp.bottom).offset(10)
                make.height.equalTo(56)
            }
            confirmBtn.snp.makeConstraints { (make) in
                make.left.right.equalTo(field)
                make.top.equalTo(field1.snp.bottom).offset(40)
                make.height.equalTo(44)
            }
        } else if vcType == .bingEmail {
            field.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
                make.top.equalTo(40)
                make.height.equalTo(56)
            }
            field1.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
                make.top.equalTo(field.snp.bottom).offset(10)
                make.height.equalTo(56)
            }
            confirmBtn.snp.makeConstraints { (make) in
                make.left.right.equalTo(field)
                make.top.equalTo(field1.snp.bottom).offset(40)
                make.height.equalTo(44)
            }
        } else if vcType == .assetPwd {
            if PublicInfoManager.sharedInstance.accountEntity.asset_password_effective_time.rawValue > -2 { //设置了资金密码
                field.snp.makeConstraints { (make) in
                    make.left.equalTo(20)
                    make.width.equalTo(SCREEN_WIDTH - 40)
                    make.top.equalTo(40)
                    make.height.equalTo(56)
                }
                field1.snp.makeConstraints { (make) in
                    make.left.equalTo(20)
                    make.width.equalTo(SCREEN_WIDTH - 40)
                    make.top.equalTo(field.snp.bottom).offset(10)
                    make.height.equalTo(56)
                }
                field2.snp.makeConstraints { (make) in
                    make.left.equalTo(20)
                    make.width.equalTo(SCREEN_WIDTH - 40)
                    make.top.equalTo(field1.snp.bottom).offset(10)
                    make.height.equalTo(56)
                }
                label.snp.makeConstraints { (make) in
                    make.left.right.equalTo(field)
                    make.top.equalTo(field2.snp.bottom).offset(50)
                }
                confirmBtn.snp.makeConstraints { (make) in
                    make.left.right.equalTo(field2)
                    make.top.equalTo(label.snp.bottom).offset(10)
                    make.height.equalTo(44)
                }
            } else {
                field1.snp.makeConstraints { (make) in
                    make.left.equalTo(20)
                    make.width.equalTo(SCREEN_WIDTH - 40)
                    make.top.equalTo(40)
                    make.height.equalTo(56)
                }
                field2.snp.makeConstraints { (make) in
                    make.left.equalTo(20)
                    make.width.equalTo(SCREEN_WIDTH - 40)
                    make.top.equalTo(field1.snp.bottom).offset(10)
                    make.height.equalTo(56)
                }
                confirmBtn.snp.makeConstraints { (make) in
                    make.left.right.equalTo(field2)
                    make.top.equalTo(field2.snp.bottom).offset(40)
                    make.height.equalTo(44)
                }
            }
        }
    }
    
    private func setAccountViewData() {
        if vcType == .nikeName {
            addSubViews([field,confirmBtn])
            field.setPlaceHolder(placeHolder: "请输入昵称".localized(), font: 16)
            field.titleLabel.text = "昵称".localized()
            confirmBtn.setTitle("保存".localized(), for: .normal)
        } else if vcType == .bingPhone {
            addSubViews([field,field1,regionCode,confirmBtn])
            field.setPlaceHolder(placeHolder: "请输入手机号码".localized(), font: 16)
            field.titleLabel.text = "手机号码".localized()
            field1.setPlaceHolder(placeHolder: "请输入手机验证码".localized(), font: 16)
            field1.titleLabel.text = "手机验证码".localized()
            field1.extraLabel.textColor = UIColor.ThemeLabel.colorHighlight
            field1.extraLabel.text = "发送验证码"
            confirmBtn.setTitle("绑定".localized(), for: .normal)
        } else if vcType == .bingEmail {
            addSubViews([field,field1,confirmBtn])
            field.setPlaceHolder(placeHolder: "请输入邮箱".localized(), font: 16)
            field.titleLabel.text = "邮箱".localized()
            field1.setPlaceHolder(placeHolder: "请输入邮箱验证码".localized(), font: 16)
            field1.titleLabel.text = "邮箱验证码".localized()
            field1.extraLabel.text = "发送验证码"
            field1.extraLabel.textColor = UIColor.ThemeLabel.colorHighlight
            confirmBtn.setTitle("绑定".localized(), for: .normal)
        } else if vcType == .assetPwd {
            addSubViews([field1,field2,confirmBtn])
            field1.setPlaceHolder(placeHolder: "请输入资金密码".localized(), font: 16)
            field1.titleLabel.text = "资金密码".localized()
            field2.setPlaceHolder(placeHolder: "请再次输入资金密码".localized(), font: 16)
            field2.titleLabel.text = "确认密码".localized()
            confirmBtn.setTitle("提交".localized(), for: .normal)
            if PublicInfoManager.sharedInstance.accountEntity.asset_password_effective_time.rawValue > -2 { //设置了资金密码
                addSubViews([field,label])
                confirmBtn.setTitle("修改".localized(), for: .normal)
                field.setPlaceHolder(placeHolder: "原资金密码".localized(), font: 16)
                field.titleLabel.text = "原资金密码".localized()
                field1.titleLabel.text = "新资金密码".localized()
                label.text = "修改资金密码后24小时内禁止提币"
            }
        }
    }
    
    func bindInput() {
        switch vcType {
        case .nikeName:
            field.input.rx.text.orEmpty
            .map{ $0.count > 1}
            .share(replay: 1).subscribe(onNext: {[weak self] (bool) in
                self?.confirmBtn.isEnabled = bool
                }, onError: { (error) in
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        case .bingEmail,.bingPhone:
            var inputsAry:[Observable<String>] = []
            if PublicInfoManager.sharedInstance.accountEntity.asset_password_effective_time.rawValue > -2 {
                let rxField = field.input.rx.text.orEmpty.asObservable()
                inputsAry.append(rxField)
            }
            let rxField1 = field1.input.rx.text.orEmpty.asObservable()
            inputsAry.append(rxField1)
            Observable.combineLatest(inputsAry)
            .distinctUntilChanged()
            .map({ strary in
                var count = 0
                for str in strary {
                    if str.count >= 6 {
                        count += 1
                    }
                }
                return (count == inputsAry.count)
            })
            .bind(to:confirmBtn.rx.isEnabled)
            .disposed(by: self.disposeBag);
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickSendCode))
            field1.addGestureRecognizer(tap)
        case .assetPwd:
            var inputsAry:[Observable<String>] = []
            if PublicInfoManager.sharedInstance.accountEntity.asset_password_effective_time.rawValue > -2 {
                let rxField = field.input.rx.text.orEmpty.asObservable()
                inputsAry.append(rxField)
            }
            let rxField1 = field1.input.rx.text.orEmpty.asObservable()
            inputsAry.append(rxField1)
            let rxField2 = field2.input.rx.text.orEmpty.asObservable()
            inputsAry.append(rxField2)
            Observable.combineLatest(inputsAry)
            .distinctUntilChanged()
            .map({ strary in
                var count = 0
                for str in strary {
                    if str.count == 6 {
                        count += 1
                    }
                }
                return (count == inputsAry.count)
            })
            .bind(to:confirmBtn.rx.isEnabled)
            .disposed(by: self.disposeBag);
        default:
            break
        }
    }
    
    //MARK:- lazy
    lazy var field : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endNone)
        return object
    }()
    lazy var field1 : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .baseLine)
        object.extraLabel.text = ""
        return object
    }()
    lazy var field2 : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endNone)
        return object
    }()
    
    lazy var dialingCode = ""
    
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
    
    lazy var confirmBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("common_text_btnComfirm".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.isEnabled = false
        object.rx.tap.subscribe(onNext:{ [weak self] in
            guard let mySelf = self else {return}
            mySelf.clickComfirmBlock?(mySelf.handleParamers())
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var label : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
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
}

extension KRSetAccountView {
    func handleParamers() -> [String:String] {
        var paramers : [String:String] = [:]
        switch vcType {
        case .nikeName:
            paramers["name"] = field.input.text ?? ""
        case .bingPhone:
            paramers["phone"] = dialingCode + " " + (field.input.text ?? "")
            paramers["sms_code"] = field1.input.text ?? ""
        case .bingEmail:
            paramers["email"] = field.input.text ?? ""
            paramers["email_code"] = field1.input.text ?? ""
        case .assetPwd:
            paramers["password"] = field1.input.text ?? ""
        default:
            break
        }
        return paramers
    }
    // 发送验证码
    @objc func clickSendCode() {
        var nameType = 0
        var name = ""
        var action = ""
        if vcType == .bingPhone {
            nameType = 1
            name = dialingCode + " " + (field.input.text ?? "")
            action = SendVerificationCode.BindPhoneVerifyCode
        } else if vcType == .bingEmail {
            nameType = 2
            name = field.input.text ?? ""
            action = SendVerificationCode.BindEmailVerifyCode
        }
        let verifyTool = KRVerifyCodeTool.sharedInstance
        verifyTool.showNetsVerifyCodeOnView(UIApplication.shared.keyWindow!)
        verifyTool.finishVerifyBlock = {[weak self] (result,validate,message) in
            guard let mySelf = self else {return}
            if result {
                SendVerificationCode().registerRequestCode(userNameType: nameType, name, action: action, validate: validate).asObservable().subscribe(onNext:{(res) in
                    if res == 1 {
                        mySelf.setTimer()
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: mySelf.disposeBag)
            }
        }
    }
    
    func setTimer() {
        field1.extraLabel.textColor = UIColor.ThemeLabel.colorLite
        field1.extraLabel.countdown(90, unit: "s", defaultValue: "common_action_sendAgain".localized(), complete: {[weak self] in
            guard let mySelf = self else{return}
            mySelf.field1.extraLabel.textColor = UIColor.ThemeLabel.colorHighlight
        })
    }
}
