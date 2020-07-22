//
//  SwapInfoEntity.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum PositionLeverageType:Int {
    case LeverageType_UnKnow = 0
    case LeverageType_Fixed = 1
    case LeverageType_Cross = 2
    case LeverageType_Both = 3
}

enum SwapCompensateType:Int { // 穿仓补偿方式
    case SwapCompensateType_Unkown = 0
    case SwapCompensateType_ADL       // ADL方式
    case SwapCompensateType_ProfitShar //盈利均摊
}

enum SwapStatus:Int {
    case CONTRACT_STATUS_UNKOWN = 0
    case CONTRACT_STATUS_APPROVE        // 审批中
    case CONTRACT_STATUS_TEST           // 测试中
    case CONTRACT_STATUS_AVAI           // 可用（正在撮合的合约）
    case CONTRACT_STATUS_STOP           // 暂停（合约可见,但是撮合暂停了）
    case CONTRACT_STATUS_DELIVERY       // 交割中
    case CONTRACT_STATUS_DELIVED        // 交割完成
    case CONTRACT_STATUS_DOWN           // 下线
}

enum SwapBlockType:Int {
    case CONTRACT_BLOCK_UNKOWN = 0
    case CONTRACT_BLOCK_USDT            // USDT区域
    case CONTRACT_BLOCK_INVERSE
    case CONTRACT_BLOCK_INVERSE2
    case CONTRACT_BLOCK_SIMULATION      // 模拟大赛
}

class SwapInfoEntity: SuperEntity {
    
    var instruments :[SwapInfo] = []
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "instruments" {
            guard let values = value as? [[String : Any]]  else {
                return
            }
            for object in values {
                if let info = SwapInfo.mj_object(withKeyValues: object) {
                    instruments.append(info)
                }
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

class SwapInfo: SuperEntity {
    var instrument_id  = 0  // 合约ID
    var index_id = 0    // 指数ID
    var symbol = "" // 合约名称
    var name_zh = ""    // 合约中文显示名称
    var name_en = ""    // 合约英文显示名称
    var base_coin = ""      // 基础币
    var quote_coin = ""     // 计价币
    var margin_coin = ""    // 保证金币
    var is_reverse = false  // 是否是反向合约
    var market_name = ""
    var face_value = "" // 合约大小,表示一张合约值多少个基础币
    var begin_at = ""
    var settle_at = ""
    var settlement_interval = 0     // 交割时间（秒）
    var min_leverage = ""   // 合约支持的最小杠杆
    var max_leverage = ""   // 合约支持的最大杠杆
    var position_type = 0
    var px_unit = ""    // 价格精度
    var qty_unit = ""   // 量精度
    var value_unit = "" // 价值精度
    var min_qty = ""    // 单笔订单最小量
    var max_qty = ""    // 单笔订单最大量
    var underweight_type = 0  // 穿仓补偿方式
    var status = 0   // 合约状态
    var area = 0   // 1:USDT区,2:主区,3:创新区,4:模拟区
    var created_at = "" // 创建时间
    var depth_round = ""    // 深度边框系数
    var base_coin_zh = ""   // 基础比中文名字
    var base_coin_en = ""   // 基础比英文名字
    var max_funding_rate = ""   // 最大资金费率
    var min_funding_rate = ""   // 最小资金费率
    var risk_limit_base = ""    // 风险限额基础
    var risk_limit_step = ""    // 步长
    var mmr = ""    // 基本维持保证金率
    var imr = ""    // 基本开仓保证金率
    var maker_fee_ratio = ""    // makefee系数
    var taker_fee_ratio = ""    // takefee系数
    var settle_fee_ratio = ""    // 交割手续费率
    var plan_order_price_min_scope = ""     // 条件单最小价格范围
    var plan_order_price_max_scope = ""     // 条件单最大价格范围,如果为0,表示该合约不支持条件单
    var plan_order_max_count = 0    // 单用户条件单最大数量
    var plan_order_min_life_cycle = 0   // 条件单最小生命周期
    var plan_order_max_life_cycle = 0   // 条件单最大生命周期
}
