//
//  BTDrawLineManager.h
//  BTStore
//
//  Created by 健 王 on 2018/3/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTDrawLineDataCatch.h"

@class BTLineDataModel;
@interface BTDrawLineManager : NSObject

@property (nonatomic,assign) NSInteger kCount; // K线条数

+ (instancetype)shareManager;

@property (nonatomic, strong) NSMutableArray <BTLineDataModel *>*lineDataArr;

- (instancetype)initWithType:(NSInteger)type;

- (NSMutableArray*)queryLineDataWithCoin:(NSString *)coin type:(SLFrequencyType)type contractID:(int64_t)instrument_id;

- (BOOL)updateQueryLineData:(NSArray *)dataArr type:(SLFrequencyType)type contractID:(int64_t)instrument_id;

/// 请求 K 线数据
/// @param coin 币种
/// @param instrument_id 币种 ID
/// @param type 合约为3
/// @param frequencyType K线类型
/// @param previewDataBlock 首屏预览数据回调 (分时/周线/月线 时为 nil)
/// @param middleDataBlock 第二次回调数据
/// @param fullDataBlock 全部数据回调
/// @param failure 失败回调
- (void)loadDataWithCoin:(NSString *)coin
              contractID:(int64_t)instrument_id
                    type:(SLLineType)type
           frequencyType:(SLFrequencyType)frequencyType
        previewDataBlock:(void (^)(NSArray <BTItemModel *> *itemModelArray))previewDataBlock
        middleDataBlock:(void (^)(NSArray <BTItemModel *> *itemModelArray))middleDataBlock
           fullDataBlock:(void (^)(NSArray <BTItemModel *> *itemModelArray))fullDataBlock
                 failure:(void (^)(NSError *))failure;

- (void)resetFlushCount:(NSString *)coin contractID:(int64_t)instrument_id;
@end
