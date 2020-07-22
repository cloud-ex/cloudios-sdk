//
//  BTLanguageTool.h
//  BTStore
//
//  Created by WWLy on 2018/1/25.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CNS @"zh-cn"
#define EN @"en"

@interface BTLanguageTool : NSObject

+ (instancetype)sharedInstance;

- (NSString *)getCurrentLanguage;

- (void)setCurrentLaunguage:(NSString *)launguage;

@end
