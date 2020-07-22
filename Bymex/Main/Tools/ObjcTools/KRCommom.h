//
//  KRCommom.h
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^CameraAuthCallback)(BOOL isConfrimed);

NS_ASSUME_NONNULL_BEGIN

@interface KRCommom : NSObject
+ (void)checkCameraPrivacyWithCallback:(CameraAuthCallback)callback;
+ (UIViewController *)topViewController;
+ (NSString*)md5:(NSString *)md5;
@end

NS_ASSUME_NONNULL_END
