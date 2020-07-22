//
//  KRSettlesEntity.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  记录

import Foundation

enum KRSettlesType : Int {
    case SettlesTypeDeposit = 1     // 充值
    case SettlesTypeWithDraw = 2    // 提现
    case SettlesTypeReward = 3      // 奖励
    case SettlesTypeDrop = 4        // 空投
    case SettlesTypeDeposi2 = 5     // 内部充值
    case SettlesTypeInset = 6       // 内部划转
    case SettlesTypeTransferE2C = 7 // 币币转合约
    case SettlesTypeTransferC2E = 8 // 合约转币币
    case SettlesTypeOTCIN = 9       // C2C转入
    case SettlesTypeOTCOUT = 10     // C2C转出
}

enum KRSellerStatus : Int {
    case SETTLE_STATUS_CREATED = 1  // 1 申请成功(用户提交申请)
    case SETTLE_STATUS_PASSED = 2   // 2 审核通过(运营审核通过)
    case SETTLE_STATUS_REJECTED = 3 // 3 审核拒绝(运营审核拒绝)
    case SETTLE_STATUS_SIGNED = 4   // 4 签名完成(生成转账signstr完成)
    case SETTLE_STATUS_PENDING = 5  // 5 打包中(待确认链上是否转账成功)
    case SETTLE_STATUS_SUCCESS = 6  // 6 成功(转账成功)
    case SETTLE_STATUS_FAILED = 7   // 7 失败(转账失败)
}

class KRSettlesEntity: SuperEntity {
    var account = ""
    var account_id = 0
    var settle_id = 0
    var block_id : Int64 = 0
    var coin_code = ""
    var created_at = ""
    var updated_at = ""
    var fee_coin_code = ""
    var fee = ""
    var vol = ""
    var to_address = ""
    var from_address = ""
    var tx_hash = ""
    var block_hash = ""
    var title = ""
    var memo = ""
    var status = 0
    var type = 0
    var unfreeze_funds = 0
    var error = ""
    
    var coin_group = ""
    var deposit_address = ""
}
