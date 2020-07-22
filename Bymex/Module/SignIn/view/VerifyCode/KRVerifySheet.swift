//
//  KRVerifySheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import YYText
import RxSwift

class KRVerifySheet: UIView {
    
    typealias ClickFinishVerifyBlock = (String)->()
    var clickFinishVerifyBlock : ClickFinishVerifyBlock?
    
    var verifyType = 1
    var action = SendVerificationCode.RegistVerifyCode
    var name = ""
    
    // 安全验证
    lazy var titleView : UILabel = {
        let object = UILabel.init(text: "register_text_safeVerify".localized(), font: UIFont.ThemeFont.H3Regular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    //取消按钮
    lazy var cancelBtn : UIButton = {
        let object = UIButton()
        object.extUseAutoLayout()
        object.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        object.extSetImages([UIImage.themeImageNamed(imageName: "closed")], controlStates: [.normal])
        object.extSetAddTarget(self, #selector(clickCancelBtn))
        return object
    }()
    lazy var baseLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    lazy var contentLabel : UILabel = {
        let object = UILabel.init(text: "请输入手机+86 135****9935收到的验证码".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    // 验证码Input
    lazy var codeView: KRVerifyCodeView = {
        let object = KRVerifyCodeView.init(inputTextNum: 6)
        object.textValueChange = {str in
        }
        object.inputFinish = {[weak self] str in
            self?.finishClick(str)
        }
        return object
    }()
    lazy var sendAgainTap : UILabel = {
        let object = UILabel.init(text: "没收到验证码？点击这里重新发送".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var sendAgainTime : UIButton = {
        let object = UIButton()
        object.extSetTitle("common_action_sendAgain".localized(), 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.extSetAddTarget(self, #selector(getVerificationCode))
        return object
    }()
    lazy var confirmBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("common_text_btnFinish".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeLabel.colorDark, for: .normal)
        object.isEnabled = false
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        roundCorners(corners: [.topLeft, .topRight], radius: 10)
        setupSubviewsLayout()
        setVerificationBtn()
        codeView.textFiled.rx.text.orEmpty
        .map{ $0.count > 5}
        .share(replay: 1).subscribe(onNext: {[weak self] (bool) in
            self?.confirmBtn.isEnabled = bool
            }, onError: { (error) in
        }, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUserInfo(_ verifyType: Int, _ userName: String="", _ actionType:String="") {
        self.verifyType = verifyType
        action = actionType
        if verifyType == 1 {
            titleView.text = "手机验证"
            contentLabel.text = String(format: "请输入%@ %@收到的验证码", "手机",userName)
        } else if verifyType == 2 {
            titleView.text = "邮箱验证"
            contentLabel.text = String(format: "请输入%@ %@收到的验证码", "邮箱",userName)
        } else if verifyType == 3 {
            titleView.text = "谷歌验证"
            sendAgainTap.isHidden = true
            sendAgainTime.isHidden = true
        } else if verifyType == 4 {
            titleView.text = "安全验证"
            contentLabel.text = "请输入您的资金密码"
            sendAgainTap.isHidden = true
            sendAgainTime.isHidden = true
        }
    }
}

extension KRVerifySheet {
    
    func finishClick(_ str:String) {
        self.clickFinishVerifyBlock?(str)
    }
    
    @objc func clickCancelBtn() {
    }
    @objc func getVerificationCode(sender:UIButton) {
        sender.isEnabled = false
        codeView.cleanCodes()
        let verifyTool = KRVerifyCodeTool.sharedInstance
        verifyTool.showNetsVerifyCodeOnView(UIApplication.shared.keyWindow!)
        verifyTool.finishVerifyBlock = {[weak self] (result,validate,message) in
            guard let mySelf = self else {return}
            if result {
                SendVerificationCode().registerRequestCode(userNameType: mySelf.verifyType, mySelf.name, action: SendVerificationCode.RegistVerifyCode, validate: validate).asObservable().subscribe(onNext:{(res) in
                    if res == 1 {
                        mySelf.setVerificationBtn()
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: mySelf.disposeBag)
            }
        }
    }
    
    func setVerificationBtn() {
        sendAgainTime.setTitleColor(UIColor.ThemeLabel.colorDark, for: .normal)
        sendAgainTime.countdown(90, unit: "s", defaultValue: "common_action_sendAgain".localized(), complete: {[weak self] in
            guard let mySelf = self else{return}
            mySelf.sendAgainTime.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
        })
    }
}

extension KRVerifySheet {
    private func setupSubviewsLayout() {
        backgroundColor = UIColor.ThemeView.bg
        addSubViews([titleView,cancelBtn,baseLine,contentLabel,codeView,sendAgainTap,sendAgainTime,confirmBtn])
        titleView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(12)
            make.height.equalTo(24)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.centerY.equalTo(titleView)
            make.right.equalToSuperview().offset(-16)
        }
        baseLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(titleView.snp.bottom).offset(12)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(baseLine.snp.bottom).offset(48)
        }
        codeView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(35)
            make.top.equalTo(contentLabel.snp.bottom).offset(40)
        }
        sendAgainTap.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentLabel)
            make.top.equalTo(codeView.snp.bottom).offset(20)
        }
        sendAgainTime.snp.makeConstraints { (make) in
            make.left.equalTo(contentLabel)
            make.top.equalTo(sendAgainTap.snp.bottom).offset(10)
            make.height.equalTo(18)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentLabel)
            make.height.equalTo(44)
            make.top.equalTo(sendAgainTime.snp.bottom).offset(40)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}
