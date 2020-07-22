//
//  NSData+EX.h
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (EX)
-(NSData *)aes256_encrypt:(NSString *)key nonce:(NSString *)nonce;
-(NSData *)aes256_decrypt:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
