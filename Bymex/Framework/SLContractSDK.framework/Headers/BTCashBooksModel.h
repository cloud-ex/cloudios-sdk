//
//  BTCashBooksModel.h
//  SLContractSDK
//
//  Created by WWLy on 2018/1/31.
//  Copyright © 2018年 Karl. All rights reserved.
//  合约账单

#import <Foundation/Foundation.h>
#import "BTContractRecordModel.h"

@interface BTCashBooksModel : NSObject

@property (nonatomic, assign) int64_t book_id;
@property (nonatomic, assign) int64_t account_id;
@property (nonatomic, assign) int64_t instrument_id;
@property (nonatomic, assign) int64_t ref_id;
@property (nonatomic, assign) BTContractRecordWay action;
@property (nonatomic, copy) NSString *coin_code;
@property (nonatomic, copy) NSString *deal_count;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *last_assets;
@property (nonatomic, copy) NSString *created_at;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
