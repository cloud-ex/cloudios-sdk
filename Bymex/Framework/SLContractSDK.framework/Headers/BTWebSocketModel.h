//
//  BTWebSocketModel.h
//  GGEX_Appstore//
//  Created by WWLY on 2018/10/26.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTContractOrderModel.h"
#import "BTPositionModel.h"
#import "BTItemCoinModel.h"
#import "BTContractOrderModel.h"

typedef NS_ENUM(NSInteger, BTWebSocketCUDType) {
    BTWebSocketCUD_1 = 1,   // 撮合    订单更新,仓位更新,合约资产更新
    BTWebSocketCUD_2,       // 提交订单 订单更新,仓位更新,合约资产更新
    BTWebSocketCUD_3,       // 取消订单 订单更新,仓位更新,合约资产更新
    BTWebSocketCUD_4,       // 强平取消订单 订单更新,仓位更新,合约资产更新
    BTWebSocketCUD_5,       // 被动ADL取消订单 订单更新,仓位更新,合约资产更新
    BTWebSocketCUD_6,       // 部分强平 订单更新,仓位更新,合约资产更新
    BTWebSocketCUD_7,       // 破产委托 新增订单,仓位更新,合约资产更新
    BTWebSocketCUD_8,       // 被动ADL撮合成交 订单更新,仓位更新,合约资产更新
    BTWebSocketCUD_9,       // 主动ADL撮合成交 订单更新,仓位更新,合约资产更新
    BTWebSocketCUD_10,      // 从现货资产化入到合约资产 合约资产更新,现货资产更新
    BTWebSocketCUD_11,      // 从合约资产化出到现货资产 合约资产更新,现货资产更新
    BTWebSocketCUD_12,      // 追加保证金 仓位更新,合约资产更新
    BTWebSocketCUD_13       // 减少保证金 仓位更新,合约资产更新
};

@interface BTWebSocketModel : NSObject
@property (nonatomic, assign) BTWebSocketCUDType action;
@property (nonatomic, strong) BTContractOrderModel *order;
@property (nonatomic, strong) BTContractOrderModel *spotOrder;
@property (nonatomic, strong) BTPositionModel *position;
@property (nonatomic, strong) BTItemCoinModel *c_assets;
@property (nonatomic, strong) NSArray <BTItemCoinModel *>*s_assets;
+ (instancetype)webSocketWithDict:(NSDictionary *)dict;
@end
