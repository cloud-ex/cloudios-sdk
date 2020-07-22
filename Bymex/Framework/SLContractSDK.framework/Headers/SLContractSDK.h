//
//  SLContractSDK.h
//  SLContractSDK
//
//  Created by WWLy on 2019/8/6.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLSDK.h"
#import "SLPlatformSDK.h"
#import "SLSocketDataManager.h"
#import "BTAccount.h"
#import "BTContractsModel.h"
#import "BTContractsOpenModel.h"
#import "BTContractRecordModel.h"
#import "BTContractOrderModel.h"
#import "BTContractTradeModel.h"
#import "BTContractTool.h"
#import "BTPositionModel.h"
#import "BTStoreData.h"
#import "BTMaskFutureTool.h"
#import "BTMineAccountTool.h"
#import "SLContractSocketManager.h"
#import "SLMinePerprotyModel.h"
#import "BTDrawLineManager.h"
#import "BTDrawLineDataCatch.h"
#import "BTLineDataModel.h"
#import "SLGlobalLeverageEntity.h"
#import "SLPublicSwapInfo.h"
#import "SLPersonaSwapInfo.h"
#import "BTItemCoinModel.h"
#import "BTFormat.h"
#import "BTSafeTimer.h"
#import "BTLanguageTool.h"
#import "SLFormula.h"

// BTNotification
#define BTNoteCenter [NSNotificationCenter defaultCenter]


#pragma mark - send Post Notification
// 获取合约信息成功
#define BTLoadContractsInfo_Notification                    @"BTLoadContractsInfo_Notification"
// 接口加载合约更新资产
#define BTFutureProperty_Notification                       @"BTFutureProperty_Notification"
// 接口加载合约市场成功
#define BTLoadFuturesData_Notification                      @"BTLoadFuturesData_Notification"

#pragma mark - websocket Notification

/// Contract实时价格更新
#define BTSocketDataUpdate_Contract_Ticker_Notification     @"BTSocketDataUpdate_Contract_Ticker_Notification"
/// Contract深度数据更新
#define BTSocketDataUpdate_Contract_Depth_Notification      @"BTSocketDataUpdate_Contract_Depth_Notification"
/// Contract已成交数据
#define BTSocketDataUpdate_Contract_Trade_Notification      @"BTSocketDataUpdate_Contract_Trade_Notification"
/// Contract私有信息更新
#define BTSocketDataUpdate_Contract_Unicast_Notification    @"BTSocketDataUpdate_Contract_Unicast_Notification"
/// K线数据
#define SLSocketDataUpdate_QuoteBin_Notification            @"SLSocketDataUpdate_QuoteBin_Notification"

/// 登录Token失效
#define SLToken_Lose_effectiveness_Notification             @"SLToken_Lose_effectiveness_Notification"


//! Project version number for SLContractSDK.
FOUNDATION_EXPORT double SLContractSDKVersionNumber;
//! Project version string for SLContractSDK. 
FOUNDATION_EXPORT const unsigned char SLContractSDKVersionString[];


