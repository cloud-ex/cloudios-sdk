//
//  KRAccountHeadView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/16.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRAccountHeadView: KRBaseV {
    
    lazy var iconView : UIImageView = {
        let object = UIImageView()
        object.extSetCornerRadius(20)
        object.image = UIImage.themeImageNamed(imageName: "home_account")
        return object
    }()
    lazy var nickname : UILabel = {
        let object = UILabel.init(text: "Hi,User", font: UIFont.ThemeFont.H3Regular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var uidLabel : UILabel = {
        let object = UILabel.init(text: "UID:100001", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var duplicatBtn : UIButton = {
        let object = UIButton()
        object.extSetImages([UIImage.themeImageNamed(imageName: "account_copy")], controlStates: [.normal])
        object.rx.tap.subscribe(onNext:{ [weak self] in
            UIPasteboard.general.string = self?.uidLabel.text
            EXAlert.showSuccess(msg: "common_tip_copySuccess".localized())
        }).disposed(by: disposeBag)
        object.isHidden = true
        return object
    }()
    lazy var nextBtn : UIButton = {
        let object = UIButton()
        object.extSetImages([UIImage.themeImageNamed(imageName: "account_next")], controlStates: [.normal])
        object.rx.tap.subscribe(onNext:{ [weak self] in
            if KRBusinessTools.loginStatus() == false {
                let vc = KRSignVc()
                self?.yy_viewController?.gy_sidePushViewController(viewController: vc)
            } else {
                let personVc = KRSettingVc.init(.setPersonalInfo)
                personVc.setTitle("个人信息".localized())
                self?.yy_viewController?.gy_sidePushViewController(viewController: personVc)
            }
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var inviteView: UIView = {
        let object = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.width - 30, height: 54))
        object.setGradientlayerColors([UIColor.ThemeView.bgIconh.cgColor,UIColor.ThemeView.bgIconh50.cgColor])
        object.extSetCornerRadius(4)
        return object
    }()
    lazy var inviteName : UILabel = {
        let object = UILabel.init(text: "account_text_entireBroker".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorHighlight, alignment: .left)
        return object
    }()
    lazy var inviteContent : UILabel = {
        let object = UILabel.init(text: "account_action_shareInvite".localized(), font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorHighlight, alignment: .left)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if KRBusinessTools.loginStatus() {
            nickname.text = "Hi," + (XUserDefault.getActiveAccount()?.account_name ?? "")
            uidLabel.text = "UID:" + (XUserDefault.getActiveAccount()?.uid ?? "--")
            duplicatBtn.isHidden = false
        } else {
            nickname.text = "account_text_pleaseLogin".localized()
            uidLabel.text = "account_text_welcome".localized()
            duplicatBtn.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubViewsLayout() {
        addSubViews([iconView,nickname,uidLabel,duplicatBtn,nextBtn,inviteView])
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalToSuperview()
            make.width.height.equalTo(40)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(25)
        }
        nickname.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(iconView.snp.right).offset(15)
            make.height.equalTo(22)
            make.right.equalTo(nextBtn.snp_left)
        }
        uidLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nickname)
            make.top.equalTo(nickname.snp.bottom).offset(2)
            make.height.equalTo(16)
        }
        duplicatBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(uidLabel)
            make.left.equalTo(uidLabel.snp.right)
            make.width.height.equalTo(16)
        }
        inviteView.snp.makeConstraints { (make) in
            make.left.equalTo(iconView)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(iconView.snp.bottom).offset(24)
            make.height.equalTo(54)
        }
        inviteView.addSubViews([inviteName,inviteContent])
        inviteName.snp.makeConstraints { (make) in
            make.left.equalTo(45)
            make.top.equalTo(8)
            make.height.equalTo(20)
        }
        inviteContent.snp.makeConstraints { (make) in
            make.left.equalTo(inviteName)
            make.top.equalTo(inviteName.snp.bottom)
            make.height.equalTo(15)
        }
    }
}
