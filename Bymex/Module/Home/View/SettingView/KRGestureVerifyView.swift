//
//  KRGestureVerifyView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/23.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation


extension CALayer {
    func shakeBody() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        keyFrameAnimation.values = [0, 16, -16, 8, -8 ,0]
        keyFrameAnimation.duration = 0.3
        keyFrameAnimation.repeatCount = 1
        add(keyFrameAnimation, forKey: "shake")
    }
}

class KRGestureVerifyView: UIView {
    
    typealias HandleGestureVerifyBlock = (Int) -> () // 0 :去设置，1 :设置成功， 2 : 验证成功
    var handleGestureVerifyBlock : HandleGestureVerifyBlock?
    
    var vType = KRGestureVerifyType.remindSet
    
    lazy var pathConifg = LockConfig()
    
    var currentPassword: String = ""    // 当前密码
    var firstPassword: String = ""      // 第一次设置密码
    var secondPassword: String = ""     // 再次设置密码
    var canModify: Bool = false         // 是否可以修改密码
    var maxErrorCount: Int = 5          // 最大错误次数
    var currentErrorCount: Int = 0      // 当前错误次数
    
    public convenience init(_ type : KRGestureVerifyType) {
        self.init()
        vType = type
        setupSubViewsLayout()
    }
    
    private func setupSubViewsLayout() {
        backgroundColor = UIColor.ThemeView.bg
        if vType == .remindSet {
            addSubViews([imgV,contentLabel,agreeBtn])
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
        } else if vType == .setGesture {
            contentLabel.text = "为了您的账户安全，请绘制手势密码"
            addSubViews([contentLabel,lockView])
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(110)
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
            }
            lockView.snp.makeConstraints { (make) in
                make.width.height.equalTo(280)
                make.centerX.equalTo(contentLabel)
                make.top.equalTo(contentLabel.snp.bottom).offset(30)
            }
            configGestureView()
        } else if vType == .loginVerify || vType == .closeVerify {
            addSubViews([iconImgV,accountLabel,contentLabel,lockView,loginPwd])
            contentLabel.text = ""
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
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(accountLabel.snp.bottom).offset(10)
                make.left.equalTo(20)
                make.width.equalTo(SCREEN_WIDTH - 40)
            }
            lockView.snp.makeConstraints { (make) in
                make.width.height.equalTo(270)
                make.centerX.equalTo(contentLabel)
                make.top.equalTo(contentLabel.snp.bottom).offset(20)
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
        }
    }
    
    //MARK:-lazy
    lazy var imgV : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: "account_gesture"))
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
            mySelf.handleGestureVerifyBlock?(0)
        }).disposed(by: disposeBag)
        return object
    }()
    
    // 绘制View
    lazy var lockView: PatternLockView = {
        let object = PatternLockView(config: ArrowConfig())
        object.delegate = self
        return object
    }()
    
    lazy var pathView: PatternLockPathView = {
        let pathView = PatternLockPathView(config: pathConifg)
        addSubview(pathView)
        pathView.translatesAutoresizingMaskIntoConstraints = false
        pathView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pathView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pathView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pathView.bottomAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -20).isActive = true
        return pathView
    }()
    
    // 验证view
    lazy var iconImgV : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: "signup_logo"))
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
    
//    lazy var midLine : UIView = {
//        let object = UIView()
//        object.backgroundColor = UIColor.ThemeView.seperator
//        return object
//    }()
//
//    lazy var otherUnlock : UIButton = {
//        let object = UIButton()
//        object.extSetTitle("面容解锁", 14, UIColor.ThemeLabel.colorHighlight, .normal)
//        object.rx.tap.subscribe(onNext:{ [weak self] in
//        }).disposed(by: disposeBag)
//        return object
//    }()
}

extension KRGestureVerifyView {
    
    func configGestureView() {
        pathConifg.gridSize = CGSize(width: 10, height: 10)
        pathConifg.matrix = Matrix(row: 3, column: 3)
        let normalColor = UIColor.ThemeLabel.colorDark
        let tintColor = UIColor.ThemeLabel.colorHighlight
        pathConifg.initGridClosure = {(matrix) -> PatternLockGrid in
            let gridView = GridView()
            let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 1, error: 1)
            let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: normalColor, connect: tintColor, error: UIColor.red)
            let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: UIColor.red)
            gridView.outerRoundConfig = RoundConfig(radius: 5, lineWidthStatus: outerStrokeLineWidthStatus, lineColorStatus: outerStrokeColorStatus, fillColorStatus: outerFillColorStatus)
            gridView.innerRoundConfig = RoundConfig.empty
            return gridView
        }

        let lineView = ConnectLineView()
        lineView.lineColorStatus = .init(normal: tintColor, error: .red)
        lineView.lineWidth = 1
        pathConifg.connectLine = lineView
        addSubViews([pathView])

        switch vType {
        case .setGesture:
            contentLabel.text = "绘制解锁图案"
        case .modify:
            contentLabel.text = "请输入原手势密码"
//            pathView.isHidden = true
        case .loginVerify,.closeVerify:
            contentLabel.font = UIFont.ThemeFont.H2Bold
            contentLabel.textColor = UIColor.ThemeLabel.colorLite
            contentLabel.text = XUserDefault.getActiveAccount()?.phone ?? ""
        default:
            break
        }
    }
    
    //MARK: - Event
    @objc func didRestButtonClicked() {
        showNormalText("绘制解锁图案")
        currentPassword = ""
        firstPassword = ""
        secondPassword = ""
        pathView.reset()
        lockView.reset()
    }

    func showResetButtonIfNeeded() {
        guard vType == .setGesture || vType == .modify else {
            return
        }
        if !firstPassword.isEmpty {
        }
    }

    func shouldShowErrorWithSavedAndCurrentPassword() -> Bool {
        let currentPwd = KRMD5.getmd5(currentPassword)
        if currentPwd == XUserDefault.getGesturesPassword() {
            //当前密码与保存的密码相同，不需要显示error
            return false
        }else {
            return true
        }
    }

    func shouldShowErrorWithFirstAndSecondPassword() -> Bool {
        if firstPassword.isEmpty {
            // 第一次密码还未配置，不需要显示error
            return false
        } else if firstPassword == currentPassword {
            // 两次输入的密码相同，不需要显示error
            return false
        } else {
            return true
        }
    }

    func setupPassword() {
        if firstPassword.isEmpty {
            firstPassword = currentPassword
            showNormalText("再次绘制解锁图案")
        } else {
            secondPassword = currentPassword
            if firstPassword == secondPassword {
                let pwd = KRMD5.getmd5(firstPassword)
                XUserDefault.setGesturesPassword(pwd)
                EXAlert.showSuccess(msg: "手势密码设置成功".localized())
                handleGestureVerifyBlock?(1)
            } else {
                showResetButtonIfNeeded()
                showErrorText("与上次绘制不一致，请重新绘制")
                secondPassword = ""
            }
        }
    }

    func showErrorText(_ text: String) {
        contentLabel.text = text
        contentLabel.textColor = UIColor.red
        contentLabel.layer.shakeBody()
    }

    func showNormalText(_ text: String) {
        contentLabel.text = text
        contentLabel.textColor = UIColor.ThemeLabel.colorDark
    }

    func showPasswordError() {
        currentErrorCount += 1
        if currentErrorCount == maxErrorCount {
            //真实的业务代码是跳转到登录页面
            print("错误次数已达上限，将清除密码，请重新设置密")
        }else {
            showErrorText("密码错误，还可以输入\(maxErrorCount - currentErrorCount)次")
        }
    }

    func shouldHandlePathView() -> Bool {
        if firstPassword.isEmpty {
            //第一次的密码未输入，才需要更新path
            if vType == .setGesture {
                return true
            } else if vType == .modify {
                if canModify {
                    // 修改时，第一次验证成功之后才需要更新path
                    return true
                }
            }
        }
        return false
    }
}

extension KRGestureVerifyView : PatternLockViewDelegate {
    func lockView(_ lockView: PatternLockView, didConnectedGrid grid: PatternLockGrid) {
        currentPassword += grid.identifier
        if shouldHandlePathView() {
            pathView.addGrid(at: grid.matrix)
        }
    }
    
    func lockViewShouldShowErrorBeforeConnectCompleted(_ lockView: PatternLockView) -> Bool {
        if vType == .loginVerify || vType == .closeVerify {
            return shouldShowErrorWithSavedAndCurrentPassword()
        }else if vType == .setGesture {
            return shouldShowErrorWithFirstAndSecondPassword()
        }else if vType == .modify {
            if !canModify {
                return shouldShowErrorWithSavedAndCurrentPassword()
            }else {
                return shouldShowErrorWithFirstAndSecondPassword()
            }
        }
        return false
    }
    
    func lockViewDidConnectCompleted(_ lockView: PatternLockView) {
        if currentPassword.count < 4 {
            showErrorText("至少链接4个点，请重新绘制")
            if shouldHandlePathView() {
                pathView.reset()
            }
            showResetButtonIfNeeded()
        } else {
            switch vType {
            case .setGesture:
                setupPassword()
            case .modify:
                if canModify {
                    setupPassword()
                } else {
                    if currentPassword == XUserDefault.getGesturesPassword() {
                        pathView.isHidden = false
                        showNormalText("绘制解锁图案")
                        canModify = true
                    } else {
                        showPasswordError()
                    }
                }
            case .loginVerify, .closeVerify:
                let currentPwd = KRMD5.getmd5(currentPassword)
                if currentPwd == XUserDefault.getGesturesPassword() {
                    handleGestureVerifyBlock?(2)
                } else {
                    showPasswordError()
                }
            default:
                break
            }
        }
        print(currentPassword)
        currentPassword = ""
    }
}

