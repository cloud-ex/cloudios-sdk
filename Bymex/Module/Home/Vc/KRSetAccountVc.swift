//
//  KRSetAccountVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/23.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum KRSetAccountType {
    case none
    case iconSet    // 头像
    case nikeName   // 昵称
    case bingPhone  // 绑定手机
    case bingEmail  // 绑定邮箱
    case assetPwd   // 资金密码(设置跟修改)
    case effective  // 资金密码有效时长
    case google     // 谷歌验证码(设置跟修改)
    case gesture    // 手势
    case finger     // 指纹解锁
    case faceID     // 面部解锁
}

class KRSetAccountVc : KRNavCustomVC {
    
    typealias HandleRequestBlock = (Bool) -> ()
    var handleRequestBlock : HandleRequestBlock?
    
    var vcType = KRSetAccountType.nikeName
    
    private lazy var scollView : KRSetAccountView = {
        let object = KRSetAccountView.init(vcType)
        object.bounces = false
        object.showsVerticalScrollIndicator = false
        object.showsHorizontalScrollIndicator = false
        object.backgroundColor = UIColor.ThemeView.bg
        object.clickComfirmBlock = {[weak self] paramers in
            self?.handleSetAccount(paramers)
        }
        return object
    }()
    
    private lazy var googleView : KRSetGoogleView = {
        let object = KRSetGoogleView.init(frame: CGRect.zero)
        object.bounces = false
        object.showsVerticalScrollIndicator = false
        object.showsHorizontalScrollIndicator = false
        object.backgroundColor = UIColor.ThemeView.bg
        object.requestBingResult = {[weak self] result in
            self?.handleSetAccount([:])
        }
        return object
    }()
    
    public convenience init(_ type : KRSetAccountType) {
        self.init()
        self.vcType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadV()
    }
    
    func loadV() {
        switch vcType {
        case .nikeName,.bingPhone,.bingEmail,.assetPwd:
            if #available(iOS 11.0, *) {
                scollView.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
            view.addSubview(scollView)
            scollView.snp_makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(self.navCustomView.snp_bottom)
            }
        case .google:
            if #available(iOS 11.0, *) {
               googleView.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
            view.addSubview(googleView)
            googleView.snp_makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(self.navCustomView.snp_bottom)
            }
        default:
            break
        }
    }
}

extension KRSetAccountVc {
    func handleSetAccount(_ paramers : [String: String]) {
        scollView.confirmBtn.showLoading()
        switch vcType {
        case .nikeName:
            let name = paramers["name"] ?? ""
            appAPI.rx.request(AppAPIEndPoint.accountName(name: name)).MJObjectMap(KRAccountEntity.self).subscribe(onSuccess: { [weak self] (entity) in
                PublicInfoManager.updataAccountName(name)
                self?.scollView.confirmBtn.hideLoading()
                self?.navigationController?.popViewController(animated: true)
                self?.handleRequestBlock?(true)
            }) { [weak self] (error) in
                self?.scollView.confirmBtn.hideLoading()
            }.disposed(by: self.disposeBag)
        case .bingPhone:
            let phone = paramers["phone"] ?? ""
            let sms_code = paramers["sms_code"] ?? ""
            bingPhoneOrEmail(phone, nameCode: sms_code)
        case .bingEmail:
            let email = paramers["email"] ?? ""
            let email_code = paramers["email_code"] ?? ""
            bingPhoneOrEmail(email, nameCode: email_code)
        case .google:
            self.navigationController?.popViewController(animated: true)
            self.handleRequestBlock?(true)
        case .assetPwd:
            let password = paramers["password"] ?? ""
            settingAssertPwd(password)
            break
        default:
            break
        }
    }
    
    // MARK:-设置或者修改资金密码
    private func settingAssertPwd(_ password:String) {
        if PublicInfoManager.sharedInstance.accountEntity.asset_password_effective_time.rawValue == -2 { // 设置
            requestSetAssetPwd(1,password,"","")
        } else {
            let verifyTool = KRVerifyCodeTool.sharedInstance
            verifyTool.showNetsVerifyCodeOnView(view)
            verifyTool.finishVerifyBlock = {[weak self] (result,validate,message) in
                guard let mySelf = self else {return}
                if result {
                    let name = XUserDefault.getActiveAccount()?.phone ?? ""
                    SendVerificationCode().registerRequestCode(userNameType: 1, name, action: SendVerificationCode.ResetAssetPasswordVerifyCode, validate: validate).asObservable().subscribe(onNext:{(res) in
                        if res == 1 {
                            let verifySheet = KRVerifySheet(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 380))
                            verifySheet.setUserInfo(1, name, SendVerificationCode.ResetAssetPasswordVerifyCode)
                            verifySheet.clickFinishVerifyBlock = { code in
                                EXAlert.dismiss()
                                mySelf.showGoogleAlert(password,code)
                            }
                            EXAlert.showSheet(sheetView: verifySheet)
                        } else {
                            mySelf.scollView.confirmBtn.hideLoading()
                        }
                    }, onError: {(error) in
                        mySelf.scollView.confirmBtn.hideLoading()
                    }, onCompleted: nil, onDisposed: nil).disposed(by: mySelf.disposeBag)
                } else {
                    mySelf.scollView.confirmBtn.hideLoading()
                }
            }
            verifyTool.cancelVerifyBlock = {[weak self] in
                self?.scollView.confirmBtn.hideLoading()
            }
        }
    }
    
    func showGoogleAlert(_ password:String, _ sms_code : String) {
        let verifySheet = KRVerifySheet(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 380))
        verifySheet.setUserInfo(3, "", "")
        verifySheet.clickFinishVerifyBlock = {[weak self] code in
            EXAlert.dismiss()
            self?.requestSetAssetPwd(2,password,sms_code,code)
        }
        EXAlert.showSheet(sheetView: verifySheet)
    }
    
    func requestSetAssetPwd(_ action : Int, _ pwd :String,_ code: String,_ ga_code : String) {
        appAPI.rx.request(AppAPIEndPoint.assetPassword(action: action, pwd: pwd, code: code, ga_code:ga_code)).MJObjectMap(KRAccountEntity.self).subscribe(onSuccess: {[weak self] (entity) in
            PublicInfoManager.updataAccountPasswordEffective(AssetPasswordEffectiveTimeType.AssetPasswordEffectiveTimeEffectiveneTH)
            self?.handleRequestBlock?(true)
            self?.navigationController?.popViewController(animated: true)
        }) { (error) in
            print(error)
            self.scollView.confirmBtn.hideLoading()
        }.disposed(by: self.disposeBag)
    }
    
    
    // MARK:-绑定邮箱或者手机号
    private func bingPhoneOrEmail(_ name :String, nameCode: String) {
        var nameType = 0
        var userName = ""
        var action = ""
        if vcType == .bingPhone { // 绑定手机则发送邮箱验证码
            nameType = 2
            userName = XUserDefault.getActiveAccount()?.email ?? ""
            action = SendVerificationCode.BindPhoneVerifyCode
        } else if vcType == .bingEmail {
            nameType = 1
            userName = XUserDefault.getActiveAccount()?.phone ?? ""
            action = SendVerificationCode.BindEmailVerifyCode
        }
        let verifyTool = KRVerifyCodeTool.sharedInstance
        verifyTool.showNetsVerifyCodeOnView(view)
        verifyTool.finishVerifyBlock = {[weak self] (result,validate,message) in
            guard let mySelf = self else {return}
            if result {
                SendVerificationCode().registerRequestCode(userNameType: nameType, userName, action: action, validate: validate).asObservable().subscribe(onNext:{(res) in
                    if res == 1 {
                        let verifySheet = KRVerifySheet(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 380))
                        verifySheet.setUserInfo(nameType, userName, action)
                        verifySheet.clickFinishVerifyBlock = { code in
                            mySelf.toBing(name, nameCode: nameCode, code: code)
                            EXAlert.dismiss()
                        }
                        EXAlert.showSheet(sheetView: verifySheet)
                    } else {
                        mySelf.scollView.confirmBtn.hideLoading()
                    }
                }, onError: {(error) in
                    mySelf.scollView.confirmBtn.hideLoading()
                }, onCompleted: nil, onDisposed: nil).disposed(by: mySelf.disposeBag)
            } else {
                mySelf.scollView.confirmBtn.hideLoading()
            }
        }
        verifyTool.cancelVerifyBlock = {[weak self] in
            self?.scollView.confirmBtn.hideLoading()
        }
    }
    
    func toBing(_ name : String , nameCode : String, code : String) {
        if vcType == .bingPhone { // 绑定手机则发送邮箱验证码
            appAPI.rx.request(AppAPIEndPoint.bindPhone(phone: name, email_code: code, sms_code: nameCode)).MJObjectMap(KRAccountEntity.self).subscribe(onSuccess: { [weak self] (entity) in
                self?.scollView.confirmBtn.hideLoading()
                PublicInfoManager.updataAccountPhone(name)
                self?.handleRequestBlock?(true)
                self?.navigationController?.popViewController(animated: true)
            }) {[weak self] (error) in
                self?.scollView.confirmBtn.hideLoading()
            }.disposed(by: self.disposeBag)
        } else if vcType == .bingEmail {
            appAPI.rx.request(AppAPIEndPoint.bindEmail(email: name, email_code: nameCode, sms_code: code)).MJObjectMap(KRAccountEntity.self).subscribe(onSuccess: { [weak self] (entity) in
                self?.scollView.confirmBtn.hideLoading()
                PublicInfoManager.updataAccountEmail(name)
                self?.handleRequestBlock?(true)
                self?.navigationController?.popViewController(animated: true)
            }) {[weak self] (error) in
                self?.scollView.confirmBtn.hideLoading()
            }.disposed(by: self.disposeBag)
        }
    }
}
