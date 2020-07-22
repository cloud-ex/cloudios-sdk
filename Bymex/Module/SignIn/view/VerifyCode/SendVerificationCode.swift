//
//  SendVerificationCode.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SendVerificationCode: NSObject {
    let disposeBag = DisposeBag()
    static let RegistVerifyCode = "RegisterVerifyCode"  // 注册验证码
    static let ResetPasswordVerifyCode = "ResetPasswordVerifyCode"  // 找回密码验证码
    static let BindPhoneVerifyCode = "BindPhoneVerifyCode"  // 绑定手机验证码
    static let BindEmailVerifyCode = "BindEmailVerifyCode"  // 绑定邮箱验证码
    static let ResetAssetPasswordVerifyCode = "ResetAssetPasswordVerifyCode"  // 重置资金密码验证码
    static let OTCAccountVerifyCode = "OTCAccountVerifyCode"  // OTC账户认证验证码
    static let WithdrawVerifyCode = "WithdrawVerifyCode"  // 提现验证码
    static let ActiveVerifyCode = "ResetPasswordVerifyCode"  // 激活验证码
    
}

extension SendVerificationCode{
    //发送验证码
    func registerRequestCode(userNameType:Int , _ userName : String , action : String = "",validate : String = "") -> Observable<Int>{
        return Observable.create({ (observer) -> Disposable in
            appAPI.rx.request(AppAPIEndPoint.verifyPhoneCode(nameType:userNameType ,verifyCodeType: action, userName: userName, validate: validate)).MJObjectMap(NSDictionary.self).subscribe(onSuccess: { (response) in
                observer.onNext(1)
                observer.onCompleted()
            }) { (error) in
                print(error)
                observer.onNext(0)
                observer.onCompleted()
            }
        })
    }
}
