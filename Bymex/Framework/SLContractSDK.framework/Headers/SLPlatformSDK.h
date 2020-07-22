//
//  SLPlatformSDK.h
//  SLContractSDK
//
//  Created by WWLy on 2019/8/14.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTItemCoinModel;
@protocol SLFutureDataRefreshProtocol <NSObject>

- (void)sl_refreshUserContractPerpoty:(NSArray <BTItemCoinModel *>*)perpoty;
@optional
- (void)sl_refreshUserFeeConfig;
@end

@class BTAccount;
@interface SLPlatformSDK : NSObject

@property (nonatomic, copy) NSString *transferConfig;

@property (nonatomic, strong) BTAccount *activeAccount;

/**
 * @brief     初始化SLPlatformSDK信息
 * @return    SLPlatformSDK    生成的SLPlatformSDK对象实例
 */
+ (SLPlatformSDK *)sharedInstance;

/**
 *  @brief 初始化合约账户基本数据信息（初始化成功会请求用户资产跟用户仓位）
 *  @param account  个人合约账户基本信息
 */
- (void)sl_startWithAccountInfo:(BTAccount *)account;

/**
 *  @brief 加载用户合约资产
 */
- (void)sl_loadUserContractPerpoty;

/**
 *  @brief 加载用户合约资产
 */
- (void)sl_loadUserContractPerpotyCallBack:(void (^)(NSArray <BTItemCoinModel *>*))success;

/**
 *  @brief 获取用户单个币种的合约资产
 *  @param coin 资产单个币种
 */
- (BTItemCoinModel *)sl_getUserFutureCoinAssetsWithCoinCode:(NSString *)coin;

/**
 *  @brief 该币种有没有开通账户
 *  @param coin 币种
 */
- (BOOL)sl_determineWhetherToOpenContractWithCoinCode:(NSString *)coin;

/**
 *  设置更新数据代理，从而监控数据刷新回传
 *
 *  @param platformDelegate platformDelegate @see SLFutureDataRefreshProtocol
 */
- (void)setPlatformDelegate:(id<SLFutureDataRefreshProtocol>)platformDelegate;

/**
 * 退出登录
 */
- (void)sl_logout;

@end
