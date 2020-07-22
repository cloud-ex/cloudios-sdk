//
//  BTAccount.h
//  BTStore
//
//  Created by WWLy on 2018/1/14.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTAccount : NSObject

@property (nonatomic, copy) NSString *Ssid;     // Ssenion_ID
@property (nonatomic, copy) NSString *Token;    // Token
@property (nonatomic, copy) NSString *Uid;      // Uid
@property (nonatomic, copy) NSNumber *account_id;
/// 从EXUP系统申请而来
@property (nonatomic, copy) NSString *access_key;
/// 过期时间  EXUP合作交易所获取
@property (nonatomic, copy) NSString *expiredTs;
@property (nonatomic, strong) NSDictionary *headers;

@end
