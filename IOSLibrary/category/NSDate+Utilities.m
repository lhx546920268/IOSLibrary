//
//  NSDate+timeIntreval.m

//

#import "NSDate+Utilities.h"
#import "SeaBasic.h"

#define _hourPerDay_ 24
#define _dayPerMonth_ 30
#define _dayPerYear_ 365
#define _timerInterval_ 60

#define _secondsPerYear_ 60 * 60 * 24 * 365

@implementation NSDate (Utilities)

#pragma mark- 单例

/**NSDateFormatter 的单例 因为频繁地创建 NSDateFormatter 是非常耗资源的、耗时的
 */
+ (NSDateFormatter*)sharedDateFormatter
{
    static dispatch_once_t once = 0;
    static NSDateFormatter *dateFormatter = nil;
    dispatch_once(&once, ^(void){

        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:BeiJingTimeZone]];
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

- (NSString*)sea_weekDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    
    NSInteger weekDay = components.weekday;
    
    switch (weekDay)
    {
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

#pragma mark- 时间获取

/**通过给定 timeInterval 返回一个距离当前时间的 时间组合
 */
+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags =
    kCFCalendarUnitSecond | kCFCalendarUnitMinute | kCFCalendarUnitHour |
    kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    
    
    return components;
}

/**通过给定时间 返回一个距离当前时间长度的字符串, 01:02:28
 */
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    
    //%02d 分 、秒不够两列补0
    if (components.hour > 0)
    {
        return [NSString stringWithFormat:@"%d:%02d:%02d", (int)components.hour, (int)components.minute, (int)components.second];
    }
    
    else
    {
        return [NSString stringWithFormat:@"%d:%02d", (int)components.minute, (int)components.second];
    }
}

//同过小时获取上下午
+ (NSString*)getDetailTimeFromHour:(NSString*)hourStr
{
    NSString *retStr = nil;
    int hour = [hourStr intValue];
    if(hour >= 0 && hour <= 6)
    {
        retStr = @"凌晨";
    }
    else if(hour > 6 && hour < 12)
    {
        retStr = @"上午";
    }
    else if(hour >= 12 && hour < 19)
    {
        retStr = @"下午";
    }
    else
    {
        retStr = @"晚上";
    }
    
    return retStr;
}

//通过日期获取星期
+ (NSString*)getWeekday:(NSInteger) weekday
{
    NSString *retStr = nil;
    switch (weekday) {
        case 1 :
            retStr = @"星期天";
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
            break;
    }
    return retStr;
}

//获取中文月份
+ (NSString*)getChineseMonthFormNum:(NSInteger) num
{
    NSString *month = nil;
    switch (num)
    {
        case 1 :
            month = @"一月";
            break;
        case 2 :
            month = @"二月";
            break;
        case 3 :
            month = @"三月";
            break;
        case 4 :
            month = @"四月";
            break;
        case 5 :
            month = @"五月";
            break;
        case 6 :
            month = @"六月";
            break;
        case 7 :
            month = @"七月";
            break;
        case 8 :
            month = @"八月";
            break;
        case 9 :
            month = @"九月";
            break;
        case 10 :
            month = @"十月";
            break;
        case 11 :
            month = @"十一月";
            break;
        case 12 :
            month = @"十二月";
            break;
        default:
            break;
    }
    return month;
}

/**获取当前时间格式为 YYYY-MM-dd HH:mm:ss
 *@return 当前时间
 */
+ (NSString*)getCurrentTime
{
    return [NSDate getCurrentTimeWithFormat:DateFormatYMdHms];
}

/**通过给的格式获取当前时间
 *@param format 时间格式， 如 YYYY-MM-dd HH:mm:ss
 *@return 当前时间
 */
+ (NSString*)getCurrentTimeWithFormat:(NSString*) format
{
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    [dateFormatter setDateFormat:format];
    
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    
    return time;
}

/**以当前时间为准，获取以后或以前的时间 时间格式为YYYY-MM-dd HH:mm:ss
 *@param timeInterval 时间间隔 大于0时，获取以后的时间,小于0时，获取以前的时间
 *@return 时间
 */
+ (NSString*)getTimeWithTimeInterval:(NSTimeInterval)timeInterval
{
    return [NSDate getTimeWithTimeInterval:timeInterval format:DateFormatYMdHms];
}

/**以当前时间为准，获取以后或以前的时间
 *@param timeInterval 时间间隔 大于0时，获取以后的时间,小于0时，获取以前的时间
 *@param format 时间格式为，如YYYY-MM-dd HH:mm:ss
 *@return 时间
 */
+ (NSString*)getTimeWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString*) format
{
    return [NSDate getTimeWithTimeInterval:timeInterval format:format time:nil];
}

/**通过给定时间，获取以后或以前的时间
 *@param timeInterval 时间间隔 大于0时，获取以后的时间,小于0时，获取以前的时间
 *@param format 时间格式为，如YYYY-MM-dd HH:mm:ss
 *@param time 时间基准
 *@return 时间
 */
+ (NSString*)getTimeWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format time:(NSString*) time
{
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    [dateFormatter setDateFormat:format];
    
    NSDate *oldDate = time == nil ? [NSDate date] : [dateFormatter dateFromString:time];
    
    NSDate *date = [NSDate dateWithTimeInterval:timeInterval sinceDate:oldDate];
    
    return [dateFormatter stringFromDate:date];
}


#pragma mark- 时间转换

/**把时间转换成其他形式 如 当天的不显示日期，08:00 同一个星期内的显示星期几
 *@param datetime 要格式化的时间
 *@Param formatString 时间格式 和 dateTime对应， 如 YYYY-MM-dd HH:mm:ss
 */
+ (NSString*)datetime:(NSString *)datetime formatString:(NSString *)formatString
{
    NSString *retStr = nil;
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:formatString];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/BeiJing"]];
    
    NSDate *date = [formatter dateFromString:datetime];
    if(date == nil)
        return nil;
    
    NSString *currentDateTime = [formatter stringFromDate:[NSDate date]];
    
    NSUInteger location = 5;
    NSUInteger lenth = 2;
    
    //月
    NSString *currentMonth = [currentDateTime substringWithRange:NSMakeRange(location, lenth)];
    NSString *oldMonth = [datetime substringWithRange:NSMakeRange(location, lenth)];
    //日
    location += lenth + 1;
    NSString *currentDate = [currentDateTime substringWithRange:NSMakeRange(location, lenth)];
    NSString *oldDate = [datetime substringWithRange:NSMakeRange(location, lenth)];
    //小时
    location += lenth + 1;
    NSString *oldHour = [datetime substringWithRange:NSMakeRange(location, lenth)];
    //分
    location += lenth + 1;
    NSString *oldMinutes = [datetime substringWithRange:NSMakeRange(location, lenth)];
    
    //上午还是下午
    NSString *str = [self getDetailTimeFromHour:oldHour];
    //同月
    if([currentMonth isEqualToString:oldMonth])
    {
        //同一天
        if([currentDate isEqualToString:oldDate])
        {
            retStr = [NSString stringWithFormat:@"%@ %@:%@",str,oldHour,oldMinutes];
        }
        else if([currentDate intValue] - [oldDate intValue] <= 2)
        {
            //七天内
            int ret = [currentDate intValue] - [oldDate intValue];
            if(ret == 1)
            {
                retStr = [NSString stringWithFormat:@"昨天 %@ %@:%@",str, oldHour, oldMinutes];
            }
            else
            {
                retStr = [NSString stringWithFormat:@"前天 %@ %@:%@",str, oldHour, oldMinutes];
            }
        }
        else
        {
            retStr = [NSString stringWithFormat:@"%@-%@ %@ %@:%@",oldMonth, oldDate, str, oldHour, oldMinutes];
        }
    }
    else
    {
        retStr = [NSString stringWithFormat:@"%@-%@ %@ %@:%@",oldMonth, oldDate, str, oldHour, oldMinutes];
    }
   
    return retStr;
}

/**转换时间成---秒，分 前 如1小时前
 *@param time 要转换的时间
 *@param formatString 时间格式 和 dateTime对应， 如 YYYY-MM-dd HH:mm:ss
 *@return 转换后的时间，或nil，如果时间格式和时间不对应
 */
+ (NSString*)previousDateWithTime:(NSString*) time formatString:(NSString*) formatString
{
    //  NSLog(@"%@",dateTime);
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:formatString];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/BeiJing"]];
    
    NSDate *oldDate = [formatter dateFromString:time];
    return [NSDate previousDateWithTimeInterval:[oldDate timeIntervalSince1970]];
}

/**转换时间成---秒，分 前 如1小时前
 *@param timeInterval 要转换的时间戳
 *@return 转换后的时间，或nil，如果时间格式和时间不对应
 */
+ (NSString*)previousDateWithTimeInterval:(NSTimeInterval) timeInterval
{
    NSDate *currentDate = [NSDate date];

    long interval = [currentDate timeIntervalSince1970] - timeInterval;
    if(interval < 0)
        interval = - interval;

    if(interval < _timerInterval_)
    {
        return @"刚刚";///[NSString stringWithFormat:@"%ld秒前", interval];
    }

    interval = interval / _timerInterval_;
    if(interval < _timerInterval_)
    {
        return [NSString stringWithFormat:@"%ld分钟前", interval];
    }

    interval = interval / _timerInterval_;
    if(interval < _hourPerDay_)
    {
        return [NSString stringWithFormat:@"%ld小时前", interval];
    }

    interval = interval / _hourPerDay_;

    if(interval < _dayPerMonth_)
    {
        return [NSString stringWithFormat:@"%ld天前", interval];
    }
    
    interval = interval / _dayPerMonth_;
    
    if(interval < 12)
    {
        return [NSString stringWithFormat:@"%ld月前", interval];
    }
    
    long year = interval / 12;
    //long day = interval % _dayPerYear_;

    return [NSString stringWithFormat:@"%ld年前", year];
}

/**通过给定秒数 返回 秒，分 前 如1小时前，富文本
 */
+ (NSMutableAttributedString*)previousAttributedDateWithIntrval:(long long) interval
{
    if(interval < 0)
        interval = - interval;
    
    UIFont *numberFont = [UIFont fontWithName:SeaMainNumberFontName size:14.0];
    UIFont *stringFont = [UIFont fontWithName:SeaMainFontName size:14.0];
    UIColor *textColor = [UIColor grayColor];
    
    NSMutableAttributedString *text = nil;
    NSString *number = nil;
    
    if(interval < _timerInterval_)
    {
        number = [NSString stringWithFormat:@"%lld", interval];
        text = [[NSMutableAttributedString alloc] initWithString:[number stringByAppendingString:@"秒前"]];
        [text addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:stringFont range:NSMakeRange(number.length, text.length - number.length)];
        [text addAttribute:NSFontAttributeName value:numberFont range:NSMakeRange(0, number.length)];
        
        return text;
    }
    
    interval = interval / _timerInterval_;
    if(interval < _timerInterval_)
    {
        number = [NSString stringWithFormat:@"%lld", interval];
        text = [[NSMutableAttributedString alloc] initWithString:[number stringByAppendingString:@"分前"]];
        [text addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:stringFont range:NSMakeRange(number.length, text.length - number.length)];
        [text addAttribute:NSFontAttributeName value:numberFont range:NSMakeRange(0, number.length)];
        
        return text;
    }
    
    interval = interval / _timerInterval_;
    if(interval < _hourPerDay_)
    {
        number = [NSString stringWithFormat:@"%lld", interval];
        text = [[NSMutableAttributedString alloc] initWithString:[number stringByAppendingString:@"小时前"]];
        [text addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:stringFont range:NSMakeRange(number.length, text.length - number.length)];
        [text addAttribute:NSFontAttributeName value:numberFont range:NSMakeRange(0, number.length)];
        
        return text;
    }
    
    interval = interval / _hourPerDay_;
    
    if(interval < _dayPerYear_)
    {
        number = [NSString stringWithFormat:@"%lld", interval];
        text = [[NSMutableAttributedString alloc] initWithString:[number stringByAppendingString:@"天前"]];
        [text addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:stringFont range:NSMakeRange(number.length, text.length - number.length)];
        [text addAttribute:NSFontAttributeName value:numberFont range:NSMakeRange(0, number.length)];
        
        return text;
    }
    
    long long year = interval / _dayPerYear_;
    long long day = interval % _dayPerYear_;
    
    NSString *yearString = [NSString stringWithFormat:@"%lld", year];
    NSString *dayString = [NSString stringWithFormat:@"%lld", day];
    
    
    text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@年零%@天前", yearString, dayString] attributes:[NSDictionary dictionaryWithObjectsAndKeys:NSForegroundColorAttributeName, textColor, NSFontAttributeName, stringFont, nil]];
    
    [text addAttribute:NSFontAttributeName value:numberFont range:NSMakeRange(0, yearString.length)];
    [text addAttribute:NSFontAttributeName value:numberFont range:[dayString rangeOfString:text.string]];
    
    return text;
}

/**时间格式转换 从@"YYYY-MM-dd HH:mm:ss" 转换成给定格式
 *@param format 要转换成的格式
 *@retrun 转换后的时间
 */
+ (NSString*)formatDate:(NSString*) time format:(NSString*) format
{
    return [NSDate formatDate:time fromFormat:DateFormatYMdHms toFormat:format];
}

/**时间格式转换
 *@param time 要转换的时间
 *@param fromFormat 要转换的时间的格式
 *@param toFormat 要转换成的格式
 *@retrun 转换后的时间
 */
+ (NSString*)formatDate:(NSString*) time fromFormat:(NSString*) fromFormat toFormat:(NSString*) toFormat
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:fromFormat];

    NSDate *date = [formatter dateFromString:time];
    
    [formatter setDateFormat:toFormat];
    NSString *timeStr = [formatter stringFromDate:date];
    
    return timeStr;
}

/**从时间字符串中获取date
 *@param time 时间字符串
 *@param format 时间格式
 *@return 时间date
 */
+ (NSDate*)dateFromString:(NSString*) time format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:time];
    return date;
}

/**从date获取时间字符串
 */
+ (NSString*)timeFromDate:(NSDate*) date format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

#pragma mark- 时间比较

/**判断给定时间距离当前时间是否超过这个时间段
 *@param time 要比较的时间
 *@param timeInterval 时间约束
 */
+ (BOOL)compareTime:(NSString*) time beyondTimeIntervalFromNow:(NSTimeInterval) timeInterval
{
    return [NSDate compareTime:[NSDate getCurrentTime] andTime:time beyondTimeInterval:timeInterval];
}

/**判断两个时间的间隔是否超过这个时间段
 *@param time1 要比较的时间1
 *@param time2 要比较的时间2
 *@param timeInterval 时间约束
 */
+ (BOOL)compareTime:(NSString *)time1 andTime:(NSString*) time2 beyondTimeInterval:(NSTimeInterval)timeInterval
{
    if([NSString isEmpty:time1])
    {
        return YES;
    }
    
    if([NSString isEmpty:time2])
    {
        return YES;
    }
    
    
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    [dateFormatter setDateFormat:DateFormatYMdHms];
    
    NSDate *date1 = [dateFormatter dateFromString:time1];
    NSDate *date2 = [dateFormatter dateFromString:time2];
    
    NSTimeInterval interval = [date1 timeIntervalSinceDate:date2];
    
    if(interval >= timeInterval)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**比较两个时间是否相等
 */
+ (BOOL)isTime:(NSString*) time1 equalTime:(NSString*) time2
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:DateFormatYMdHms];
    
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    
    return [date1 isEqualToDate:date2];
}

#pragma mark- 时间格式化

/**把时间转换成 几年 几天 几个小时 几分 几秒
 *@return key 为年y，天d，小时h，分m，秒s value double
 */
+ (NSDictionary*)formatTimeInterval:(long long) interval
{
    NSString *second = nil;
    NSString *minute = nil;
    NSString *hour = nil;
    
    NSString *day = nil;
    NSString *year = nil;
    
    if(interval >= 60)
    {
        second = [NSString stringWithFormat:@"%lld", interval % 60];
        
        interval /= 60;
        
        if(interval >= 60)
        {
            minute = [NSString stringWithFormat:@"%lld", interval % 60];
            
            interval /= 60;
            
            if(interval >= 24)
            {
                hour = [NSString stringWithFormat:@"%lld", interval % 24];
                interval /= 24;
                
                if(interval >= 365)
                {
                    day = [NSString stringWithFormat:@"%lld", interval % 24];
                    year = [NSString stringWithFormat:@"%lld", interval / 365];
                }
                else
                {
                    day = [NSString stringWithFormat:@"%lld", interval];
                }
            }
            else
            {
                hour = [NSString stringWithFormat:@"%lld", interval];
            }
        }
        else
        {
            minute = [NSString stringWithFormat:@"%lld", interval];
        }
    }
    else
    {
        second = [NSString stringWithFormat:@"%lld", interval];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if(second)
    {
        [dic setObject:second forKey:@"s"];
    }
    
    if(minute)
    {
        [dic setObject:minute forKey:@"m"];
    }
    
    if(hour)
    {
        [dic setObject:hour forKey:@"h"];
    }
    
    if(day)
    {
        [dic setObject:day forKey:@"d"];
    }
    
    if(year)
    {
        [dic setObject:year forKey:@"y"];
    }
    
    return dic;
}

#pragma mark- other

/**当前时间和随机数生成的字符串
 *@return 如 1989072407080998
 */
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

/**通过出生日期获取年龄
 *@param date 出生日期
 *@param format 时间格式
 *@return 年龄，如 16岁
 */
+ (NSString*)ageFromBirthDate:(NSString*) date format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    
    NSDate *oldDate = [formatter dateFromString:date];
    
    NSTimeInterval timeInterval = -[oldDate timeIntervalSinceNow];
    
    if(timeInterval < 0)
        timeInterval = 0;
    
    int year = 365 * 24 * 60 * 60;
    
    int age = timeInterval / year;
    
    return [NSString stringWithFormat:@"%d岁", age];
}


/**计算时间距离现在有多少秒
 */
+ (NSTimeInterval)timeIntervalFromNowWithDate:(NSString*) date
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:DateFormatYMdHms];
    
    NSDate *oldDate = [formatter dateFromString:date];
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:oldDate];
 
    return interval;
}

/**通过时间戳获取具体时间
 *@param time 时间戳，是距离1970年到当前的秒
 *@param format 要返回的时间格式
 *@return 具体时间
 */
+ (NSString*)formatTimeInterval:(NSString*) time format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    
    NSString *result = [formatter stringFromDate:date];
    
    return result;
}

/**通过时间获取时间戳
 *@param time 时间
 *@param format 时间格式
 *@return 时间戳
 */
+ (NSTimeInterval)timeIntervalFromTime:(NSString*) time format:(NSString*) format
{
    NSDateFormatter *formatter = [NSDate sharedDateFormatter];
    [formatter setDateFormat:format];
    
    NSDate *date = [formatter dateFromString:time];
    return [date timeIntervalSince1970];
}


@end
