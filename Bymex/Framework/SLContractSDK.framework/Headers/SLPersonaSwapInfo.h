//
//  SLPersonaSwapInfo.h
//  SLContractSDK
//
//  Created by KarlLichterVonRandoll on 2020/6/5.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTPositionModel, BTContractOrderModel, BTItemCoinModel;
@interface SLPersonaSwapInfo : NSObject

+ (SLPersonaSwapInfo *)sharedInstance;

//MARK:- 合约仓位
- (void)setPositions:(NSMutableArray *)positions instrumentID:(int64_t)instrument_id;
- (NSMutableArray <BTPositionModel *>*)getPositions:(int64_t)instrument_id;


//MARK:- 保证金仓位
- (void)setPositions:(NSMutableArray *)positions marginCoin:(NSString *)marginCoin;
- (NSMutableArray <BTPositionModel *>*)getCodePositions:(NSString *)marginCoin;
- (void)removeAllCodePositions;


//MARK:- 委托订单
- (void)setOrders:(NSMutableArray *)orders instrumentID:(int64_t)instrument_id;
- (NSMutableArray <BTContractOrderModel *>*)getOrders:(int64_t)instrument_id;


//MARK:- 计划委托订单
- (void)setPlanOrders:(NSMutableArray *)orders instrumentID:(int64_t)instrument_id;
- (NSMutableArray <BTContractOrderModel *>*)getPlanOrders:(int64_t)instrument_id;


//MARK:- 合约资产
- (void)setSwapAsset:(BTItemCoinModel *)swapAsset marginCode:(NSString *)marginCode;
- (void)setSwapAssets:(NSArray <BTItemCoinModel *>*)swapAssets;
- (BTItemCoinModel *)getSwapAssetItemWithCoin:(NSString *)coinCode;
- (NSArray <BTItemCoinModel *>*)getAllSwapAssetItem;


//MARK:- 更新仓位、订单、资产
- (void)updataPosition:(BTPositionModel *)position;
- (void)updataOrder:(BTContractOrderModel *)order;
- (void)updataAsset:(BTItemCoinModel *)item;

//MARK:- 清除用户资产数据
- (void)clearPersonalSwapInfo;

@end
