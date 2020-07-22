//
//  KRGestureVerifyVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/23.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum KRGestureVerifyType {
    case remindSet   // 提醒设置
    case setGesture   // 设置手势密码
    case modify     // 修改手势密码
    case loginVerify    // 登录验证
    case closeVerify    // 登录验证
}

class KRGestureVerifyVc: KRNavCustomVC {
    
    typealias SettingGesturePwdBlock = (Bool) -> ()
    var settingGesturePwdBlock : SettingGesturePwdBlock?
    
    var vcType = KRGestureVerifyType.remindSet
    
    var hasBiometrics = false
    
    var vm : KRSignInVM?
    
    lazy var gestureV : KRGestureVerifyView = {
        let object = KRGestureVerifyView.init(vcType)
        object.handleGestureVerifyBlock = {[weak self] status in
            self?.handleGestureVerifyStatus(status)
        }
        return object
    }()
    
    public convenience init(_ type : KRGestureVerifyType) {
        self.init()
        self.vcType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadV()
        
        if vcType == .loginVerify { // 调起来登录
            vm = KRSignInVM()
            vm?.setVC(self)
            if hasBiometrics == true {
                KRBiometricsTool.sharedInstance.authorizeBiometrics {[weak self] (auth) in
                    if auth {
                        KRBusinessTools.toLogin(self?.vm)
                    }
                }
            }
        }
    }
    
    func loadV() {
        view.addSubview(gestureV)
        gestureV.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.navCustomView.snp_bottom)
        }
    }
    
    override func navBack() {
        if vcType == .remindSet {
            settingGesturePwdBlock?(false)
        } else if vcType == .closeVerify {
            settingGesturePwdBlock?(false)
        }
        super.navBack()
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if vcType == .remindSet {
            settingGesturePwdBlock?(false)
        } else if vcType == .closeVerify {
            settingGesturePwdBlock?(false)
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    deinit {
        print("释放了")
    }
}

extension KRGestureVerifyVc {
    func handleGestureVerifyStatus(_ status: Int) {
        switch status {
        case 0:
            let vc = KRGestureVerifyVc.init(.setGesture)
            vc.setTitle("手势密码".localized())
            self.navigationController?.pushViewController(vc, animated: true)
        case 1: // 设置成功
            let vcCount = self.navigationController?.viewControllers.count
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[vcCount! - 3])!, animated: true)
            break
        case 2: // 验证成功请求登录
            if vcType == .closeVerify {
                XUserDefault.setGesturesPassword("")
                self.navigationController?.popViewController(animated: true)
            } else if vcType == .loginVerify {
                KRBusinessTools.toLogin(self.vm)
            }
            break
        default:
            break
        }
    }
}
