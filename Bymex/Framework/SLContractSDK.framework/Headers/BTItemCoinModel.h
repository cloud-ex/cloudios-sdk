//
//  BTItemCoinModel.h
//  SLContractSDK
//
//  Created by KarlLichterVonRandoll on 2020/6/6.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTItemCoinModel : NSObject
@property (nonatomic, copy) NSString *coin_code;
@property (nonatomic, copy) NSString *freeze_vol;
@property (nonatomic, copy) NSString *available_vol;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;

// 合约
@property (nonatomic, copy) NSString *contract_avail;
@property (nonatomic, assign) int64_t account_id; // 账号ID
@property (nonatomic, assign) int64_t instrument_id; // 合约ID
@property (nonatomic, copy) NSString *name; // 名字
@property (nonatomic, copy) NSString *earnings_vol;   // 已结算收益
@property (nonatomic, copy) NSString *realised_vol;   // 已实现盈亏
@property (nonatomic, copy) NSString *bonus_vol;      // 体验金
@property (nonatomic, copy) NSString *cash_vol; // 净现金余额

@property (nonatomic, copy) NSString *transfer; // 可转金额

// 计算仓位强平价格时期的可用
- (NSString *)getPositionCloseValue:(int64_t)position_id;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)itemCoinModelWithDict:(NSDictionary *)dict;
@end
