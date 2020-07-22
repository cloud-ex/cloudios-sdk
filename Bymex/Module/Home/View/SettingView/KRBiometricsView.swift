//
//  KRBiometricsView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRBiometricsView: UIView {
    
    typealias HandleBiometricsBlock = (Int) -> () // 0 :同意指纹，1 :同意面容
    var handleBiometricsBlock : HandleBiometricsBlock?
    
    typealias ClickVerifyBlock = (Int) -> () // 0 :指纹解锁，1 : 脸部识别
    var clickVerifyBlock : ClickVerifyBlock?
    
    var vType = KRBiometricsType.openFinger
    public convenience init(_ type : KRBiometricsType) {
        self.init()
        vType = type
        setupSubViewsLayout()
    }
    
    private func setupSubViewsLayout() {
        switch vType {
        case .openFinger,.openFace:
            addSubViews([imgV,contentLabel,agreeBtn])
            if vType == .openFinger {
                imgV.image = UIImage.themeImageNamed(imageName: "account_finger")
                contentLabel.text = "开启后，通过验证“指纹解锁”，进行快速登录"
            } else {
                imgV.image = UIImage.themeImageNamed(imageName: "account_face")
                contentLabel.text = "开启后，通过验证“Face ID”，进行快速登录"
            }
            imgV.snp.makeConstraints { (make) in
                make.top.equalTo(60)
                make.centerX.equalTo(SCREEN_WIDTH * 0.5)
                make.width.height.equalTo(110)
            }
            contentLabel.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
                make.top.equalTo(imgV.snp.bottom).offset(40)
            }
            agreeBtn.snp.makeConstraints { (make) in
                make.left.right.equalTo(contentLabel)
                make.top.equalTo(contentLabel.snp.bottom).offset(40)
                make.height.equalTo(44)
            }
            break
        case .loginFinger,.loginFace:
            addSubViews([imgV,accountLabel,iconImgV,contentLabel,loginPwd])
            if vType == .loginFinger {
                contentLabel.text = "点击进行指纹解锁"
            } else if vType == .loginFace {
                contentLabel.text = "点击进行面部解锁"
            }
            contentLabel.font = UIFont.ThemeFont.BodyRegular
            iconImgV.snp.makeConstraints { (make) in
                make.width.height.equalTo(70)
                make.top.equalToSuperview()
                make.centerX.equalTo(SCREEN_WIDTH * 0.5)
            }
            accountLabel.snp.makeConstraints { (make) in
                make.top.equalTo(iconImgV.snp.bottom).offset(20)
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
            }
            imgV.snp.makeConstraints { (make) in
                make.top.equalTo(accountLabel.snp.bottom).offset(70)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(110)
            }
            contentLabel.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
                make.top.equalTo(imgV.snp.bottom).offset(20)
            }
//            midLine.snp.makeConstraints { (make) in
//                make.centerX.equalTo(iconImgV)
//                make.width.equalTo(0.5)
//                make.height.equalTo(13)
//                make.bottom.equalToSuperview().offset(-50)
//            }
//            otherUnlock.snp.makeConstraints { (make) in
//                make.right.equalTo(midLine.snp.left).offset(-15)
//                make.centerY.equalTo(midLine)
//                make.height.equalTo(15)
//            }
            loginPwd.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-50)
                make.centerX.equalToSuperview()
            }
            bingTap()
        }
    }
    
    func bingTap() {
        let tapGesture = UITapGestureRecognizer()
        imgV.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: {[weak self] recognizer in
            guard let mySelf = self else {return}
            if mySelf.vType == .loginFinger {
                mySelf.clickVerifyBlock?(0)
            } else if mySelf.vType == .loginFinger {
                mySelf.clickVerifyBlock?(1)
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK:-lazy
    lazy var imgV : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: "account_finger"))
        return object
    }()
    
    lazy var contentLabel : UILabel = {
        let object = UILabel.init(text: "开启后，通过验证“手势密码”，进行快速登录", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .center)
        object.numberOfLines = 0
        return object
    }()
    
    lazy var agreeBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("同意".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            guard let mySelf = self else {return}
            if mySelf.vType == .openFinger {
                mySelf.handleBiometricsBlock?(0)
            } else if mySelf.vType == .openFace {
                mySelf.handleBiometricsBlock?(1)
            }
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var iconImgV : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: "signup_logo"))
        object.isUserInteractionEnabled = true
        return object
    }()
    
    lazy var accountLabel : UILabel = {
        let object = UILabel.init(text: "135****7299", font: UIFont.ThemeFont.H2Regular, textColor: UIColor.ThemeLabel.colorLite, alignment: .center)
        return object
    }()
    
    lazy var loginPwd : UIButton = {
        let object = UIButton()
        object.extSetTitle("使用密码登录", 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            let vc = KRSignVc()
            self?.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var midLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    lazy var otherUnlock : UIButton = {
        let object = UIButton()
        object.extSetTitle("面容解锁", 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
        }).disposed(by: disposeBag)
        return object
    }()
}
