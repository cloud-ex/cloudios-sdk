//
//  KRAccountEntity.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/20.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

let KRLoginStatus = "KRLoginStatus"

enum AssetPasswordEffectiveTimeType : Int {
    case AssetPasswordEffectiveNone = -2     // 没有设置资金密码
    case AssetPasswordLoseEffectiveness = -1    // 设置了资金密码资金密码失效
    case AssetPasswordEffectiveTimeNone = 0     // 设置了资金密码，但是没有设置时效
    case AssetPasswordEffectiveTimeEffectiveneFIF = 900  // 15分钟
    case AssetPasswordEffectiveTimeEffectiveneTH = 7200  // 两小时
}

class KRAccountEntity: SuperEntity {
    
    var account_id = 0
    var token = ""
    var uid = ""
    var ssid = ""
    var password = ""
    var iconUrl = ""
    var ga_key = "unbound"
    var email = ""
    var phone = ""
    var status = 1 // 1：未激活 2：已激活
    var kyc_type = 0
    var kyc_status = 0 // 认证状态(1-未认证,2-编辑中,3-已提交,4-被拒绝,5-认证通过)
    var account_type = 0
    var asset_password_effective_time = AssetPasswordEffectiveTimeType.AssetPasswordEffectiveNone
    var account_name = ""
    var owner_type = 0
    var created_at = ""
    var updated_at = ""
    
    var dwq = ""
    
    // asset
    var account_address = ""
    var deposit_address = ""
    var withdraw_address = ""
    
    var user_assets : [KRAssetEntity] = []
    
}

extension KRAccountEntity {
    func configAccountAssetInfo(_ entity : KRAccountEntity) {
        asset_password_effective_time = entity.asset_password_effective_time
        account_address = entity.account_address
        deposit_address = entity.deposit_address
        withdraw_address = entity.withdraw_address
        user_assets = entity.user_assets
    }
}
