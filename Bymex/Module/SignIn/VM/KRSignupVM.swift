//
//  KRSignupVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/12.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class KRSignVM: NSObject {
    var validatedUsername: Observable<ValidationResult>?
    var validatedPassword: Observable<ValidationResult>
    var validatedPasswordRepeated: Observable<ValidationResult>?
    var signupEnabled: Observable<Bool>
    //注册结果
//    var signupResult: Observable<Bool>
    
    // 注册
    init(input:(
            username: Observable<String>,
            password: Observable<String>,
            repeatedPassword: Observable<String>,
            loginTaps: Observable<Void>
        )
    ) {
        let validationService = KRSignInService()
        
        validatedUsername = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "Error contacting server"))
            }
            .share(replay: 1)

        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password)
            }
            .share(replay: 1)

        validatedPasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
            .share(replay: 1)
        
        //注册按钮是否可用
        signupEnabled = Observable.combineLatest(
            validatedUsername!,
            validatedPassword,
            validatedPasswordRepeated!
        )   { username, password, repeatPassword in
                username.isValid &&
                password.isValid &&
                repeatPassword.isValid
            }
            .distinctUntilChanged()
            .share(replay: 1)
    }
    
    // 登录
    init(signInput:(
            username: Observable<String>,
            password: Observable<String>,
            loginTaps: Observable<Void>
        )
    ) {
        let validationService = KRSignInService()
        validatedUsername = signInput.username
            .flatMapLatest { username in
                return validationService.validateUsername(username)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "Error contacting server"))
            }
            .share(replay: 1)

        validatedPassword = signInput.password
            .map { password in
                return validationService.validatePassword(password)
            }
            .share(replay: 1)
        
        // 登录按钮是否可用
        signupEnabled = Observable.combineLatest(
            validatedUsername!,
            validatedPassword
        )   { username, password in
                username.isValid &&
                password.isValid
            }
            .distinctUntilChanged()
            .share(replay: 1)
    }
    
    // 找回密码
    init(resertInput:(
            password: Observable<String>,
            repeatedPassword: Observable<String>,
            loginTaps: Observable<Void>
        )
    ) {
        let validationService = KRSignInService()
        validatedPassword = resertInput.password
            .map { password in
                return validationService.validatePassword(password)
            }
            .share(replay: 1)

        validatedPasswordRepeated = Observable.combineLatest(resertInput.password, resertInput.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
            .share(replay: 1)
        
        // 登录按钮是否可用
        signupEnabled = Observable.combineLatest(
            validatedPassword,
            validatedPasswordRepeated!
        )   { password,repeatedPassword  in
                password.isValid &&
                repeatedPassword.isValid
            }
            .distinctUntilChanged()
            .share(replay: 1)
    }
}
