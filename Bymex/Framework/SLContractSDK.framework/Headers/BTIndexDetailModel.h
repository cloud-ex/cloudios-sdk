//
//  BTIndexDetailModel.h
//  SLContractSDK
//
//  Created by WWLy on 2018/11/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTIndexDetailModel : NSObject

@property (nonatomic, assign) int64_t instrument_id;
@property (nonatomic, assign) int64_t uid;
@property (nonatomic, assign) int64_t pid;
@property (nonatomic, copy) NSString *fair_px;
@property (nonatomic, copy) NSString *funding_rate;
@property (nonatomic, copy) NSString *tax;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSNumber *timestamp;
@property (nonatomic, copy) NSString *qty;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *vol;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
