//
//  NSDate+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/27.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

///大写的Y会导致时间多出一年

//yyyy-MM-dd HH:mm:ss
static NSString *const SeaDateFormatYMdHms = @"yyyy-MM-dd HH:mm:ss";

//yyyy-MM-dd HH:mm
static NSString *const SeaDateFormatYMdHm = @"yyyy-MM-dd HH:mm";

//yyyy-MM-dd
static NSString *const SeaDateFormatYMd = @"yyyy-MM-dd";

//北京时区
static NSString *const SeaTimeZoneBeiJing = @"Asia/BeiJing";

@interface NSDate (Utils)

/**NSDateFormatter 的单例 因为频繁地创建 NSDateFormatter 是非常耗资源的、耗时的
 */
+ (NSDateFormatter*)sharedDateFormatter;

#pragma mark- 单个时间

///获取当前时间的 秒
- (int)sea_second;

///获取当前时间的 分
- (int)sea_minute;

///获取当前时间的 小时
- (int)sea_hour;

///获取当前时间的 日期
- (int)sea_day;

///获取当前时间的 月份
- (int)sea_month;

///获取当前时间的 年份
- (int)sea_year;

///获取当前时间的 星期几字符串
- (NSString*)sea_weekdayString;

///获取当前时间的 星期几 1-7 星期日 到星期六
- (NSInteger)sea_weekday;

#pragma mark- 时间获取

/**通过日期获取星期
 */
+ (NSString*)sea_stringFromWeekDay:(NSInteger) weekday;

/**获取中文月份
 */
+ (NSString*)sea_stringFromMonth:(NSInteger) month;

/**获取当前时间格式为 YYYY-MM-dd HH:mm:ss
 *@return 当前时间
 */
+ (NSString*)sea_currentTime;

/**通过给的格式获取当前时间
 *@param format 时间格式， 如 YYYY-MM-dd HH:mm:ss
 *@return 当前时间
 */
+ (NSString*)sea_currentTimeWithFormat:(NSString*) format;

/**以当前时间为准，获取以后或以前的时间 时间格式为YYYY-MM-dd HH:mm:ss
 *@param timeInterval 时间间隔 大于0时，获取以后的时间,小于0时，获取以前的时间
 *@return 时间
 */
+ (NSString*)sea_timeWithTimeInterval:(NSTimeInterval) timeInterval;

/**以当前时间为准，获取以后或以前的时间
 *@param timeInterval 时间间隔 大于0时，获取以后的时间,小于0时，获取以前的时间
 *@param format 时间格式为，如YYYY-MM-dd HH:mm:ss
 *@return 时间
 */
+ (NSString*)sea_timeWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString*) format;

/**通过给定时间，获取以后或以前的时间
 *@param timeInterval 时间间隔 大于0时，获取以后的时间,小于0时，获取以前的时间
 *@param format 时间格式为，如YYYY-MM-dd HH:mm:ss
 *@param fromTime 以该时间为准
 *@return 时间
 */
+ (NSString*)sea_timeWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format fromTime:(NSString*) fromTime;

#pragma mark- 时间转换

/**把时间转换成其他形式 如 当天的不显示日期，08:00 同一个星期内的显示星期几
 *@param time 要格式化的时间
 *@Param format 时间格式 和 time对应， 如 YYYY-MM-dd HH:mm:ss
 *@return 格式化后的时间，或nil，如果时间格式和时间不对应
 */
+ (NSString*)sea_convertTime:(NSString*) time format:(NSString*) format;

/**转换时间成---秒，分 前 如1小时前
 *@param time 要转换的时间
 *@param format 时间格式 和 time对应， 如 YYYY-MM-dd HH:mm:ss
 *@return 转换后的时间，或nil，如果时间格式和时间不对应
 */
+ (NSString*)sea_convertTimeToAgo:(NSString*) time format:(NSString*) format;

/**转换时间成---秒，分 前 如1小时前
 *@param timeInterval 要转换的时间戳
 *@return 转换后的时间，或nil，如果时间格式和时间不对应
 */
+ (NSString*)sea_convertTimeIntervalToAgo:(NSTimeInterval) timeInterval;

/**时间格式转换 从@"YYYY-MM-dd HH:mm:ss" 转换成给定格式
 *@param time 要格式化的时间
 *@param format 要转换成的格式
 *@retrun 转换后的时间
 */
+ (NSString*)sea_formatTime:(NSString*) time format:(NSString*) format;

/**时间格式转换
 *@param time 要转换的时间
 *@param fromFormat 要转换的时间的格式
 *@param toFormat 要转换成的格式
 *@retrun 转换后的时间
 */
+ (NSString*)sea_formatTime:(NSString*) time fromFormat:(NSString*) fromFormat toFormat:(NSString*) toFormat;

/**通过时间戳获取具体时间
 *@param timeInterval 时间戳，是距离1970年到当前的秒
 *@param format 要返回的时间格式
 *@return 具体时间
 */
+ (NSString*)sea_formatTimeInterval:(NSString*) timeInterval format:(NSString*) format;

/**通过时间获取时间戳
 *@param time 时间
 *@param format 时间格式
 *@return 时间戳
 */
+ (NSTimeInterval)sea_timeIntervalFromTime:(NSString*) time format:(NSString*) format;

/**从时间字符串中获取date
 *@param time 时间字符串
 *@param format 时间格式
 *@return 时间date
 */
+ (NSDate*)sea_dateFromTime:(NSString*) time format:(NSString*) format;

/**从date获取时间字符串
 *@param date 时间
 *@param format 时间格式
 *@return 格式化的时间
 */
+ (NSString*)sea_timeFromDate:(NSDate*) date format:(NSString*) format;

#pragma mark- 时间比较

/**
 time - 当前时间 > timeInterval
 *@param time 要比较的时间
 *@param timeInterval 要大于的值
 */
+ (BOOL)sea_TimeMinusNow:(NSString*) time greaterThan:(NSTimeInterval) timeInterval;

/**
 time1 - time2 > timeInterval
 *@param time1 要比较的时间1
 *@param time2 要比较的时间2
 *@param timeInterval 要大于的值
 */
+ (BOOL)sea_TimeMinus:(NSString *) time1 time:(NSString*) time2 greaterThan:(NSTimeInterval) timeInterval;

/**比较两个时间是否相等
 */
+ (BOOL)sea_time:(NSString*) time1 equalToTime:(NSString*) time2;

#pragma mark- other

/**当前时间和随机数生成的字符串
 *@return 如 1989072407080998
 */
+ (NSString*)sea_random;

/**通过日期获取年龄
 *@param time 日期
 *@param format 时间格式
 *@return 年龄，如 16岁
 */
+ (NSString*)sea_ageFromTime:(NSString*) time format:(NSString*) format;

/**计算时间距离现在有多少秒
 */
+ (NSTimeInterval)sea_timeIntervalFromNow:(NSString*) time;

@end
