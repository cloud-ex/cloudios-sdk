//
//  NSString+BTString.h
//  BTStore
//
//  Created by WWLy on 2018/4/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BT_ZERO         @"0"
#define DecimalPFive    @"0.5"
#define DecimalOne      @"1"
#define DecimalNe       @"-1"
#define BTZERO          @"0.00"

@interface NSString (BTString)

// 根据对应的币种缩小响应的精度(单个币值)
- (NSString *)toSmallPriceWithSpot_coin:(NSString *)coin_code;
- (NSString *)toSmallVolumeWithSpot_coin:(NSString *)coin_code;

// 根据合约id缩小到相应的精度
- (NSString *)toSmallEditPriceContractID:(int64_t)instrument_id;
- (NSString *)toSmallPriceWithContractID:(int64_t)instrument_id;
- (NSString *)toSmallVolumeWithContractID:(int64_t)instrument_id;
- (NSString *)toSmallValueWithContract:(int64_t)instrument_id;
- (NSString *)toSmallOrderBookWithContractID:(int64_t)instrument_id;

+ (NSInteger)getPrice_unitWithContractID:(int64_t)instrument_id;
+ (NSInteger)getVolume_unitWithContractID:(int64_t)instrument_id;

// 将数据按照精度缩小,并转化成字符串,参数表示小数点保留几位
- (NSString*)toString:(int)pointCount;
- (NSString *)toCarryString:(int)pointCount;

- (NSString *)toString:(int)pointCount cut:(BOOL)cut;

// 向上取整
- (NSString *)toDecimalUpString:(int)pointCount;
/// 获取指定位数小数, 位数不足直接返回, 后面的 0 去掉
- (NSString *)toDecimalString:(int)pointCount;

- (NSString*)toCNYString:(int)pointCount;

- (NSString*)toDollarString:(int)pointCount;
// 百分比字符串
- (NSString *)toPercentString:(int)pointCount;
- (BOOL)isZero;
- (BOOL)isLessThanOrEqualZero;
- (BOOL)LessThan:(NSString*)right;
- (BOOL)LessThanOrEqual:(NSString*)right;
- (BOOL)GreaterThan:(NSString*)right;
- (BOOL)GreaterThanOrEqual:(NSString*)right;
// 大数乘
- (NSString *)bigMul:(NSString*)right;
// 大数除
- (NSString *)bigDiv:(NSString*)right;
// 大数加
- (NSString *)bigAdd:(NSString*)right;
// 大数减
- (NSString *)bigSub:(NSString*)right;
// 去掉字符串末尾的0
+ (NSString *)cutOffEndZero:(NSString *)str  lessThan:(int)length;

- (NSString *)stringForDecimals:(NSString *)mals;

@end
