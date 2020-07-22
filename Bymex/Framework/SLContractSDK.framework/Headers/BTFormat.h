//
//  BTFormat.h
//  BTStore
//
//  Created by WWLy on 2018/1/29.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef DATE_FORMAT_SERVER_UTC

#define DATE_FORMAT_SERVER_UTC    @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
#define DATE_FORMAT_YMD           @"yyyy:MM:dd"
#define DATE_FORMAT_MD            @"MM:dd"
#define DATE_FORMAT_Hm            @"HH:mm"
#define DATE_FORMAT_Hms           @"HH:mm:ss"
#define DATE_FORMAT_YMDHm         @"yyyy-MM-dd HH:mm"
#define DATE_FORMAT_YMD2          @"yyyy/MM/dd"
#endif

@interface BTFormat : NSObject

+ (NSString *)timeOnlyDateStr:(NSString *)dateStr;    //2011-01-21 00:00:00
+ (NSString *)timeOnlyDate2Str:(NSString *)dateStr;
+ (NSString *)timeOnlyHourAndSec:(NSString *)dateStr;
+ (NSString *)timeOnlyHourMinuteSec:(NSString *)dateStr;
+ (NSString *)timeOnlyHourMinuteData:(NSDate *)date;
+ (NSString *)timeOnlyDateFromDateStr:(NSString *)dateStr;
+ (NSDate *)dateFromUTCString:(NSString*)dateStr;
+ (NSString *)date2localTimeStr:(NSDate*)date format:(NSString*)format;
+ (NSString *)datelocalTimeStr:(NSDate*)date format:(NSString*)format addDate:(NSTimeInterval)Date_sub;
+ (NSString *)timeOnlyDateHourStr:(NSString *)dateStr;
+ (NSString *)totalVolumeFromNumberStr:(NSString *)numberStr;
+ (NSString *)depthValueFromNumberStr:(NSString *)numberStr;
// 字符串转时间戳
+ (NSInteger)getTimeStrWithString:(NSString *)str;

@end
