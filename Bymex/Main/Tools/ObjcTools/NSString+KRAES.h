//
//  NSString+KRAES.h
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (KRAES)
/**< 加密方法 */
- (NSString*)bt_encryptWithAES; // 128
/**< 解密方法 */
- (NSString*)bt_decryptWithAES;

- (NSString *)aes256_encrypt:(NSString *)key nonce:(NSString *)nonce;
- (NSString *)aes256_decrypt:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
