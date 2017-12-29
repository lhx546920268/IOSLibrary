//
//  NSDate+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/27.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "NSDate+Utils.h"
#import "NSString+Utilities.h"

static const int SeaHourPerDay = 24;
static const int SeaDayPerMonth = 30;
static const int SeaDayPerYear = 365;
static const int SeaSecondPerMinutes = 60;
static const int SeaMinutesPerHour = 60;
static const int SeaSecondsPerYear = 60 * 60 * 24 * 365;

@implementation NSDate (Utils)

#pragma mark- 单例

+ (NSDateFormatter*)sharedDateFormatter
{
    static dispatch_once_t once = 0;
    static NSDateFormatter *dateFormatter = nil;
    dispatch_once(&once, ^(void){
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:SeaTimeZoneBeiJing]];
    });
    
    return dateFormatter;
}

#pragma mark- 单个时间

- (int)sea_day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return (int)components.day;
}

- (int)sea_month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    return (int)components.month;
}

- (int)sea_year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    return (int)components.year;
}

- (NSString*)sea_weekdayString
{
    NSInteger weekDay = [self sea_weekday];
    
    switch (weekDay){
        case 1 :
            return @"星期日";
            break;
        case 2 :
            return @"星期一";
            break;
        case 3 :
            return @"星期二";
            break;
        case 4 :
            return @"星期三";
            break;
        case 5 :
            return @"星期四";
            break;
        case 6 :
            return @"星期五";
            break;
        case 7 :
            return @"星期六";
            break;
        default :
            return @"星期日";
            break;
    }
}

- (NSInteger)sea_weekday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    
    return components.weekday;
}

#pragma mark- 时间获取

/**
 获取时间段
 */
+ (NSString*)periodOfTimeFromHour:(NSInteger) hour
{
    NSString *str = nil;
    if(hour >= 0 && hour <= 6){
        str = @"凌晨";
    }else if(hour > 6 && hour < 12){
        str = @"上午";
    }else if(hour >= 12 && hour < 19){
        str = @"下午";
    }else{
        str = @"晚上";
    }
    
    return str;
}

+ (NSString*)sea_stringFromWeekDay:(NSInteger) weekday
{
    NSString *retStr = nil;
    switch (weekday) {
        case 1 :
            retStr = @"星期日";
            break;
        case 2 :
            retStr = @"星期一";
            break;
        case 3 :
            retStr = @"星期二";
            break;
        case 4 :
            retStr = @"星期三";
            break;
        case 5 :
            retStr = @"星期四";
            break;
        case 6 :
            retStr = @"星期五";
            break;
        case 7 :
            retStr = @"星期六";
            break;
        default:
            retStr = @"星期日";
            break;
    }
    return retStr;
}

+ (NSString*)sea_stringFromMonth:(NSInteger) month
{
    NSString *result = nil;
    switch (month){
        case 1 :
            result = @"一月";
            break;
        case 2 :
            result = @"二月";
            break;
        case 3 :
            result = @"三月";
            break;
        case 4 :
            result = @"四月";
            break;
        case 5 :
            result = @"五月";
            break;
        case 6 :
            result = @"六月";
            break;
        case 7 :
            result = @"七月";
            break;
        case 8 :
            result = @"八月";
            break;
        case 9 :
            result = @"九月";
            break;
        case 10 :
            result = @"十月";
            break;
        case 11 :
            result = @"十一月";
            break;
        case 12 :
            result = @"十二月";
            break;
        default:
            break;
    }
    return result;
}

+ (NSString*)sea_currentTime
{
    return [NSDate sea_currentTimeWithFormat:SeaDateFormatYMdHms];
}

+ (NSString*)sea_currentTimeWithFormat:(NSString*) format
{
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    [dateFormatter setDateFormat:format];
    
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    
    return time;
}

+ (NSString*)sea_timeWithTimeInterval:(NSTimeInterval)timeInterval
{
    return [NSDate sea_timeWithTimeInterval:timeInterval format:SeaDateFormatYMdHms];
}

+ (NSString*)sea_timeWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString*) format
{
    return [NSDate sea_timeWithTimeInterval:timeInterval format:format fromTime:nil];
}

+ (NSString*)sea_timeWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format fromTime:(NSString*) fromTime
{
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    [dateFormatter setDateFormat:format];
    
    NSDate *oldDate = fromTime == nil ? [NSDate date] : [dateFormatter dateFromString:fromTime];
    
    NSDate *date = [NSDate dateWithTimeInterval:timeInterval sinceDate:oldDate];
    
    return [dateFormatter stringFromDate:date];
}


#pragma mark- 时间转换

+ (NSString*)sea_convertTime:(NSString *) time format:(NSString *) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:SeaTimeZoneBeiJing]];
    
    NSDate *date = [formatter dateFromString:time];
    if(date == nil)
        return nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *components1 = [calendar components:unit fromDate:date];
    NSDateComponents *components2 = [calendar components:unit fromDate:[NSDate date]];
    
    //年
    int year1 = (int)components1.year;
    int year2 = (int)components2.year;
    
    //月
    int month1 = (int)components1.month;
    int month2 = (int)components2.month;
    
    //日
    int day1 = (int)components1.day;
    int day2 = (int)components2.day;
    
    //小时
    int hour1 = (int)components1.hour;
    int hour2 = (int)components2.hour;
    
    //分
    int minutes1 = (int)components1.minute;
//    int minutes2 = (int)components2.minute;
    
    
    NSString *result = nil;
    //同年
    if(year1 == year2){
        //同月
        if(month1 == month2){
            //同一天
            if(day1 == day2){
                result = [NSString stringWithFormat:@"%@ %d:%d", [self periodOfTimeFromHour:hour1], hour1, hour2];
            }else if(hour2 - hour1 <= 2){
                //2天内
                int ret = hour2 - hour1;
                if(ret == 1){
                    result = [NSString stringWithFormat:@"昨天 %@ %02d:%02d", [self periodOfTimeFromHour:hour1], hour1, minutes1];
                }else{
                    result = [NSString stringWithFormat:@"前天 %@ %02d:%02d", [self periodOfTimeFromHour:hour1], hour1, minutes1];
                }
            }else{
                result = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", minutes1, day1, hour1, minutes1];
            }
        }else{
            result = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", minutes1, day1, hour1, minutes1];
        }
    }else{
        result = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", year1, minutes1, day1, hour1, minutes1];
    }
    
    return result;
}

+ (NSString*)sea_convertTimeToAgo:(NSString*) time format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:SeaTimeZoneBeiJing]];
    
    return [NSDate sea_convertTimeIntervalToAgo:[[formatter dateFromString:time] timeIntervalSince1970]];
}

+ (NSString*)sea_convertTimeIntervalToAgo:(NSTimeInterval) timeInterval
{
    NSDate *currentDate = [NSDate date];
    
    long interval = [currentDate timeIntervalSince1970] - timeInterval;
    if(interval < 0)
        interval = - interval;
    
    if(interval < SeaSecondPerMinutes){
        return @"刚刚";
    }
    
    //小于1小时
    interval = interval / SeaSecondPerMinutes;
    if(interval < SeaMinutesPerHour){
        return [NSString stringWithFormat:@"%ld分钟前", interval];
    }
    
    //小于一天
    interval = interval / SeaMinutesPerHour;;
    if(interval < SeaHourPerDay){
        return [NSString stringWithFormat:@"%ld小时前", interval];
    }
    
    //小于一个月
    interval = interval / SeaHourPerDay;
    if(interval < SeaDayPerMonth){
        return [NSString stringWithFormat:@"%ld天前", interval];
    }
    
    //小于一年
    interval = interval / SeaDayPerMonth;
    if(interval < 12){
        return [NSString stringWithFormat:@"%ld月前", interval];
    }
    
    long year = interval / 12;
    return [NSString stringWithFormat:@"%ld年前", year];
}

+ (NSString*)sea_formatTime:(NSString*) time format:(NSString*) format
{
    return [NSDate sea_formatTime:time fromFormat:SeaDateFormatYMdHms toFormat:format];
}

+ (NSString*)sea_formatTime:(NSString*) time fromFormat:(NSString*) fromFormat toFormat:(NSString*) toFormat
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:fromFormat];
    
    NSDate *date = [formatter dateFromString:time];
    
    [formatter setDateFormat:toFormat];
    NSString *timeStr = [formatter stringFromDate:date];
    
    return timeStr;
}

+ (NSString*)sea_formatTimeInterval:(NSString*) timeInterval format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]];
    
    return [formatter stringFromDate:date];
}

+ (NSTimeInterval)sea_timeIntervalFromTime:(NSString*) time format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    
    NSDate *date = [formatter dateFromString:time];
    return [date timeIntervalSince1970];
}

+ (NSDate*)sea_dateFromTime:(NSString*) time format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:time];
    return date;
}

+ (NSString*)sea_timeFromDate:(NSDate*) date format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

#pragma mark- 时间比较

+ (BOOL)sea_TimeMinusNow:(NSString*) time greaterThan:(NSTimeInterval) timeInterval
{
    return [NSDate sea_TimeMinus:time time:[NSDate sea_currentTime] greaterThan:timeInterval];
}

+ (BOOL)sea_TimeMinus:(NSString *)time1 time:(NSString*) time2 greaterThan:(NSTimeInterval)timeInterval
{
    if([NSString isEmpty:time1]){
        return YES;
    }
    
    if([NSString isEmpty:time2]){
        return YES;
    }
    
    
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    [dateFormatter setDateFormat:SeaDateFormatYMdHms];
    
    NSDate *date1 = [dateFormatter dateFromString:time1];
    NSDate *date2 = [dateFormatter dateFromString:time2];
    
    return [date1 timeIntervalSinceDate:date2] > timeInterval;
}

+ (BOOL)sea_time:(NSString*) time1 equalToTime:(NSString*) time2
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:SeaDateFormatYMdHms];
    
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    
    return [date1 isEqualToDate:date2];
}

#pragma mark- other

+ (NSString*)getTimeAndRandom
{
    int iRandom = arc4random() % 1000000;
    if (iRandom < 0) {
        iRandom = -iRandom;
    }
    
    NSDateFormatter *tFormat = [NSDate sharedDateFormatter];
    [tFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *tResult = [NSString stringWithFormat:@"%@%d",[tFormat stringFromDate:[NSDate date]],iRandom];
    return tResult;
}

+ (NSString*)sea_ageFromTime:(NSString*) time format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    
    NSDate *oldDate = [formatter dateFromString:time];
    
    NSTimeInterval timeInterval = -[oldDate timeIntervalSinceNow];
    
    if(timeInterval < 0)
        timeInterval = 0;
    
    int year = 365 * 24 * 60 * 60;
    
    int age = timeInterval / year;
    
    return [NSString stringWithFormat:@"%d岁", age];
}

+ (NSTimeInterval)sea_timeIntervalFromNow:(NSString*) time
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:SeaDateFormatYMdHms];
    
    NSDate *date = [formatter dateFromString:time];
    return [date timeIntervalSinceNow];
}

@end
