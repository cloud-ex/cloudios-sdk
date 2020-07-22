//
//  KRSignVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/12.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  登录注册页面

import Foundation

enum KRSignVcType {
    case login
    case regist
}

class KRSignVc: KRNavCustomVC {
    
    var signType = KRSignVcType.login
    
    var vm : KRSignInVM = KRSignInVM()
    
    lazy var logoView : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: "signup_logo"))
        return object
    }()
    
    lazy var signupView : KRSignupView = {
        let object = KRSignupView()
        object.isHidden = true
        return object
    }()
    
    lazy var signinView : KRSignInView = {
        let object = KRSignInView()
        object.clickSignInCellBlock = {[weak self] in
            self?.toLogin()
        }
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bingVM()
    }
    
    func bingVM(){
        vm.setVC(self)
    }
    
    override func setNavCustomV() {
        let loginBtn = UIButton()
        loginBtn.extSetAddTarget(self, #selector(tapSwitchSignIn))
        loginBtn.extSetTitle("login_action_register".localized(), 16,UIColor.ThemeLabel.colorHighlight,.normal)
        loginBtn.extSetTitle("login_action_login".localized(), 16,UIColor.ThemeLabel.colorHighlight,.selected)
        loginBtn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        navCustomView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(navCustomView.popBtn)
            make.height.equalTo(16)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    override func addConstraint() {
        super.addConstraint()
        view.addSubViews([logoView,signinView,signupView])
        logoView.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom).offset(8)
            make.width.height.equalTo(60)
            make.left.equalToSuperview().offset(MARGIN_LEFT)
        }
        signinView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(logoView.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
        signupView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(logoView.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
    }
    
    deinit {
        print("释放了")
    }
}

//mark:- action
extension KRSignVc {
    @objc func tapSwitchSignIn(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        signupView.isHidden = !sender.isSelected
        signinView.isHidden = sender.isSelected
        if sender.isSelected == true { // 当前注册
            signType = .regist
        } else {    // 当前登录
            signType = .login
        }
    }
    
    // 登录
    func toLogin() {
        signinView.signInBtn.showLoading()
        vm.requestToSignin((self.signinView.accountName.input.text ?? ""), (self.signinView.password.input.text ?? "")) { [weak self] (success) in
            self?.signinView.signInBtn.hideLoading()
        }
    }
}
