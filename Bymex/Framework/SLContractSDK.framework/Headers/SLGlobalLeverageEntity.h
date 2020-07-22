//
//  SLGlobalLeverageEntity.h
//  SLContractSDK
//
//  Created by KarlLichterVonRandoll on 2020/5/23.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTContractOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLGlobalLeverageEntity : NSObject

@property (nonatomic, assign) int64_t account_id;
@property (nonatomic, copy) NSString *config_value; // 杠杆
@property (nonatomic, assign) BTContractOrderWay side;
@property (nonatomic, assign) BTPositionOpenType position_type;
@property (nonatomic, assign) NSString *created_at;
@property (nonatomic, assign) NSString *updated_at;
@property (nonatomic, assign) NSString *data_type;
@property (nonatomic, assign) NSString *config_key;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
