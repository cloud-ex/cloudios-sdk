//
//  KRResertVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  找回密码

import Foundation

enum KRResertVcType {
    case accountName
    case accountPwd
}

class KRResertVc: KRNavCustomVC {
    var resertVcType = KRResertVcType.accountName
    
    var resertCode = ""
    
    lazy var logoView : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: "signup_logo"))
        return object
    }()
    
    lazy var titleView : UILabel = {
        let object = UILabel.init(text: "账户".localized(), font: UIFont.ThemeFont.H2Bold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    lazy var accountView : KRResertAccountView = {
        let object = KRResertAccountView()
        object.clickNextBtnBlock = {[weak self] in
            self?.toResertPwd()
        }
        return object
    }()
    
    lazy var resertpwdView : KRResertPwdView = {
        let object = KRResertPwdView()
        object.clickNextBtnBlock = {[weak self] in
            self?.sendResertRequest()
        }
        object.isHidden = true;
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addConstraint() {
        super.addConstraint()
        view.addSubViews([logoView,titleView,accountView,resertpwdView])
        logoView.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom).offset(8)
            make.width.height.equalTo(60)
            make.left.equalToSuperview().offset(MARGIN_LEFT)
        }
        titleView.snp.makeConstraints { (make) in
            make.left.equalTo(logoView)
            make.top.equalTo(logoView.snp.bottom).offset(12)
        }
        accountView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
        resertpwdView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
}

extension KRResertVc {
    func toResertPwd() {
        accountView.nextBtn.showLoading()
        let verifyTool = KRVerifyCodeTool.sharedInstance
        verifyTool.showNetsVerifyCodeOnView(self.view)
        verifyTool.finishVerifyBlock = {[weak self] (result,validate,message) in
            guard let mySelf = self else {return}
            if result {
                let name = "+86 " + mySelf.accountView.accountName.input.text!
                SendVerificationCode().registerRequestCode(userNameType: 1, name, action: SendVerificationCode.ResetPasswordVerifyCode, validate: validate).asObservable().subscribe(onNext:{(res) in
                    if res == 1 {
                        let verifySheet = KRVerifySheet(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 380))
                        verifySheet.setUserInfo(1, name, SendVerificationCode.ResetPasswordVerifyCode)
                        verifySheet.clickFinishVerifyBlock = { code in
                            EXAlert.dismiss()
                            mySelf.resertCode = code
                            mySelf.resertVcType = .accountPwd
                            mySelf.accountView.isHidden = true
                            mySelf.resertpwdView.isHidden = false
                        }
                        EXAlert.showSheet(sheetView: verifySheet)
                    }
                    mySelf.accountView.nextBtn.hideLoading()
                }, onError: {(error) in
                    mySelf.accountView.nextBtn.hideLoading()
                }, onCompleted: nil, onDisposed: nil).disposed(by: mySelf.disposeBag)
            } else {
                mySelf.accountView.nextBtn.hideLoading()
            }
        }
        verifyTool.cancelVerifyBlock = {[weak self] in
            self?.accountView.nextBtn.hideLoading()
        }
    }
    
    func sendResertRequest() {
        resertpwdView.submitBtn.showLoading()
        appAPI.rx.request(AppAPIEndPoint.resetPassword(resertType: 1, userName: accountView.accountName.input.text!, password: resertpwdView.password.input.text!, code: resertCode)).MJObjectMap(NSDictionary.self).subscribe(onSuccess: {[weak self] (entity) in
            guard let mySelf = self else {return}
            mySelf.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }.disposed(by: self.disposeBag)
    }
}
