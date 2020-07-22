//
//  KRSignInService.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationResult {
    case ok
    case empty
    case validating
    case failed(message: String)
    case phoneFailed(message: String)
    case emailFailed(message: String)
}

enum SignupState {
    case signedUp(signedUp: Bool)
}

protocol SignInAPI {
    func signup(_ username: String, password: String) -> Observable<Bool>
    func signIn(_ username: String, password: String) -> Observable<Bool>
}

protocol SignInValidationService {
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

// 登录注册API
class KRSignInAPIService : SignInAPI {
    func signup(_ username: String, password: String) -> Observable<Bool> {
        // 发起注册网络请求
        
        return Observable.just(true).delay(1.5, scheduler: MainScheduler.instance)
    }
    func signIn(_ username: String, password: String) -> Observable<Bool> {
        // 发起登录网络请求
        
        return Observable.just(true).delay(1.5, scheduler: MainScheduler.instance)
    }
    func resert(_ username: String, password: String) -> Observable<Bool> {
        // 发起找回密码网络请求
        return Observable.just(true).delay(1.5, scheduler: MainScheduler.instance)
    }
}

// 用户登录注册服务
class KRSignInService : SignInValidationService {
    // 密码最少8位数
    let minPasswordCount = 8
    
    // 网络请求服务
    lazy var APINetworkService = {
        return KRSignInAPIService()
    }
    
    // 验证用户名
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return .just(.empty)
        }
        if username.count < 6 {
            return .just(.failed(message: "手机号/邮箱格式不对"))
        }
        return .just(.ok)
    }
    // 验证密码
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .empty
        }
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "密码至少需要 \(minPasswordCount) 个字符")
        }
        if password.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .failed(message: "密码只能包含数字和字母")
        }
        return .ok
    }
    // 验证二次输入的密码
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        //判断密码是否为空
        if repeatedPassword.count == 0 {
            return .empty
        }
        //判断两次输入的密码是否一致
        if repeatedPassword == password {
            return .ok
        } else {
            return .failed(message: "两次输入的密码不一致")
        }
    }
}
