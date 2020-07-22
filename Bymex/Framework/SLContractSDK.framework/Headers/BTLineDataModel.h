//
//  BTLineDataModel.h
//  BTStore
//
//  Created by 健 王 on 2018/3/28.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTLineModel :NSObject
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSNumber *preTime;
@property (nonatomic, copy) NSNumber *endTime;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)lineModelWithDict:(NSDictionary *)dict;
@end

@interface BTLineDataModel : NSObject
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, strong) BTLineModel *timeLine;
@property (nonatomic, strong) BTLineModel *fiveMinLine;
@property (nonatomic, strong) BTLineModel *thirtyMinLine;
@property (nonatomic, strong) BTLineModel *hourLine;
@property (nonatomic, strong) BTLineModel *dayLine;
@property (nonatomic, strong) BTLineModel *weekLine;
@end

