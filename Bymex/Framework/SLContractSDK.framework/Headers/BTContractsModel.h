//
//  BTContractsModel.h
//  SLContractSDK
//
//  Created by WWLy on 2018/1/18.
//  Copyright © 2018年 Karl. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BTContractType) {
    BTContractUnkown = 0,
    BTContractSustainable,     // 永续
    BTContractFuntracts        // 期货
};

typedef NS_ENUM(NSInteger, BTContract_SettleType) { // 结算类型
    BTContractSettleTypeUnkown = 0,
    BTContractSettleAutomaticType,  // 自动
    BTContractSettleManualType,     // 手动
};

typedef NS_ENUM(NSInteger, BTPositionOpenType) {
    BTPositionOpen_UnKnow = 0,
    BTPositionOpen_PursueType = 1,  // 逐仓
    BTPositionOpen_AllType,         // 全仓
    BTPositionOpen_BothType         // 都支持
};

typedef NS_ENUM(NSInteger, BTContract_CompensateType) { // 穿仓补偿方式
    BTContractCompensateTypeUnkown = 0,
    BTContractCompensateADLType,        // ADL方式
    BTContractCompensateProfitSharType, //盈利均摊
};

typedef NS_ENUM(NSInteger, BTContract_Block_Type) {
    CONTRACT_BLOCK_UNKOWN = 0,
    CONTRACT_BLOCK_USDT = 1,        // USDT区域
    CONTRACT_BLOCK_INVERSE = 2,
    CONTRACT_BLOCK_STAND = 3,      // 币本位
    CONTRACT_BLOCK_SIMULATION,  // 模拟大赛
};

typedef NS_ENUM(NSInteger, BTContract_status) {
    CONTRACT_STATUS_UNKOWN = 0,
    CONTRACT_STATUS_APPROVE,    // 审批中
    CONTRACT_STATUS_TEST,       // 测试中
    CONTRACT_STATUS_AVAI,       // 可用（正在撮合的合约）
    CONTRACT_STATUS_STOP,       // 暂停（合约可见,但是撮合暂停了）
    CONTRACT_STATUS_DELIVERY,   // 交割中
    CONTRACT_STATUS_DELIVED,    // 交割完成
    CONTRACT_STATUS_DOWN        // 下线
};

typedef NS_ENUM(NSInteger, BTContractOrderType) {
    BTDefineContractOpen = 30001, // 开仓单
    BTDefineContractClose,        // 平仓单
};

@interface BTContractsModel :NSObject
@property (nonatomic, assign) int64_t instrument_id;        // 合约ID
@property (nonatomic, assign) int64_t index_id;             // 指数ID
@property (nonatomic, copy) NSString *symbol;               // 合约名称
@property (nonatomic, copy) NSString *name_zh;              // 合约中文显示名称
@property (nonatomic, copy) NSString *name_en;              // 合约英文显示名称
@property (nonatomic, assign) BTContractType contract_type;
@property (nonatomic, copy) NSString *base_coin;            // 基础币
@property (nonatomic, copy) NSString *quote_coin;           // 计价币
@property (nonatomic, copy) NSString *price_coin;           // 合约大小的单位币
@property (nonatomic, assign) BOOL is_reverse;              // 是否是反向合约
@property (nonatomic, copy) NSString *margin_coin;
@property (nonatomic, copy) NSString *face_value;           // 合约大小
@property (nonatomic, assign) int64_t settlement_interval;  // 交割周期（秒）
@property (nonatomic, copy) NSString *min_leverage;         // 支持的最小杠杆
@property (nonatomic, copy) NSString *max_leverage;         // 支持的最大杠杆
@property (nonatomic, copy) NSString *default_leverage;         // 支持的最大杠杆

@property (nonatomic, strong) NSArray <NSString *>*leverageArr;

@property (nonatomic, copy) NSString *px_unit;              // 价格精度
@property (nonatomic, copy) NSString *qty_unit;             // 数量精度
@property (nonatomic, copy) NSString *value_unit;           // 价值精度
@property (nonatomic, copy) NSString *min_qty;              // 合约支持的最小交易量
@property (nonatomic, copy) NSString *max_qty;              // 合约支持的最大交易量
@property (nonatomic, copy) NSString *liquidation_warn_ratio; // 平仓预警系数
@property (nonatomic, copy) NSString *fast_liquidation_ratio; // 快速平仓系数
@property (nonatomic, assign) BTContract_SettleType settle_type; // 结算类型
@property (nonatomic, assign) BTPositionOpenType position_type; //开仓类型
@property (nonatomic, assign) BTContract_CompensateType underweight_type; // 穿仓补偿方式
@property (nonatomic, copy) NSString *created_at;           // created_at
@property (nonatomic, assign) BTContract_Block_Type area;
@property (nonatomic, assign) BTContract_status status;
@property (nonatomic, copy) NSString *depth_round;          // 深度边框系数
@property (nonatomic, copy) NSString *base_coin_zh;         // 基础比中文名字
@property (nonatomic, copy) NSString *base_coin_en; // 基础比英文名字
@property (nonatomic, copy) NSString *max_funding_rate; // 最大资金费率
@property (nonatomic, copy) NSString *min_funding_rate; // 最小资金费率
@property (nonatomic, copy) NSString *risk_limit_base; // 风险限额基础
@property (nonatomic, copy) NSString *risk_limit_step; // 步长
@property (nonatomic, copy) NSString *mmr; // 基本维持保证金率
@property (nonatomic, copy) NSString *imr; // 基本开仓保证金率
@property (nonatomic, copy) NSString *maker_fee_ratio; // makefee系数
@property (nonatomic, copy) NSString *taker_fee_ratio; // takefee系数
@property (nonatomic, copy) NSString *settle_fee_ratio; // 交割手续费率
@property (nonatomic, copy) NSString *plan_order_price_min_scope; // 计划委托最小价格范围
@property (nonatomic, copy) NSString *plan_order_price_max_scope; // 计划委托最大价格范围,如果为0,表示该合约不支持计划委托
@property (nonatomic, assign) int32_t plan_order_max_count;  // 单用户计划委托最大数量
@property (nonatomic, assign) int32_t plan_order_min_life_cycle; // 计划委托最小生命周期
@property (nonatomic, assign) int32_t plan_order_max_life_cycle; // 计划委托最大生命周期

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
