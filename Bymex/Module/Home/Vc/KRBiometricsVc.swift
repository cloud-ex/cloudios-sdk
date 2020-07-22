//
//  KRBiometricsVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  指纹/面容

import Foundation
import LocalAuthentication

enum KRBiometricsType {
    case openFinger
    case openFace
    case loginFinger
    case loginFace
}

class KRBiometricsVc: KRNavCustomVC {
    
    typealias SettingBiometricsBlock = (Bool) -> ()
    var settingBiometricsBlock : SettingBiometricsBlock?
    
    var vcType = KRBiometricsType.openFinger
    
    let context = LAContext()
    var error: NSError?
    
    var vm : KRSignInVM?
    
    lazy var biometricsV : KRBiometricsView = {
        let object = KRBiometricsView.init(vcType)
        object.handleBiometricsBlock = {[weak self] status in
            if #available(iOS 11.0, *) {
                self?.openBiometrics(status)
            } else {
                
            }
        }
        object.clickVerifyBlock = {[weak self] status in
            if #available(iOS 11.0, *) {
                self?.verifyLogin(status)
            } else {
                
            }
        }
        return object
    }()
    
    public convenience init(_ type : KRBiometricsType) {
        self.init()
        self.vcType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadV()
        if vcType == .loginFace || vcType == .loginFinger {
            vm = KRSignInVM()
            vm?.setVC(self)
            KRBiometricsTool.sharedInstance.authorizeBiometrics {[weak self] (auth) in
                if auth {
                    KRBusinessTools.toLogin(self?.vm)
                }
            }
        }
    }
    
    func loadV() {
        view.addSubview(biometricsV)
        biometricsV.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.navCustomView.snp_bottom)
        }
    }
    
    override func navBack() {
        if vcType == .openFinger || vcType == .openFace {
            settingBiometricsBlock?(false)
        }
        super.navBack()
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if vcType == .openFinger || vcType == .openFace {
            settingBiometricsBlock?(false)
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

extension KRBiometricsVc {
    @available(iOS 11.0, *)
    func openBiometrics(_ status : Int) {
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                error: &error) {
            KRBiometricsTool.sharedInstance.authorizeBiometrics {[weak self] (result) in
                XUserDefault.setFaceIdOrTouchId("1")
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            
        }
    }
    @available(iOS 11.0, *)
    func verifyLogin(_ status : Int) {
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                error: &error) {
            KRBiometricsTool.sharedInstance.authorizeBiometrics {[weak self] (auth) in
                if auth {
                    KRBusinessTools.toLogin(self?.vm)
                }
            }
        } else {
        }
    }
}



class KRBiometricsTool: NSObject {
    let context = LAContext()
    var error: NSError?
    
    // MARK:单例
    public static var sharedInstance : KRBiometricsTool {
        struct Static {
            static let instance : KRBiometricsTool = KRBiometricsTool()
        }
        return Static.instance
    }
    
    func authorizeBiometrics(_ completeHandle: @escaping ((Bool) -> ())) {
        // Device can use biometric authentication
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access requires authentication") {[weak self] (success, error) in
            if let err = error {
                switch err._code {
                case LAError.Code.systemCancel.rawValue:
                    break
                case LAError.Code.userCancel.rawValue:
                    break
                case LAError.Code.userFallback.rawValue:
                    break
                default:
                    break
                }
                DispatchQueue.main.async {
                    completeHandle(false)
                }
            } else {
                if #available(iOS 11.0, *) {
                    if (self?.context.biometryType == .faceID) {
                        DispatchQueue.main.async {
                            completeHandle(true)
                        }
                    } else if self?.context.biometryType == .touchID {
                        DispatchQueue.main.async {
                            completeHandle(true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completeHandle(true)
                        }
                    }
                }
            }
        }
    }
}
