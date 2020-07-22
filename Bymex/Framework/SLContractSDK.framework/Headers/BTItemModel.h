//
//  BTItemModel.h
//  BTStore
//
//  Created by WWLy on 2018/1/9.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTContractsModel.h"
#import "BTIndexDetailModel.h"

typedef NS_ENUM(NSInteger, BTPriceFluctuationType) { // 价格波动
    BTPriceFluctuationUp = 1,
    BTPriceFluctuationDown
};

@interface BTItemRateModel : NSObject
@property (nonatomic, copy) NSString *base_rate;
@property (nonatomic, copy) NSString *interest_rate;
@property (nonatomic, copy) NSString *quote_rate;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

@interface BTItemModel : NSObject
#pragma mark - global Info
@property (nonatomic, assign) int64_t instrument_id;
@property (nonatomic, assign) int index;
@property (nonatomic, copy) NSString *index_px;  // 指数价格
@property (nonatomic, copy) NSString *fair_px;   // 标记价格
@property (nonatomic, copy) NSString *fair_basis; // 基差率
@property (nonatomic, copy) NSString *fair_value;   // 标记价值
@property (nonatomic, copy) NSString *funding_rate; // 资金费率
@property (nonatomic, copy) NSString *position_size; // 未平仓位量
@property (nonatomic, copy) NSString *premium_index; // 溢价指数
@property (nonatomic, copy) NSString *next_funding_rate; // 下一个预计资金费率
@property (nonatomic, copy) NSString *next_funding_at;      // 下一个结算时间(UTC时间)
@property (nonatomic, strong) BTItemRateModel *rate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *rank;
@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *big;
@property (nonatomic, copy) NSString *gray;

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString* last_px;
@property (nonatomic, copy) NSString* open;
@property (nonatomic, copy) NSString* close;

@property (nonatomic, copy) NSString* low;
@property (nonatomic, copy) NSString* high;
@property (nonatomic, copy) NSString* avg_px;
@property (nonatomic, copy) NSString* last_qty;
@property (nonatomic, copy) NSString* qty24;
@property (nonatomic, copy) NSNumber* timestamp;
@property (nonatomic, copy) NSString* change_rate;
@property (nonatomic, copy) NSString* change_value;
@property (nonatomic, copy) NSString *available_supply;

@property (nonatomic, copy) NSString *qty_day;
@property (nonatomic, copy) NSString *amount24;

@property (nonatomic, copy) NSString *index_market;
@property (nonatomic, copy) NSNumber *collectTime;

@property (nonatomic, assign) BTPriceFluctuationType trend;

@property (nonatomic, copy) NSString *base_coin_qty; // 基础币的交易量(币值对前面的币为基础币)
@property (nonatomic, copy) NSString *quote_coin_qty; // 计价币的交易量(币值对后面的币为计价币)

@property (nonatomic, strong) BTContractsModel *contractInfo;
/// 币种精度
@property (nonatomic, assign) NSUInteger precision;

@property (nonatomic, strong) NSArray *risk_revers_newest; // 保险基金
@property (nonatomic, copy) NSString *risk_revers_vol;


+ (instancetype)itemModelWithModel:(BTItemModel *)model;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)updateWithDict:(NSDictionary *)dict;
+ (instancetype)itemModelWithDict:(NSDictionary *)dict;

- (BOOL)hasLevearage:(NSString *)leverage type:(BTPositionOpenType)positionType;

@end
