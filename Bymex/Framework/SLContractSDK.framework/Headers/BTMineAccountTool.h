//
//  BTMineAccountTool.h
//  BTStore
//
//  Created by WWLy on 2018/1/31.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTItemCoinModel.h"
#import "BTWebSocketModel.h"
#import "BTItemCoinModel.h"
#import "SLContractSocketManager.h"

@interface BTMineAccountTool : NSObject

+ (instancetype)shareMineAccountTool;

// 加载合约资产
- (void)loadContractAccountPropertyInfoWithContractID:(NSString *)contractID success:(void (^)(NSArray <BTItemCoinModel *>*response))success failure:(void (^)(NSError *))failure;

/// 处理websocket资产信息
- (void)handNewWebSocketPropertyData:(NSDictionary *)data handleResult:(void (^)(NSArray <BTWebSocketModel *>*, BTSocketDataActionType))success;

@end
