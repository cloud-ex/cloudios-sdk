//
//  BTContractTradeModel.h
//  SLContractSDK
//
//  Created by WWLy on 2018/8/6.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BTContractTradeWay) {
    CONTRACT_TRADE_WAY_TRADE_KNOW = 0,
    CONTRACT_TRADE_WAY_BUY_OLOS_1,         //买为taker,开多买开空卖
    CONTRACT_TRADE_WAY_BUY_OLCL_2,         //买为taker,开多买平多卖
    CONTRACT_TRADE_WAY_BUY_CSOS_3,         //买为taker,平空买开空卖
    CONTRACT_TRADE_WAY_BUY_CSCL_4,         //买为taker,平空买平多卖
    CONTRACT_TRADE_WAY_SELL_OSOL_5,        //卖为taker,开空卖,开多买
    CONTRACT_TRADE_WAY_SELL_OSCS_6,        //卖为taker,开空卖,平空买
    CONTRACT_TRADE_WAY_SELL_CLOL_7,        //卖为taker,平多卖,开多买
    CONTRACT_TRADE_WAY_SELL_CLCS_8,        //卖为taker,平多卖,平空买
};

// 合约成交记录
@interface BTContractTradeModel : NSObject

@property (nonatomic, assign) int64_t oid;
@property (nonatomic, assign) int64_t tid;
@property (nonatomic, assign) int64_t instrument_id;
@property (nonatomic, copy) NSString *px;
@property (nonatomic, copy) NSString *qty;
@property (nonatomic, copy) NSString *make_fee;
@property (nonatomic, copy) NSString *take_fee;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *change;
@property (nonatomic, assign) BTContractTradeWay side;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
