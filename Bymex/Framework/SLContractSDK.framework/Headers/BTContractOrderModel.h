//
//  BTContractOrderModel.h
//  SLContractSDK
//
//  Created by WWLy on 2018/1/18.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTPositionModel.h"
#import "BTString.h"

// 订单方向
typedef NS_ENUM(NSInteger, BTContractOrderWay) {
    BTContractOrderWayUnkown = 0,
    BTContractOrderWayBuy_OpenLong,             // 买入开多
    BTContractOrderWayBuy_CloseShort,           // 买入平空
    BTContractOrderWaySell_CloseLong,           // 卖出平多
    BTContractOrderWaySell_OpenShort            // 卖出开空
};

// 订单类型
typedef NS_ENUM(NSInteger, BTContractOrderCategory) {
    BTContractOrderCategoryUnkown = 0,
    BTContractOrderCategoryNormal = 1,      // 限价委托
    BTContractOrderCategoryMarket = 2,      // 市价委托
    BTContractOrderCategoryStopLoss = 3,    // 止损委托
    BTContractOrderCategoryStopFill = 4,    // 止盈委托
    BTContractOrderCategoryHidden = 5,      // 隐藏委托
    BTContractOrderCategoryIceMountain = 6, // 冰山委托
    BTContractOrderCategoryPassive = 7,     // 被动委托
    BTContractOrderCategoryPlan = 8,       // 计划委托
    BTContractOrderCategoryTrigger = 129,     // 触发委托
    BTContractOrderCategoryBreak = 257,
    BTContractOrderCategoryDetail = 513
};

// 订单状态
typedef NS_ENUM(NSInteger, BTContractOrderStatus) {
    BTContractOrderStatusUnkown = 0,
    BTContractOrderStatusApproval = 1,             // 申报中
    BTContractOrderStatusWait = 2,                 // 委托中
    BTContractOrderStatusAllWait = 3,              // 当前委托
    BTContractOrderStatusFinished = 4,             // 结束
};

// 订单完成的原因
typedef NS_ENUM(NSInteger, BTContractOrderErrNO) {
                                        // 普通委托完成原因（计划委托完成原因）
    BTContractOrderErrNONoErr = 0,      // 没有原因,在订单完成的状态下表示订单已经全部成交（触发成功）
    BTContractOrderErrCancel,           // 订单被取消（用户取消）
    BTContractOrderErrTimeout,          // 订单超时,暂时不用（订单超时）
    BTContractOrderErrASSETS,           // 用户资产不够,转撤销（用户资产不够）
    BTContractOrderErrFREEZE,           // 用户冻结资产不够（订单将触发强平）
    BTContractOrderErrUNDO,             // 系统部分转撤销（订单无效）
    BTContractOrderErrCLOSE,            // 部分平仓导致的部分转撤销（用户资产正处在托管中）
    BTContractOrderErrReduce,           // 自动减仓导致的部分转撤销（仓位不存在）
    BTContractOrderErrCompensate,       // 盈利补偿导致的部分转撤销(仓位量不够)
    BTContractOrderErrPositionErr,      // 仓位错误导致的部分转撤销（仓位已经被关闭）
    BTContractOrderErrFORBBIDN,         // 类型非法 （合约已经暂停交易）
    BTContractOrderErrOPPSITE,          // 反方向订单存在 （反方向订单存在）
    BTContractOrderErrFOK,              // FOK订单系统做的部分转撤销 （合约已经下线）
    BTContractOrderErrIOC,              // IOC订单系统做的部分转撤销 （未知错误）
    BTContractOrderErrMARKET,           // 市价订单未完成部分被系统部分转撤销
    BTContractOrderErrPASSIVE,          // 被动成交订单系统做的部分转撤销
    BTContractOrderErrFORCE,            // 强平订单系统做的部分转撤销
    BTContractOrderErrPLAY,             // play订单系统做的部分转撤销
    BTContractOrderErrHANDOVER,         // 由于合约发生交割,系统做的部分转撤销
};

// 订单状态
typedef NS_ENUM(NSInteger, BTContractOrderViewStatus) {
    BTContractOrderViewStatusUnkown = 0,
    BTContractOrderViewStatusCanceling,             // 正在取消中
};

// 价类型
typedef NS_ENUM(NSInteger, BTContractOrderPriceType) {
    BTContractOrderTradePriceType = 1,              // 交易价
    BTContractOrderMarkPriceType  = 2,              // 标记价
    BTContractOrderIndexPriceType = 4               // 指数价
};

// 价格方向
typedef NS_ENUM(NSInteger, BTContractOrderPriceWay) {
    BTContractOrderPriceWayUp = 1,              // 看涨
    BTContractOrderPriceWayDown = 2,           // 看跌
};

// 价类型
typedef NS_ENUM(NSInteger, SLContractPlanProfitOrlossType) {
    SLContractPlanNomalType = 0,              // 普通计划委托
    SLContractPlanProfitType = 1,             // 止盈计划委托
    SLContractPlanLossType = 2                // 止损计划委托
};

// 订单方向
typedef NS_ENUM(NSInteger, BTOrderWay) {
    BTOrderWayUnkown = 0,
    BTOrderWayBuy,             // 买单
    BTOrderWaySell             // 卖单
};

// 订单类型
typedef NS_ENUM(NSInteger, BTOrderCategory) {
    BTOrderCategoryUnkown = 0,
    BTOrderCategoryNormal, // 限价单
    BTOrderCategoryMarket, // 市价单
    BTOrderCategoryGTC,   //
    BTOrderCategoryDay
};

// 订单状态
typedef NS_ENUM(NSInteger, BTOrderStatus) {
    BTOrderStatusUnkown = 0,
    BTOrderStatusApproval,             // 审批中
    BTOrderStatusWait,                 // 委托中
    BTOrderStatusFinished              // 结束
};

// 订单完成的原因
typedef NS_ENUM(NSInteger, BTOrderErrNO) {
    BTOrderErrNONoErr = 0,  // 没有原因,在订单完成的状态下表示订单已经全部成交
    BTOrderErrCancel,          // 订单被取消
    BTOrderErrTimeout,         // 订单超时,暂时不用
    BTOrderErrASSETS,
    BTOrderErrUNDO,
};


// 订单状态
typedef NS_ENUM(NSInteger, BTOrderViewStatus) {
    BTOrderViewStatusUnkown = 0,
    BTOrderViewStatusCanceling,             // 正在取消中
};

// 是否止盈止损
typedef NS_ENUM(NSInteger, BTOrderWithMissionType) {
    SWAPMISSIONORDER_TYPE_NONE = 0,     // 没有止盈止损
    SWAPMISSIONORDER_TYPE_PROFIT = 1,   // 仅有止盈条件
    SWAPMISSIONORDER_TYPE_LOSS = 2,     // 仅有止损条件
    SWAPMISSIONORDER_TYPE_ALL = 3       // 都有
};

@class BTProfitOrLossModel;
@interface BTContractOrderModel : NSObject
@property (nonatomic, assign) int64_t uid;      // 用户id
@property (nonatomic, assign) int64_t client_id; // 用户自定义id,异步提交订单时用
@property (nonatomic, assign) int64_t oid;      // 订单ID
@property (nonatomic, assign) int64_t instrument_id;  // 合约ID
@property (nonatomic, assign) int64_t pid;  // 仓位ID
@property (nonatomic, copy) NSString *name;         // 合约名称
@property (nonatomic, copy) NSString *avai;         // 合约价值
@property (nonatomic, copy) NSString *px;        // 订单价格 （计划委托触发价格）
@property (nonatomic, copy) NSString *qty;          // 订单量
@property (nonatomic, copy) NSString *leverage;     // 杠杆
@property (nonatomic, copy) NSString *avg_px;   // 成交均价
@property (nonatomic, copy) NSString *cum_qty;  // 成交量
@property (nonatomic, copy) NSString *exec_px; // 执行价格
@property (nonatomic, assign) BTContractOrderPriceType trigger_type; // 价格类型
@property (nonatomic, assign) BTContractOrderPriceWay trend;  // 价格方向
@property (nonatomic, copy) NSNumber *cycle;   // 委托周期,单位小时
@property (nonatomic, assign) BTContractOrderWay side;
@property (nonatomic, assign) BTContractOrderCategory category;
@property (nonatomic, assign) BTPositionOpenType position_type;
@property (nonatomic, copy) NSString * make_fee;
@property (nonatomic, copy) NSString * take_fee;
@property (nonatomic, copy) NSString * takeFeeRatio;
@property (nonatomic, copy) NSString * makeFeeRatio;
@property (nonatomic, copy) NSString * origin;
@property (nonatomic, copy) NSString * feeCoinCode;
@property (nonatomic, copy) NSString * doneFee;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * updated_at;
@property (nonatomic, copy) NSString * finished_at;
@property (nonatomic, assign) BTContractOrderStatus status;
@property (nonatomic, assign) BTContractOrderErrNO errorno;
@property (nonatomic, copy) NSNumber * nonce;
@property (nonatomic, copy) NSString *forceTips;
@property (nonatomic, copy) NSString *currentPrice;  // 当前市场最新价格

@property (nonatomic, copy) NSString *open_avg_px; // 预计开仓均价 （需要计算）

@property (nonatomic, assign) BTPositionType orderPositionType;
@property (nonatomic, assign) BTPositionType OrderLogicPositionType;

@property (nonatomic, copy) NSString *IMR; // 开仓保证金率
@property (nonatomic, copy) NSString *MMR; // 维持保证金率
@property (nonatomic, copy) NSString *BTR; // 破产保证金率
@property (nonatomic, copy) NSString *liquidatePrice; // 订单强平价格
@property (nonatomic, copy) NSString *index_px; // 指数价格
@property (nonatomic, copy) NSString *quote_coin; // 计价单位
@property (nonatomic, copy) NSString *freezAssets; // 开仓成本
@property (nonatomic, copy) NSString *freezShort; // 开空仓成本
@property (nonatomic, copy) NSString *balanceAssets; // 余额
@property (nonatomic, copy) NSString *markPrice;
@property (nonatomic, copy) NSString *earlyWarningPx; // 预警价格

@property (nonatomic, copy) NSString *sumVolNum;

@property (nonatomic, assign) CGFloat coordinate_x;
@property (nonatomic, assign) CGFloat coordinate_y;

@property (nonatomic, copy) NSNumber *time_in_force;

@property (nonatomic, assign) SLContractPlanProfitOrlossType type;

@property (nonatomic, strong) BTContractsModel *contractInfo;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)contractOrderWithDict:(NSDictionary *)dict;

// 创建开仓订单
+ (instancetype)newContractOpenOrderWithContractId:(int64_t)instrument_id
                                          category:(BTContractOrderCategory)category
                                               way:(BTContractOrderWay)way
                                       timeInForce:(NSNumber *)time_in_force
                                          openType:(BTPositionOpenType)position_type
                                          leverage:(NSString *)leverage
                                             price:(NSString *)price
                                               vol:(NSString *)vol;

// 创建平仓订单
+ (instancetype)newContractCloseOrderWithContractId:(int64_t)instrument_id
                                           category:(BTContractOrderCategory)category
                                                way:(BTContractOrderWay)way
                                         positionID:(int64_t)position_id
                                              price:(NSString *)price
                                                vol:(NSString *)vol;

// 创建计划委托订单
+ (instancetype)newContractPlanOpenOrderWithContractId:(int64_t)instrument_id
                                          category:(BTContractOrderCategory)category
                                               way:(BTContractOrderWay)side
                                          openType:(BTPositionOpenType)position_type
                                          trigger_type:(BTContractOrderPriceType)trigger_type
                                                 trend:(BTContractOrderPriceWay)trend
                                               exec_px:(NSString *)exec_px
                                                 cycle:(NSString *)cycle
                                          leverage:(NSString *)leverage
                                             price:(NSString *)price
                                               vol:(NSString *)vol;

// 创建计划平仓订单
+ (instancetype)newContractPlanCloseOrderWithContractId:(int64_t)instrument_id
                                           category:(BTContractOrderCategory)category
                                                way:(BTContractOrderWay)side
                                           trigger_type:(BTContractOrderPriceType)trigger_type
                                                  trend:(BTContractOrderPriceWay)trend
                                                exec_px:(NSString *)exec_px
                                                  cycle:(NSString *)cycle
                                         positionID:(int64_t)position_id
                                              price:(NSString *)price
                                                vol:(NSString *)vol;

/// 创建止盈止损订单
+ (instancetype)createPlanProfitOrLossOrderWithContractId:(int64_t)instrument_id
                                                 category:(BTContractOrderCategory)category
                                                      way:(BTContractOrderWay)side
                                             trigger_type:(BTContractOrderPriceType)trigger_type
                                                   trend:(BTContractOrderPriceWay)trend
                                                 exec_px:(NSString *)exec_px
                                                   cycle:(NSString *)cycle
                                               positionID:(int64_t)position_id
                                         profitOrLossType:(SLContractPlanProfitOrlossType)type
                                                    price:(NSString *)price;

// 开仓订单数据
- (NSDictionary *)buildSubmitContractOpenOrderData;
// 开仓订单数据带止盈止损
- (NSDictionary *)buildSubmitContractOpenOrderDataWithMission:(BTProfitOrLossModel *)missionModel;

// 计划委托开仓订单数据
- (NSDictionary *)buildSubmitPlanContractOpenOrderData;

// 计划委托平仓数据
- (NSDictionary *)buildSubmitPlanContractCloseOrderData;

// 平仓订单数据
- (NSDictionary *)buildSubmitContractCloseOrderData;

// 止盈止损平仓数据
- (NSDictionary *)buildProfitOrLossPlanContractCloseOrderData;

// 用于深度
+ (instancetype)orderModelWith:(BTContractOrderModel *)orderModel;

@end


@interface BTProfitOrLossModel : NSObject

@property (nonatomic, assign) BTOrderWithMissionType missionType; // 是否条件下单

@property (nonatomic, assign) BTContractOrderPriceType profit_price_type;// 止盈价格类型
@property (nonatomic, copy) NSString *profit_price;     // 止盈触发价
@property (nonatomic, copy) NSString *profit_ex_price;  // 止盈执行价

 //  1 现价 2 市价(市价不传执行价格)
@property (nonatomic, assign) int profit_category;
@property (nonatomic, assign) int loss_category;

@property (nonatomic, assign) BTContractOrderPriceType loss_price_type;  // 止损价格类型
@property (nonatomic, copy) NSString *loss_price;       // 触发价
@property (nonatomic, copy) NSString *loss_ex_price;    // 执行价
@end
