//
//  SLMinePerprotyModel.h
//  SLContractSDK
//
//  Created by WWLy on 2019/8/15.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTContractsModel, BTItemCoinModel;
@interface SLMinePerprotyModel : NSObject
@property (nonatomic, copy) NSString *coin_code;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *total_amount;
@property (nonatomic, copy) NSString *avail_funds;
@property (nonatomic, copy) NSString *block_funds;
@property (nonatomic, copy) NSString *hold_coin;
@property (nonatomic, copy) NSString *convertInto; // 折合
@property (nonatomic, copy) NSString *walletBalance; // 钱包余额
@property (nonatomic, copy) NSString *depositBalance;   // 保证金余额
@property (nonatomic, copy) NSString *profitOrLoss;     // 未实现盈亏
@property (nonatomic, copy) NSString *holdDeposit;      // 仓位保证金
@property (nonatomic, copy) NSString *entrustDeposit;   // 委托保证金
@property (nonatomic, copy) NSString *depositRate;      // 保证金占有率

@property (nonatomic, strong) BTItemCoinModel *itemCoinModel;

+ (instancetype)sharedInstance;

/// 将所有资产转换成相应币种
- (void)conversionContractAssetsWithCoin:(NSString *)coinCode property:(NSArray *)propertyArr;
/// 计算某一币种的相应资产信息
- (void)conversionContractAssetsWithitemModel:(BTItemCoinModel *)itemModel;
@end
