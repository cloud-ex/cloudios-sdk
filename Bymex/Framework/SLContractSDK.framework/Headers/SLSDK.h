//
//  SLSDK.h
//  SLContractSDK
//
//  Created by WWLy on 2019/8/14.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTItemModel.h"
#import "SLPrivateConfig.h"

@class BTContractTradeModel;

typedef void(^SLRequestCallBack)(id result,NSError *error);

@class BTDepthModel,BTIndexDetailModel;

@interface SLSDK : NSObject

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, copy) NSString *USDRate;

/**
 * @brief       初始化SDK信息
 * @return      生成的SLSDK对象实例
 */
+ (SLSDK *)sharedInstance;

/**
 *  @brief      初始化SDK基本数据信息 （AppDelegate中调用）
 *  @param      appId  当前应用
 *  @param      launchOption 参数格式 {base_host: xx, host_Header : xx, PRIVATE_KEY: xx}   合约云用户 {base_host: xx, host_Header : xx}
 */
- (void)sl_startWithAppID:(NSString *)appId launchOption:(SLPrivateConfig *)launchOption callBack:(SLRequestCallBack)callBack;

/**
 *  @brief      合约市场数据
 *  finished    返回结果
 */
+ (void)sl_loadFutureMarketData:(SLRequestCallBack)finished;

/**
 *  @brief      获取合约最新成交记录
 *  @param      instrument_id  合约id
 *  callBack    返回最新成交数组
 */
+ (void)sl_loadFutureLatestDealWithContractID:(int64_t)instrument_id
                                 callbackData:(void (^)(NSArray <BTContractTradeModel *> *))callBack;
/**
 *  @brief      获取合约深度
 *  @param      instrument_id     合约id
 *  @param      price           最新成交价
 *  @param      count           数量
 *  success     深度模型
 */
+ (void)sl_loadOrderBooksWithContractID:(int64_t)instrument_id
                                   price:(NSString *)price
                                   count:(NSInteger)count
                                 success:(void (^)(BTDepthModel *))success
                                 failure:(void (^)(NSError *))failure;

/**
 *  @brief      获取保险基金记录
 *  @param      instrument_id     合约id
 */
+ (void)sl_loadRiskReservesWithContractID:(int64_t)instrument_id
                                  success:(void (^)(NSArray <BTIndexDetailModel *>*result))success
                                  failure:(void (^)(id ))failure;

/**
 *  @brief      获取资金费率
 *  @param      instrument_id     合约id
 */
+ (void)sl_loadFundingrateWithContractID:(int64_t)instrument_id
                                 success:(void (^)(NSArray <BTIndexDetailModel *>*result))success
                                 failure:(void (^)(id ))failure;

/**
 *  @brief      请求合约K线数据
 *  @param      instrument_id     合约id
 *  @param      startTime       开始时间
 *  @param      endTime         结束时间
 *  @param      unit            单位
 *  @param      resolution      时间单位（M:分钟，H:小时， D:天）
 *  success     回调合约模型数组
 *  error       返回错误信息
 *  @dicuss
 */
+ (void)sl_loadFutureKLineDataWithContractID:(int64_t)instrument_id
                                   startTime:(NSNumber *)startTime
                                     endTime:(NSNumber *)endTime
                                        unit:(NSString *)unit
                                  resolution:(NSString *)resolution
                                     success:(void (^)(NSArray <BTItemModel *>*lineData))success
                                     failure:(void (^)(id error))failure;


// 设置日志输出状态
+ (void)setLogEnable:(BOOL)enable;

// 获取日志输出状态
+ (BOOL)getLogEnable;


+ (void)function:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString;

@end
