//
//  PublicInfoManager.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class PublicInfoManager: NSObject {
    let disposeBag = DisposeBag()
    
    var accountEntity : KRAccountEntity = KRAccountEntity()
    
    //MARK:单例
    public static var sharedInstance : PublicInfoManager{
        struct Static {
            static let instance : PublicInfoManager = PublicInfoManager()
            
        }
        return Static.instance
    }
}

extension PublicInfoManager {
    
    // 处理登录成功
    class func handleLoginSuccess(_ entity : KRAccountEntity) {
        self.sharedInstance.accountEntity = entity
        XUserDefault.setValueForKey(entity.token, key: XUserDefault.token)
        XUserDefault.setAccountName(entity.phone)
        XUserDefault.setUserSignPassword(entity.dwq)
        PublicInfoManager.sharedInstance.requestAssertInfo { (result) in }
        NotificationCenter.default.post(name: Notification.Name(rawValue: KRLoginStatus), object: ["status":"1"])
    }
    
    // 处理退出登录
    class func handleLogout() {
        XUserDefault.removeKey(key: XUserDefault.token)
        self.sharedInstance.accountEntity = KRAccountEntity()
        XUserDefault.setAccountName("")
        XUserDefault.setUserSignPassword("")
        URLCookie().clearCookiesWithAppDomain()
        SLPlatformSDK.sharedInstance()?.sl_logout()
        NotificationCenter.default.post(name: Notification.Name(rawValue: KRLoginStatus), object: ["status":"0"])
    }
    
    // 请求用户资产信息(校验token)
    func requestAssertInfo(_ completeHandle : ((Bool)->())?) {
        appAPI.rx.request(AppAPIEndPoint.usersMe).MJObjectMap(KRAccountEntity.self).subscribe(onSuccess: { [weak self](entity) in
            self?.accountEntity.configAccountAssetInfo(entity)
            completeHandle?(true)
        }) { (error) in
        }.disposed(by: self.disposeBag)
    }
    
    // 更新用户信息
    class func updataAccountName(_ name : String) {
        PublicInfoManager.sharedInstance.accountEntity.account_name = name
    }
    class func updataAccountPhone(_ phone : String) {
        PublicInfoManager.sharedInstance.accountEntity.phone = phone
    }
    class func updataAccountEmail(_ email : String) {
        PublicInfoManager.sharedInstance.accountEntity.email = email
    }
    class func updataAccountPasswordEffective(_ time : AssetPasswordEffectiveTimeType) {
        PublicInfoManager.sharedInstance.accountEntity.asset_password_effective_time = time
    }
}
