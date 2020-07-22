//
//  URLCookie.h
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/22.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLCookie : NSObject

- (void)addCookiesWithAppDomain;

- (void)clearCookiesWithAppDomain;

- (void)addCookiesInDomain:(NSString *)domain;

- (void) clearCookie:(NSString *)domain;

@end

NS_ASSUME_NONNULL_END
