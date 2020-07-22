//
//  SLPublicSwapInfo.h
//  SLContractSDK
//
//  Created by KarlLichterVonRandoll on 2020/6/4.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTContractsModel.h"

@class BTContractsModel,BTItemModel,BTDepthModel,SLOrderBookModel,BTContractTradeModel;
@interface SLPublicSwapInfo : NSObject

@property (nonatomic, readonly, assign) BOOL hasSwapInfo;
@property (nonatomic, readonly, assign) BOOL hasMoni; // 是否存在模拟合约

+ (SLPublicSwapInfo *)sharedInstance;

//MARK:- 合约信息
- (void)setSwapInfo:(NSArray<BTContractsModel *>*)swapArr;
- (NSArray <BTContractsModel *>*)getAllSwapInfo;
- (BTContractsModel *)getSwapInfo:(int64_t)instrument_id;


//MARK:- 市场ticket
- (void)setMarketTickers:(NSArray<BTItemModel *>*)tickers;
- (BTItemModel *)getTicker:(int64_t)instrument_id;
- (void)deleteTicker:(int64_t)instrument_id;

- (NSArray <BTItemModel *>*)getTickersWithArea:(BTContract_Block_Type)area; // CONTRACT_BLOCK_UNKOWN 获取全部


//MARK:- 深度OrderBooks
- (void)setOrderBookAsks:(NSArray<SLOrderBookModel *>*)asks;
- (void)setOrderBookBids:(NSArray<SLOrderBookModel *>*)Bids;

- (NSArray<SLOrderBookModel *>*)getAskOrderBooks:(int)count;  // 获取卖盘
- (NSArray<SLOrderBookModel *>*)getBidOrderBooks:(int)count;  // 获取买盘

- (BOOL)hasCurrentDepthModel;
- (void)clearOrderBooks;


// MARK:- 最新成交(最多获取40条)
- (void)setLatestTrades:(NSArray <BTContractTradeModel *>*)trades;
- (NSArray <BTContractTradeModel *>*)getLatestTrades:(int)count;

@end
