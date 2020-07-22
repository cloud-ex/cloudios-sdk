//
//  BTPositionModel.h
//  SLContractSDK
//
//  Created by WWLy on 2018/1/18.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTContractsModel.h"

typedef NS_ENUM(NSInteger, BTPositionType) {
    BTPositionType_UnKnow = 0,
    BTPositionType_OpenMore = 1,    // 开多
    BTPositionType_OpenEmpty = 2,       // 开空
};

typedef NS_ENUM(NSInteger, BTPositionStatus) {
    BTPositionStatus_Holding = 1,   // 持仓中
    BTPositionStatus_System,        // 系统托管中
    BTPositionStatus_HoldSystem,    // 标识同时请求持仓中和系统委托中的仓位
    BTPositionStatus_Close          // 已平仓
};

@class BTContractOrderModel;
@interface BTPositionModel : NSObject
@property (nonatomic, assign) int64_t pid;      // 仓位ID
@property (nonatomic, assign) int64_t uid;       // 用户ID
@property (nonatomic, copy) NSString *name;             // 合约名称
@property (nonatomic, assign) int64_t instrument_id;      // 合约ID
@property (nonatomic, copy) NSString *cur_qty;         // 当前持有量
@property (nonatomic, copy) NSString *freeze_qty;       // 冻结量
@property (nonatomic, copy) NSString *close_qty;        // 已平仓量
@property (nonatomic, copy) NSString *avg_cost_px;      // 持仓均价
@property (nonatomic, copy) NSString *avg_open_px;      // 开仓均价(包括已平部分的,整个这条记录的仓位开仓均价)
@property (nonatomic, copy) NSString *avg_close_px;     // 已平仓,平仓均价
@property (nonatomic, copy) NSString *markPrice;        // 合理价格
@property (nonatomic, copy) NSString *lastPrice;        // 最新价格
@property (nonatomic, copy) NSString *indexPrice;       // 指数价格
@property (nonatomic, copy) NSString *liquidate_price;  // 强平价
@property (nonatomic, copy) NSString *oim;              // 原始开仓保证金
@property (nonatomic, copy) NSString *im;               // 开仓保证金
@property (nonatomic, copy) NSString *mm;               // 维持保证金
@property (nonatomic, copy) NSString *realised_pnl;     // 已实现盈亏
@property (nonatomic, copy) NSString *unrealised_profit;// 未实现盈亏
@property (nonatomic, copy) NSString *fair_unrealised;  // 合理价格未实现盈亏
@property (nonatomic, copy) NSString *repayRate;        // 回报率
@property (nonatomic, copy) NSString *earnings;         // 已结算收益
@property (nonatomic, copy) NSString *tax;              // 持仓产生的资金费用
@property (nonatomic, copy) NSString *reduceDeposit_Max;// 最大可减少保证金
@property (nonatomic, assign) BTPositionOpenType position_type;  // 开仓方式
@property (nonatomic, assign) BTPositionType side;  // 仓位类型
@property (nonatomic, assign) BTPositionStatus status;         // 状态
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) NSDate *updatedAt;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *positionValue; // 仓位价值
@property (nonatomic, strong) BTContractsModel *contractInfo;

@property (nonatomic, assign) BTPositionType LogicPositionType;

@property (nonatomic, copy) NSString *realityLeverage; // 实际杠杆

@property (nonatomic, copy) NSString *earlyWarningPx;  // 预警价格
@property (nonatomic, copy) NSString *open_fee;  // 开仓手续费
@property (nonatomic, copy) NSString *close_fee;  // 平仓手续费
@property (nonatomic, copy) NSString *total_fee;  // 手续费
@property (nonatomic, copy) NSString *close_PNL;  // 平仓盈亏

@property (nonatomic, copy) NSString *closePrice;
@property (nonatomic, copy) NSString *closeVol;
@property (nonatomic, assign) int errorno;

@property (nonatomic, copy) NSString *avg_fixed_leverage;
@property (nonatomic, copy) NSString *fixed_leverage;

@property (nonatomic, strong) BTContractOrderModel *plan_order_stop_p;
@property (nonatomic, strong) BTContractOrderModel *plan_order_stop_l;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
