//
//  BTContractTool.h
//  SLContractSDK
//
//  Created by WWLy on 2018/7/18.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTPositionModel.h"
#import "BTContractOrderModel.h"
#import "BTContractsOpenModel.h"
#import "BTContractRecordModel.h"
#import "BTCashBooksModel.h"
#import "BTContractTradeModel.h"

#define SHOW_FUND_PWD @"SHOW_FUND_PWD"
#define LEVERAGE_MATCH_ERROR @"LEVERAGE_MATCH_ERROR"

@class BTContractsModel, BTContractsOpenModel, BTDepthModel,SLGlobalLeverageEntity;
@interface BTContractTool : NSObject

+ (instancetype)shareContractTool;

+ (ContractOrderSize *)getOpenOrderSizeWithContractID:(int64_t)instrument_id side:(BTContractOrderWay)side;

// 获取合约信息
+ (void)getContractsInfoWithContractID:(int64_t)instrument_id
                               success:(void (^)(NSArray <BTContractsModel *>*))success
                               failure:(void (^)(NSError *))failure;

// 根据contractID获取用户仓位
+ (void)getUserPositionWithContractID:(int64_t)instrument_id
                               status:(BTPositionStatus)status
                               offset:(NSInteger)offset
                                 size:(NSInteger)size
                              success:(void (^)(NSArray <BTPositionModel *>*))success
                              failure:(void (^)(NSError *))failure;

// 获取用户订单记录
+ (void)getUserContractOrdersWithContractID:(int64_t)instrument_id
                                     status:(BTContractOrderStatus)status
                                     offset:(NSInteger)offset
                                       size:(NSInteger)size
                                    success:(void (^)(NSArray <BTContractOrderModel *>*))success
                                    failure:(void (^)(NSError *))failure;
/// 获取用户订单记录
/// @param instrument_id 合约ID
/// @param status 订单状态
/// @param side 订单类型
+ (void)getUserContractOrdersWithContractID:(int64_t)instrument_id
                                     status:(BTContractOrderStatus)status
                                        way:(BTContractOrderWay)side
                                     offset:(NSInteger)offset
                                       size:(NSInteger)size
                                    success:(void (^)(NSArray <BTContractOrderModel *>*))success
                                    failure:(void (^)(NSError *))failure;

/// 获取单个历史委托详情
/// @param instrument_id 合约 ID
/// @param orderID 订单 ID
+ (void)getUserDetailHistoryOrderWithContractID:(int64_t)instrument_id
                                        orderID:(int64_t)orderID
                                        success:(void (^)(NSArray <BTContractTradeModel *>*))success
                                        failure:(void (^)(NSError *))failure;

// 根据coinCode获取用户仓位
+ (void)getUserPositionWithcoinCode:(NSString *)coin_code
                         contractID:(int64_t)instrument_id
                             status:(BTPositionStatus)status
                             offset:(NSInteger)offset
                               size:(NSInteger)size
                            success:(void (^)(NSArray <BTPositionModel *>*))success
                            failure:(void (^)(NSError *))failure;


// 获取用户计划委托记录
+ (void)getUserPlanContractOrdersWithContractID:(int64_t)instrument_id
                                         status:(BTContractOrderStatus)status
                                         offset:(NSInteger)offset
                                           size:(NSInteger)size
                                        success:(void (^)(NSArray <BTContractOrderModel *>*))success
                                        failure:(void (^)(NSError *))failure;
/// 获取用户计划委托记录
/// @param instrument_id 合约ID
/// @param status 订单状态
/// @param side 订单类型
+ (void)getUserPlanContractOrdersWithContractID:(int64_t)instrument_id
                                         status:(BTContractOrderStatus)status
                                            way:(BTContractOrderWay)side
                                         offset:(NSInteger)offset
                                           size:(NSInteger)size
                                        success:(void (^)(NSArray <BTContractOrderModel *>*))success
                                        failure:(void (^)(NSError *))failure;

// 提交计划订单
+ (void)submitPlanOrder:(BTContractOrderModel *)contractOrder
      contractOrderType:(BTContractOrderType)type
          assetPassword:(NSString *)assetPassword
                success:(void (^)(NSNumber *))success
                failure:(void (^)(id))failure;

// 取消计划委托
+ (void)cancelPlanOrders:(NSArray <BTContractOrderModel *>*)contractOrders
       contractOrderType:(BTContractOrderType)type
           assetPassword:(NSString *)assetPassword
                 success:(void (^)(NSNumber *))success
                 failure:(void (^)(id))failure;

// 提交合约订单
+ (void)sendContractsOrder:(BTContractOrderModel *)contractOrder
         contractOrderType:(BTContractOrderType)type
             assetPassword:(NSString *)assetPassword
                   success:(void (^)(NSNumber *))success
                   failure:(void (^)(id))failure;

// 取消合约订单
+ (void)cancelContractOrders:(NSArray <BTContractOrderModel *>*)contractOrders
           contractOrderType:(BTContractOrderType)type
               assetPassword:(NSString *)assetPassword
                     success:(void (^)(NSNumber *))success
                     failure:(void (^)(id))failure;

/// 提交止盈止损单
+ (void)submitProfitOrLossOrder:(BTContractOrderModel *)contractOrder
                  assetPassword:(NSString *)assetPassword
                        success:(void (^)(NSNumber *))success
                        failure:(void (^)(id))failure;

/// 取消止盈止损单
+ (void)cancelProfitOrLossOrder:(BTContractOrderModel *)contractOrder
                  assetPassword:(NSString *)assetPassword
                        success:(void (^)(NSNumber *))success
                        failure:(void (^)(id))failure;

// 获取合约的深度
+ (void)getContractDeapthWithContractID:(int64_t)instrument_id
                                  price:(NSString *)price
                                  count:(NSInteger)count
                                success:(void (^)(BTDepthModel *))success
                                failure:(void (^)(NSError *))failure;

// 获取某一个contractID的成交记录
+ (void)getContractRecordWithContractID:(int64_t)instrument_id
                                success:(void (^)(NSArray <BTContractTradeModel *>*))success
                                failure:(void (^)(NSError *))failure;

// 获取某一个contractID的交易记录
+ (void)getContractUserRecordWithContractID:(int64_t)instrument_id
                                    orderID:(int64_t)order_id
                                     offset:(NSInteger)offset
                                       size:(NSInteger)size
                                    success:(void (^)(NSArray <BTContractRecordModel *>*))success
                                    failure:(void (^)(NSError *))failure;


// 资金划转
+ (void)fundTransferWithCoinCode:(NSString *)coin_code vol:(NSString *)vol type:(NSInteger)type success:(void (^)(id result))success
                         failure:(void (^)(id ))failure;

// 获得资金流水
+ (void)getCashBooksWithContractID:(int64_t)instrument_id
                             refID:(NSArray *)ref_id
                            action:(NSArray *)action
                          coinCode:(NSString *)coin_code
                             limit:(NSInteger)limit
                            offset:(NSInteger)offset
                             start:(NSString *)start
                               end:(NSString *)end
                           success:(void (^)(NSArray <BTCashBooksModel *>*))success
                           failure:(void (^)(NSError *))failure;

// 获得资金费率
+ (void)getFundingrateWithContractID:(int64_t)instrument_id
                             success:(void (^)(id result))success
                             failure:(void (^)(id ))failure;

// 获取仓位资金费率
+ (void)getPositionFundingrateWithContractID:(int64_t)instrument_id
                                         pid:(int64_t)pid
                                     success:(void (^)(id result))success
                                     failure:(void (^)(id ))failure;

// 获取保险基金记录
+ (void)getRiskReservesWithContractID:(int64_t)instrument_id
                              success:(void (^)(NSArray *result))success
                              failure:(void (^)(id ))failure;
 
// 调整保证金
+ (void)marginDepositWithContractID:(int64_t)instrument_id
                         positionID:(int64_t)position_id
                                vol:(NSString *)vol
                           operType:(NSInteger)oper_type
                            success:(void (^)(id result))success
                            failure:(void (^)(id ))failure;

// 获取用户爆仓记录
+ (void)getEserLiqRecordsWithContractID:(int64_t)instrument_id
                                orderID:(int64_t)order_id
                                success:(void (^)(id result))success
                                failure:(void (^)(id ))failure;

// 创建合约账户
+ (void)createContractAccountWithContractID:(int64_t)instrument_id
                                    success:(void (^)(id result))success
                                    failure:(void (^)(id ))failure;

//MARK:-5.23新增全局杠杆
// 获取全局杠杆
+ (void)getGlobalLeverage:(int64_t)instrument_id
                  success:(void (^)(NSArray <SLGlobalLeverageEntity *>*result))success
                  failure:(void (^)(id ))failure;

// 设置全局杠杆
+ (void)setGlobalLeverage:(int64_t)instrument_id
                 leverage:(int)leverage
             positionType:(BTPositionOpenType)position_type
                      way:(BTContractOrderWay)side  // （1，4）可传可不传,不传默认开多开空都设置
                  success:(void (^)(NSArray <SLGlobalLeverageEntity *>*result))success
                  failure:(void (^)(id ))failure;

//MARK:-7.1新增
/**
* @brief      下单 止盈止损 同步订单  注意：开仓才有止盈止损单类型
*/
+ (void)sendContractsOrder:(BTContractOrderModel *)contractOrder
        contractOrderType:(BTContractOrderType)type
         profitOrLossModel:(BTProfitOrLossModel *)missionModel
             assetPassword:(NSString *)assetPassword
                   success:(void (^)(NSNumber *))success
                   failure:(void (^)(id))failure;

@end
