//
//  SLSocketDataManager.h
//  GGEX_Appstore
//
//  Created by WWLY on 2019/9/9.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTWebSocketModel.h"
#import "BTDrawLineDataCatch.h"

NS_ASSUME_NONNULL_BEGIN

/// 负责数据的更新和传递
@interface SLSocketDataManager : NSObject

/// socket 数据更新
@property (nonatomic, copy) void (^sl_dataUpdatedFromSocket)(id data);

@property (nonatomic, copy) NSString *socketUrl;

+ (instancetype)sharedInstance;


/********************************************************  合约订阅  *******************************************************/

/**
 *  订阅合约实时价格 socket
 */
- (void)sl_subscribeContractTickerData:(NSArray *)instruments;

/**
 订阅合约深度 socket
 @param instrument_id 合约ID
 */
- (void)sl_subscribeContractDepthDataWithInstrument:(int64_t)instrument_id;

/**
 取消合约订阅深度 socket
 @param instrument_id 合约ID
 */
- (void)sl_unSubscribeContractDepthDataWithInstrument:(int64_t)instrument_id;

/**
 订阅合约成交记录 socket
 @param instrument_id 合约ID
 */
- (void)sl_subscribeContractTradeDataWithInstrument:(int64_t)instrument_id;

/**
 取消订阅合约成交记录 socket
 @param instrument_id 合约ID
 */
- (void)sl_unSubscribeContractTradeDataWithInstrument:(int64_t)instrument_id;

/**
 * 订阅 k 线图数据 socket
 * 通过监听 SLSocketDataUpdate_QuoteBin_Notification 通知获取数据
 * 数据格式: {@"data": NSArray <BTItemModel *> *, @"kLineDataType": @(SLFrequencyType)}
 * @param contract_id   合约 ID
 * @param kLineDataType  k 线图类型
 */
- (void)sl_subscribeQuoteBinDataWithContractID:(int64_t)contract_id stockLineDataType:(SLFrequencyType)kLineDataType;

/**
 * 取消订阅 k 线图数据 socket
 * @param contract_id   合约 ID
 * @param kLineDataType  k 线图类型
*/
- (void)sl_unsubscribeQuoteBinDataWithContractID:(int64_t)contract_id stockLineDataType:(SLFrequencyType)kLineDataType;

/**
 处理合约数据
 */
- (void)sl_dealWithContractData:(NSDictionary *)data;


/********************************************************  资产订阅  *******************************************************/

/**
 * 订阅私有信息(订单信息, 仓位信息, 合约资产, 现货资产)
 */
- (void)sl_subscribeContractUnicastData;

/**
 * 取消订阅私有信息
 */
- (void)sl_unSubscribeContractUnicastData;

@end

NS_ASSUME_NONNULL_END
