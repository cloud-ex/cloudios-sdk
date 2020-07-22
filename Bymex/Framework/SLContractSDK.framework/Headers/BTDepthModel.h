//
//  BTDepthModel.h
//  BTStore
//
//  Created by WWLy on 2018/2/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLOrderBookModel : NSObject
@property (nonatomic, assign) int64_t instrument_id;
@property (nonatomic, assign) int64_t key;
@property (nonatomic, copy) NSString *px;
@property (nonatomic, copy) NSString *qty;
@property (nonatomic, copy) NSString *max_volume;
@property (nonatomic, copy) NSString *way;
@property (nonatomic, copy) NSString *addupQty;

+ (NSArray <SLOrderBookModel *>*)decodeOrdersWithArray:(NSArray *)arr instrumentID:(int64_t)instrument_id;

@end

@interface BTDepthModel : NSObject
@property (nonatomic, strong) NSArray <SLOrderBookModel *>*sells;
@property (nonatomic, strong) NSArray <SLOrderBookModel *>*buys;
@end
