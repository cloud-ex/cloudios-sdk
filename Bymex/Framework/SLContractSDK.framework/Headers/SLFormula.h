//
//  SLFormula.h
//  SLContractSDK
//
//  Created by WWLy on 2019/8/19.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTPositionModel.h"
#import "BTContractOrderModel.h"
#import "BTContractsOpenModel.h"
#import "BTItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLFormula : NSObject

#pragma mark - 计算维持保证金率MMR
+ (NSString *)calculateMMRWithTotalValue:(NSString *)value
                               riskLimit:(BTContractsModel *)contract;
#pragma mark - 计算维持保证金MM
+ (NSString *)calculateMMWithTotalValue:(NSString *)value
                              riskLimit:(BTContractsModel *)contract;
#pragma mark - 计算开仓保证金率
+ (NSString *)calculateIMRWithTotalValue:(NSString *)value
                               riskLimit:(BTContractsModel *)contract;
#pragma mark - 计算开仓保证金
+ (NSString *)calculateIMWithTotalValue:(NSString *)value
                              riskLimit:(BTContractsModel *)contract;
#pragma mark - 计算仓位的维持保证金率
+ (NSString *)calculatePositionMMRWithPosition:(BTPositionModel *)position
                                      contract:(BTContractsModel *)contract;

#pragma mark - 计算仓位的开仓保证金率
+ (NSString *)calculatePositionIMRWithPosition:(BTPositionModel *)position
                                      contract:(BTContractsModel *)contract;
#pragma mark - 计算仓位的开仓保证金
+ (NSString *)calculatePositionIMWithPosition:(BTPositionModel *)position
                                    riskLimit:(BTContractsModel *)contract;

#pragma mark - 通过用户资产计算用户将资产全部开仓保证金率
+ (NSString *)calculateOrderIMRWithAsset:(NSString *)asset
                                 advance:(ContractOrderSize *)advance
                                position:(BTPositionModel *)position
                                contract:(BTContractsModel *)contractInfo;
#pragma mark - 通过量和价格计算合约价值
+ (NSString *)calculateContractValueWithVol:(NSString *)vol
                                      price:(NSString *)price
                                   contract:(BTContractsModel *)contractModel;
#pragma mark - 通过价值和量计算价格
+ (NSString *)calculateQuotePriceWithValue:(NSString *)value
                                       vol:(NSString *)vol
                                  contract:(BTContractsModel *)contractModel;
#pragma mark - 通过价格和资产计算量
+ (NSString *)calculateVolumeWithAsset:(NSString *)asset
                                 price:(NSString *)price
                                 lever:(NSString *)lever
                               advance:(ContractOrderSize *)advance
                              position:(BTPositionModel *)position
                          positionType:(BTPositionType)positionType
                          contractInfo:(BTContractsModel *)contractInfo;
#pragma mark - 根据价格和开仓方向判断是否会强平
+ (BOOL)IsLiquidateWithPositionType:(BTPositionType)positionType
             positionLiquidatePrice:(NSString *)positionLiquidatePrice
                          fairPrice:(NSString *)fairPrice;

#pragma mark - 计算订单的强平价格
+ (NSString *)calculateOrderLiquidatePriceWithOrder:(BTContractOrderModel *)order
                                             assets:(BTItemCoinModel *)assets
                                           contract:(BTContractsModel *)contractModel;

#pragma mark - 计算仓位的强平价格
+ (NSString *)calculatePositionLiquidatePrice:(BTPositionModel *)position
                                       assets:(BTItemCoinModel *)assets
                                 contractInfo:(BTContractsModel *)contractInfo;

#pragma mark - 计算仓位破产价
+ (NSString *)calculateBankruptcyPrice:(BTPositionModel *)position
                                assets:(BTItemCoinModel *)assets
                              contract:(BTContractsModel *)contractModel;

#pragma mark - 计算多仓位的未实现盈亏
+ (NSString *)calculateCloseLongProfitAmount:(NSString *)vol
                                holdAvgPrice:(NSString *)openPrice
                                   markPrice:(NSString *)closePrice
                                contractSize:(NSString *)contractSize
                                   isReverse:(BOOL)isReverse;
#pragma mark - 计算空仓位的未实现盈亏
+ (NSString *)calculateCloseShortProfitAmount:(NSString *)vol
                                 holdAvgPrice:(NSString *)openPrice
                                    markPrice:(NSString *)closePrice
                                 contractSize:(NSString *)contractSize
                                    isReverse:(BOOL)isReverse;
#pragma mark - 计算仓位的实际杠杆
+ (NSString *)calculatePositionLeverageWithPosition:(BTPositionModel *)position
                                           contract:(BTContractsModel *)contractModel;

#pragma mark - 计算订单的takeFee
+ (NSString *)calculateOrderTakeFee:(NSString *)orderVol
                         orderPrice:(NSString *)orderPrice
                       takeFeeRatio:(NSString *)takeFeeRatio
                           contract:(BTContractsModel *)contract;

#pragma mark - 计算订单的makeFee
+ (NSString *)calculateOrderMakeFee:(NSString *)orderVol
                         orderPrice:(NSString *)orderPrice
                       makeFeeRatio:(NSString *)makeFeeRatio
                           contract:(BTContractsModel *)contract;

#pragma mark - 合约单位转换，将币转成张
+ (NSString *)coinToTicket:(NSString *)vol price:(NSString *)price contract:(BTContractsModel *)contract;

#pragma mark - 合约单位转换，将张转成币
+ (NSString *)ticketToCoin:(NSString *)vol price:(NSString *)price contract:(BTContractsModel *)contract;

#pragma mark - 判断是否有该仓位未成交状态的平仓委托单
+ (NSArray *)getCloseEntrustOrderWithPosition:(BTPositionModel *)positionModel;


#pragma mark - 根据codeCoin和仓位方向获取仓位
+ (BTPositionModel *)getUserPositionWithCoinCode:(NSString *)codeCoin
                                      contractID:(int64_t)contractID
                                     contractWay:(BTContractOrderWay)way;

#pragma mark - 根据合约模型和仓位方向获取仓位
+ (BTPositionModel *)getUserPositionWithItemModel:(BTItemModel *)itemModel
                                      contractWay:(BTContractOrderWay)way;

#pragma mark - 根据contractID获取ContractInfo
+ (BTContractsModel *)getContractInfoWithContractID:(int64_t)instrument_id;

#pragma mark - 通过量和价格计算合约的基础比价值
+ (NSString *)calculateContractBasicValueWithPrice:(NSString *)price
                                               vol:(NSString *)vol
                                          contract:(BTContractsModel *)contract;

#pragma mark - 获取回应marginCode 的仓位数组
+ (NSArray *)getPositionsWithCode:(NSString *)coin_code;

#pragma mark - 计算预计开仓均价
+ (NSString *)carculateOpenAveragePriceWithOrder:(BTContractOrderModel *)order;

#pragma mark - 计算订单预计盈利额、盈利率
+ (void)carculateOrderAnticipateProfit:(BTContractOrderModel *)order performPrice:(NSString *)performPx callback:(void (^)(NSString *,NSString *))callbackResult;

#pragma mark - 计算订单预计亏损额、亏损率
+ (void)carculateOrderAnticipateLoss:(BTContractOrderModel *)order performPrice:(NSString *)performPx callback:(void (^)(NSString *,NSString *))callbackResult;

#pragma mark - 计算仓位预计盈利额、盈利率
+ (void)carculatePositionAnticipateProfit:(BTPositionModel *)position performPrice:(NSString *)performPx callback:(void (^)(NSString *,NSString *))callbackResult;

#pragma mark - 计算仓位预计亏损额、亏损率
+ (void)carculatePositionAnticipateLoss:(BTPositionModel *)position performPrice:(NSString *)performPx callback:(void (^)(NSString *,NSString *))callbackResult;

@end

NS_ASSUME_NONNULL_END
