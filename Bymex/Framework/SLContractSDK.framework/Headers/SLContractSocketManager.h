//
//  SLContractSocketManager.h
//  GGEX_Appstore
//
//  Created by WWLY on 2019/9/11.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTWebSocketModel.h"
#import "BTAccount.h"
#import "BTDrawLineDataCatch.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ContractWebSocketDidOpenNote;           // 链接成功
extern NSString * const ContractWebSocketDidCloseNote;          // 断开（根据错误码判断是否异常断开）
extern NSString * const ContractWebSocketReconnectNote;         // 开始重连
extern NSString * const ContractWebSocketDidConnectFailureNote; // 链接失败
extern NSString * const ContractWebSocketdidReceiveMessageNote;

/// 订阅的主题类型, 默认需要合约 ID
typedef NS_ENUM (NSInteger, BTSocketDataType) {
    BTSocketDataTypeSpotTicker,         // 现货实时价格
    BTSocketDataTypeSpotTrade,          // 现货最新成交
    BTSocketDataTypeSpotOrderBook,      // 现货深度
    
    BTSocketDataTypeContractTicker,     // 合约实时价格
    BTSocketDataTypeContractTrade,      // 合约最新成交
    BTSocketDataTypeContractPNL,        // 合约自动减仓排名
    BTSocketDataTypeContractOrderBook,  // 合约深度
    BTSocketDataTypeQuoteBin,           // 合约k线
    
    BTSocketDataTypeUnicast,            // 现货私有信息 (订单信息, 仓位信息, 合约资产, 现货资产)
};

typedef NS_ENUM (NSInteger, BTSocketDataActionType) {
    BTSocketDataActionUnKnow,               // 没有数据
    BTSocketDataActionAllData = 1,          // 全部数据
    BTSocketDataActionUpdate = 2,           // 数据更新
    BTSocketDataActionInset = 4,            // 数据插入
    BTSocketDataActionDelete = 5,           // 数据删除
};

@interface SLContractSocketManager : NSObject
/// 是否连接上了 socket
@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
/// 是否认证通过
@property (nonatomic, assign, readonly, getter=isAuthenticated) BOOL authenticated;

/// 单例
+ (instancetype)sharedManager;

/// 连接 socket
- (void)SRWebSocketOpenWithURLString:(NSString *)urlString;

/// 断开 socket
- (void)SRWebSocketClose;

/// 发送数据
- (void)sendData:(id)data;

/// 认证
- (void)authenticateWithAccount:(BTAccount *)account;

/// 订阅私有信息, 内部会进行认证
- (void)subscribeUnicastDataAfterAuthenticatedWithAccount:(BTAccount *)account;

/// 重新订阅私有信息 (会重新认证, 切换用户后调用)
- (void)updateSubscribeUnicastDataAfterAuthenticatedWithAccount:(BTAccount *)account;

/// 取消订阅私有信息
- (void)unSubscribeUnicastData;

/**
 订阅数据更新
 
 @param dataType 数据类型
 @param instruments 合约数组
 */
- (void)subscribeDataWithType:(BTSocketDataType)dataType instruments:(NSArray *)instruments;

/**
 取消数据更新订阅
 
 @param dataType 数据类型
 @param instruments 合约数组
 */
- (void)unSubscribeDataWithType:(BTSocketDataType)dataType instruments:(NSArray *)instruments;

/**
 订阅数据更新
 
 @param dataType 数据类型
 @param instrument_id 合约 ID (0 代表空)
 @param kLineDataType k 线类型
 */
- (void)subscribeDataWithType:(BTSocketDataType)dataType instrumentID:(int64_t)instrument_id kLineDataType:(SLFrequencyType)kLineDataType;

/**
 取消数据更新订阅
 
 @param dataType 数据类型
 @param instrument_id 合约 ID
 @param kLineDataType k 线类型 
 */
- (void)unSubscribeDataWithType:(BTSocketDataType)dataType instrumentID:(int64_t)instrument_id kLineDataType:(SLFrequencyType)kLineDataType;

@end

NS_ASSUME_NONNULL_END
