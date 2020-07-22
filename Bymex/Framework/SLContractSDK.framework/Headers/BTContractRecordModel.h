//
//  BTContractRecordModel.h
//  SLContractSDK
//
//  Created by WWLy on 2018/1/26.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTContractsModel.h"
typedef NS_ENUM(NSInteger, BTContractRecordWay) {
    CONTRACT_TRADE_WAY_UN_KNOW = 0,
    CONTRACT_ORDER_WAY_BUY_OPEN_LONG,           // 开多 买
    CONTRACT_ORDER_WAY_BUY_CLOSE_SHORT,         // 平空 买
    CONTRACT_ORDER_WAY_SELL_CLOSE_LONG,         // 平多 卖
    CONTRACT_ORDER_WAY_SELL_OPEN_SHORT,         // 开空 卖
    CONTRACT_WAY_BB_TRANSFER_IN,                //从现货账号转入
    CONTRACT_WAY_TRANSFER_TO_BB,                //转出到现货账号
    CONTRACT_WAY_CONTRACT_TRANSFER_IN,          //从合约账号转入
    CONTRACT_WAY_TRANSFER_TO_CONTRACT,          //转出到合约账号
    CONTRACT_WAY_REDUCE_DEPOSIT_TRANSFER,       //减少保证金,将保证金从仓位转移到合约账户
    CONTRACT_WAY_INCREA_DEPOSIT_TRANSFER,       //增加保证金,将合约账户的资产转移到仓位保证金
    CONTRACT_WAY_POSITION_FUND_FEE,             //仓位的资金费用
    CONTRACT_WAY_BOUNS_IN,                      //转入赠金
    CONTRACT_WAY_BOUNS_OUT,                     //转出赠金
    CONTRACT_WAY_FEE_TENTHS = 20,               //手续费分成
    CONTRACT_WAY_AIR_DROP = 21,                 //空投
    CONTRACT_WAY_ASSET_SWAP_IN = 22,            //合约云转入
    CONTRACT_WAY_ASSET_SWAP_OUT = 23,           //合约云转出
};

// 爆仓记录
@interface BTContractLipRecordModel : NSObject
@property (nonatomic, copy) NSString *coinCode;
@property (nonatomic, copy) NSString *marginCoin;
@property (nonatomic, copy) NSString *forcePrice;
@property (nonatomic, copy) NSString *trigger_px;
@property (nonatomic, assign) int64_t uid;
@property (nonatomic, assign) int64_t instrument_id;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *mmr;
@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSString *order_px;
@property (nonatomic, assign) int64_t pid;
@property (nonatomic, assign) int64_t subsidies; // 破产系统补贴额度
@property (nonatomic, assign) NSInteger type;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

// 获取用户的交易记录
@interface BTContractRecordModel : NSObject
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, assign) int64_t oid;         // taker order id
@property (nonatomic, assign) int64_t tid;         // trade id
@property (nonatomic, assign) int64_t instrument_id;      // 合约ID
@property (nonatomic, copy) NSString *px;       // 成交价
@property (nonatomic, copy) NSString *qty;         // 成交量
@property (nonatomic, copy) NSString *avai;             // 价值
@property (nonatomic, copy) NSString *make_fee;         // make fee
@property (nonatomic, copy) NSString *take_fee;         // take fee
@property (nonatomic, copy) NSString *created_at;       // 创建时间
@property (nonatomic, assign) BTContractRecordWay side;  // 交易方向
@property (nonatomic, copy) NSString *change;      // 对行情的影响
@property (nonatomic, copy) NSString *fee_coin_code; // 手续费代币码

@property (nonatomic, strong) BTContractsModel *contractInfo;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
