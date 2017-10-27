//
//  NSString+customString.m

//

#import "NSString+Utilities.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Utilities)

#pragma mark- 空判断

//判断字符串是否为空
+ (BOOL)isEmpty:(NSString *)str
{
    if([str isEqual:[NSNull null]])
    {
        return YES;
    }
    
    if(str == nil)
    {
        return YES;
    }
    
    if(str == NULL)
    {
        return YES;
    }
    
    if([str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        return YES;
    }

    if([str stringByReplacingOccurrencesOfString:@"\n" withString:@""].length == 0)
    {
        return YES;
    }

    if([str stringByReplacingOccurrencesOfString:@"\r" withString:@""].length == 0)
    {
        return YES;
    }

    return NO;
}

/**判断字符串是否为空,字符串可以为空格
 */
+ (BOOL)isNull:(NSString *)str
{
    if([str isEqual:[NSNull null]])
    {
        return YES;
    }
    
    if(str == nil)
    {
        return YES;
    }
    
    if(str == NULL)
    {
        return YES;
    }
    
    if(str.length == 0)
        return YES;
    
    return NO;
}

#pragma mark- encode

/**编码，使用 NSUTF8StringEncoding
 *@param str 要编码的字符串
 *@return 编码后的字符串
 */
+ (NSString*)encodeString:(NSString*) str
{
    return [NSString encodeString:str stringEncoding:NSUTF8StringEncoding];
}

/**编码
 *@param str 要编码的字符串
 *@param stringEncoding 编码方式
 *@return 编码后的字符串
 */
+ (NSString*)encodeString:(NSString*) str stringEncoding:(NSStringEncoding) stringEncoding
{
    if([str isKindOfClass:[NSString class]] && str.length > 0)
    {
        return [str encodeWithStringEncoding:stringEncoding];
    }
    
    return @"";
}

/**编码，使用 NSUTF8StringEncoding
 *@return 编码后的字符串
 */
- (NSString*)encodeWithUTF8
{
    return [self encodeWithStringEncoding:NSUTF8StringEncoding];
}

/**编码
 *@param stringEncoding 编码方式
 *@return 编码后的字符串
 */
- (NSString*)encodeWithStringEncoding:(NSStringEncoding) stringEncoding
{
    CFStringRef string = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(stringEncoding));
    
    NSString *result = nil;
    if(string != NULL)
    {
        result = [NSString stringWithFormat:@"%@", (__bridge NSString*)string];
        CFRelease(string);
    }
    else
    {
        result = @"";
    }
    return result;
}

#pragma mark- 获取

/**第一个字符
 */
- (char)sea_firstCharacter
{
    if(self.length > 0)
    {
        return [self characterAtIndex:0];
    }
    else
    {
        return 0;
    }
}

/**最后一个字符
 */
- (char)sea_lastCharacter
{
    if(self.length > 0)
    {
        return [self characterAtIndex:self.length - 1];
    }
    else
    {
        return 0;
    }
}

/**从后面的字符串开始，获取对应字符的下标
 *@return 如果没有，返回NSNotFound
 */
- (NSInteger)sea_lastIndexOfCharacter:(char) c
{
    NSInteger index = NSNotFound;
    for(NSInteger i = self.length - 1;i >= 0;i --)
    {
        char cha = [self characterAtIndex:i];
        if(cha == c)
        {
            index = i;
            break;
        }
    }
    
    return index;
}

/**获取字符串所占位置大小
 *@param font 字符串要显示的字体
 *@param width 每行最大宽度
 *@return 字符串大小
 */
- (CGSize)stringSizeWithFont:(UIFont*) font contraintWith:(CGFloat) width
{
    CGSize size;
    CGSize contraintSize = CGSizeMake(width, CGFLOAT_MAX);
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    size = [self boundingRectWithSize:contraintSize  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    
    return size;
}

///删除中文
- (NSString*)stringByRemoveChinese
{
    if(self.length == 0)
        return self;
    
    NSMutableString *string = [NSMutableString stringWithString:self];
    
    for(NSInteger i = 0;i < self.length;i ++)
    {
        unichar c = [self characterAtIndex:i];
        if(c > 0x4e00 && c < 0x9fff)
        {
            [string deleteCharactersInRange:NSMakeRange(i, 1)];
            i --;
        }
    }
    
    return string;
}

/**把中文字符成两个字符的字符串长度
 */
- (NSUInteger)lengthWithChineseAsTwoChar
{
    NSUInteger length = 0;
    for(NSUInteger i = 0;i < self.length;i ++)
    {
        unichar c = [self characterAtIndex:i];
        if(c > 0x4e00 && c < 0x9fff)
        {
            length += 2;
        }
        else
        {
            length ++;
        }
    }
    
    return length;
}

#pragma mark- 百度

//百度搜索链接
+ (NSString*)baiduURLForKey:(NSString *)key
{
    NSString *url = [NSString stringWithFormat:@"http://www.baidu.com/s?word=%@", key];
    url = [[self class] encodeString:url];
    return url;
}

#pragma mark- md5

- (NSString*)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark- 验证合法性

//判断手机号是否合法
- (BOOL)isMobileNumber
{
    if(self.length != 11)
    {
        return NO;
    }
    
    NSString *mobile = @"^1[3|4|5|7|8]\\d{9}$";
//    //手机号码
//    NSString *mobile = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
//    //中国移动
//    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    //中国联通
//    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    //中国电信
//    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    //小灵通
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    //设定断言
//    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
//    NSPredicate *regextestCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
//    NSPredicate *regextestCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
//    NSPredicate *regextestCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
//    
//    if(([regextestMobile evaluateWithObject:self] == YES) ||
//       ([regextestCM evaluateWithObject:self] == YES) ||
//       ([regextestCU evaluateWithObject:self] == YES) ||
//       ([regextestCT evaluateWithObject:self] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    if([regextestMobile evaluateWithObject:self] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//特殊字符验证
- (BOOL)isIncludeSpecialCharacter
{
    NSRange urgentRange = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

//验证邮政编码
- (BOOL)isZipCode
{
    if(self.length != 6)
    {
        return NO;
    }
    return YES;
}

//验证固定电话
- (BOOL)isTelPhoneNumber
{
    NSString *phoneRegex = @"\\d{3}-\\d{8}|\\d{4}-\\d{7,8}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
   
    if(![predicate evaluateWithObject:self])
    {
        return NO;
    }
    return YES;
}

//邮箱验证
- (BOOL)isEmail
{
    //邮箱正则表达式验证
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    
    if(![predicate evaluateWithObject:self])
    {
        return NO;
    }
    return YES;
}


//身份证
- (BOOL)isCardId
{
    if(self.length != 18)
    {
        return NO;
    }
    
    NSArray *codeArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSDictionary *checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil] forKeys:[NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[self substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum)
    {
        return NO;
    }
    int sumValue = 0;
    
    for (int i = 0; i < 17; i++)
    {
        sumValue += [[self substringWithRange:NSMakeRange(i , 1) ] intValue] * [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString *strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue % 11]];
    
    if ([strlast isEqualToString:[[self substringWithRange:NSMakeRange(17, 1)] uppercaseString]])
    {
        return YES;
    }
    return  NO;
}

//是否是网址
- (BOOL)isURL
{
    NSString *urlRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSString *str = [NSString encodeString:self];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRegex];
    
    if(![predicate evaluateWithObject:str])
    {
        urlRegex = @"\\b(https?)://(?:(\\S+?)(?::(\\S+?))?@)?([a-zA-Z0-9\\-.]+)(?::(\\d+))?((?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
        predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRegex];
        if(![predicate evaluateWithObject:str])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

/**是否是中文
 */
- (BOOL)isChinese
{
    NSString *regex18 = @"^[\u4e00-\u9fa5]$";
    
    NSPredicate *predicate18 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex18];
    
    if(![predicate18 evaluateWithObject:self])
    {
        return NO;
    }
    
    return YES;
}

/**判断是否是整数
 */
- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是不是纯数字
- (BOOL)isNumText
{
    if([self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

/**是否是纯字母
 */
- (BOOL)isLetterText
{
    NSString *regex18 = @"^[A-Za-z]+$";

    NSPredicate *predicate18 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex18];

    if(![predicate18 evaluateWithObject:self])
    {
        return NO;
    }

    return YES;
}

/**是否是字母和数字组合
 */
- (BOOL)isLetterAndNumberText
{
    NSString *regex18 = @"^[A-Za-z0-9]+$";

    NSPredicate *predicate18 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex18];

    if(![predicate18 evaluateWithObject:self])
    {
        return NO;
    }

    return YES;
}

/**是否是银行卡
 */
- (BOOL)isBankCard
{
    if(self.length == 0)
        return false;
    if(![self isNumText])
        return false;
    
    BOOL match = NO;
    // unionpay electron maestro dankort interpayment visa mastercard amex diners discover jcb
    NSArray *formats = [NSArray arrayWithObjects:
                        @"^(62|88)\\d+$",
                        @"^(4026|417500|4405|4508|4844|4913|4917)\\d+$",
                        @"^(5018|5020|5038|5612|5893|6304|6759|6761|6762|6763|0604|6390)\\d+$",
                        @"^(5019)\\d+$",
                        @"^(636)\\d+$",
                        @"^4[0-9]{12}(?:[0-9]{3})?$",
                        @"^5[1-5][0-9]{14}$",
                        @"^3[47][0-9]{13}$",
                        @"^3(?:0[0-5]|[68][0-9])[0-9]{11}$",
                        @"^6(?:011|5[0-9]{2})[0-9]{12}$",
                        @"^(?:2131|1800|35\\d{3})\\d{11}$", nil];

    for(NSString *format in formats)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
        if([predicate evaluateWithObject:self])
        {
            match = YES;
            break;
        }
    }
    
    return match;
}

#pragma mark- 格式化

///固定电话格式化
- (NSString*)formatTelPhoneNumber
{
    NSString *number = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];;
    if(number.length >= 4)
    {
        if(number.length > 30)
        {
            number = [number stringByReplacingCharactersInRange:NSMakeRange(30, number.length - 30) withString:@""];
        }
        
        NSInteger codeIndex = 0;
        ///区号3位
        if([number hasPrefix:@"02"] || [number hasPrefix:@"01"] || [number hasPrefix:@"85"])
        {
            codeIndex = 3;
        }
        else if(number.length > 4)
        {
            ///区号四位
            codeIndex = 4;
        }
        
        if(codeIndex != 0)
        {
            number = [number stringByReplacingCharactersInRange:NSMakeRange(codeIndex, 0) withString:@"-"];
        }
    }
    
    return number;
}


@end


@implementation NSMutableString (customMutableString)

/**移除最后一个字符
 */
- (void)removeLastCharacter
{
    if(self.length == 0)
        return;
    [self deleteCharactersInRange:NSMakeRange(self.length - 1, 1)];
}

- (void)removeLastStringWithString:(NSString*) str
{
    if(self.length < str.length)
        return;
    [self deleteCharactersInRange:NSMakeRange(self.length - str.length, str.length)];
}

@end
