//
//  BTSafeTimer.h
//  BTStore
//
//  Created by Jason_Lee on 2018/2/3.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BTSafeTimer: NSObject
+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                       target:(id)aTarget
                                     selector:(SEL)aSelector
                                     userInfo:(id)userInfo;
@end
