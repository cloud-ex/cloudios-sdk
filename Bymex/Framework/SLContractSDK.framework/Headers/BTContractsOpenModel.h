//
//  BTContractsOpenModel.h
//  SLContractSDK
//
//  Created by WWLy on 2018/1/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTContractOrderModel.h"
#import "BTItemCoinModel.h"

@interface ContractOrderSize : NSObject
@property (nonatomic, copy) NSString *advanceVol;
@property (nonatomic, copy) NSString *advancePrice;
@end

@interface BTContractsOpenModel : NSObject

@property (nonatomic, copy) NSString *orderAvai; // 订单价值

@property (nonatomic, copy) NSString *IM; // 添加到保证金的额度
@property (nonatomic, copy) NSString *MM; // 添加到维持保证金的额度
@property (nonatomic, copy) NSString *TakeFee;// 订单成交部分的提取流动性费用
@property (nonatomic, copy) NSString *MakeFee;// 订单成交部分的提供流动性费用
@property (nonatomic, copy) NSString *ReleaseAssets;// 需要释放的冻结资产
@property (nonatomic, copy) NSString *AvailableAssets;// 需要添加到可用资产的额度
@property (nonatomic, copy) NSString *brankruptTake; // 破产保证金
@property (nonatomic, copy) NSString *maxTakeFee;
@property (nonatomic, copy) NSString *freezAssets;

@property (nonatomic, copy) NSString *liquidatePrice; // 强平价格
@property (nonatomic, copy) NSString *maxOpenLong;
@property (nonatomic, copy) NSString *maxOpenShort;

- (instancetype)initWithOrderModel:(BTContractOrderModel *)orderModel
                      contractInfo:(BTContractsModel *)contractInfo
                            assets:(BTItemCoinModel *)asset;

@end
