//
//  NSString+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/29.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "NSString+Utils.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Utils)

+ (BOOL)isEmpty:(NSString *)str
{
    if([str isEqual:[NSNull null]] || str == nil || str == NULL){
        return YES;
    }
    
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length == 0){
        return YES;
    }
    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if(str.length == 0){
        return YES;
    }
    
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    if(str.length == 0){
        return YES;
    }
    
    return NO;
}

+ (BOOL)isNull:(NSString *)str
{
    if([str isEqual:[NSNull null]] || str == nil || str == NULL){
        return YES;
    }
    
    if(str.length == 0)
        return YES;
    
    return NO;
}

#pragma mark- encode

+ (NSString*)sea_encodeStringWithUTF8:(NSString*) str
{
    return [NSString sea_encodeString:str stringEncoding:NSUTF8StringEncoding];
}

+ (NSString*)sea_encodeString:(NSString*) str stringEncoding:(NSStringEncoding) stringEncoding
{
    if([str isKindOfClass:[NSString class]] && str.length > 0){
        return [str sea_encodeWithStringEncoding:stringEncoding];
    }
    
    return @"";
}

- (NSString*)sea_encodeWithUTF8
{
    return [self sea_encodeWithStringEncoding:NSUTF8StringEncoding];
}

- (NSString*)sea_encodeWithStringEncoding:(NSStringEncoding) stringEncoding
{
    CFStringRef string = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(stringEncoding));
    
    NSString *result = nil;
    if(string != NULL){
        result = [NSString stringWithFormat:@"%@", (__bridge NSString*)string];
        CFRelease(string);
    }else{
        result = @"";
    }
    return result;
}

- (NSString*)sea_decodeWithUTF8
{
    CFStringRef string = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    NSString *result = nil;
    if(string != NULL){
        result = [NSString stringWithFormat:@"%@", (__bridge NSString*)string];
        CFRelease(string);
    }else{
        result = @"";
    }
    return result;
}

+ (NSString *)sea_decodedStringWithUTF8:(NSString *)str
{
    return [str sea_decodeWithUTF8];
}

#pragma mark- 获取

- (char)sea_firstCharacter
{
    if(self.length > 0){
        return [self characterAtIndex:0];
    }else{
        return 0;
    }
}

- (char)sea_lastCharacter
{
    if(self.length > 0){
        return [self characterAtIndex:self.length - 1];
    }else{
        return 0;
    }
}

- (NSInteger)sea_lastIndexOfCharacter:(char) c
{
    NSInteger index = NSNotFound;
    for(NSInteger i = self.length - 1;i >= 0;i --){
        char cha = [self characterAtIndex:i];
        if(cha == c){
            index = i;
            break;
        }
    }
    
    return index;
}

- (CGSize)sea_stringSizeWithFont:(UIFont *)font
{
    return [self sea_stringSizeWithFont:font contraintWith:CGFLOAT_MAX];
}

- (CGSize)sea_stringSizeWithFont:(UIFont*) font contraintWith:(CGFloat) width
{
    CGSize size;
    CGSize contraintSize = CGSizeMake(width, CGFLOAT_MAX);
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    size = [self boundingRectWithSize:contraintSize  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    
    return size;
}

- (NSString*)sea_stringByFilterWithType:(SeaTextType)type
{
    return [self sea_stringByFilterWithType:type range:NSMakeRange(0, self.length)];
}

- (NSString*)sea_stringByFilterWithType:(SeaTextType) type range:(NSRange) range
{
    if(type & SeaTextTypeAll)
        return self;
    
    NSMutableString *regex = [NSMutableString stringWithString:@"[^"];
    
    if(type == SeaTextTypeDecimal){
        [regex appendString:@"0-9\\."];
    }else{
        if(type & SeaTextTypeDigital){
            [regex appendString:@"0-9"];
        }
        
        if(type & SeaTextTypeChinese){
            [regex appendString:@"\u4e00-\u9fa5"];
        }
        
        if(type & SeaTextTypeAlphabet){
            [regex appendString:@"a-zA-Z"];
        }
    }
    
    [regex appendString:@"]"];
    
    return [self stringByReplacingOccurrencesOfString:regex withString:@"" options:NSRegularExpressionSearch range:range];;
}

#pragma mark- chinese

- (NSUInteger)sea_lengthWithChineseAs:(int) numberOfChar
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

- (NSString*)sea_stringByRemoveChinese
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

#pragma mark- 百度

+ (NSString*)sea_baiduURLForKey:(NSString *)key
{
    NSString *url = [NSString stringWithFormat:@"https://www.baidu.com/s?word=%@", key];
    return [url sea_encodeWithUTF8];
}

#pragma mark- md5

- (NSString*)seaMD5String
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

- (BOOL)isMobile
{
    if(self.length != 11){
        return NO;
    }
    return [self sea_evaluateWithFormat:@"^1[3|4|5|7|8]\\d{9}$"];
}

- (BOOL)isContainSpecialCharacter
{
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    return range.location != NSNotFound;
}

- (BOOL)isTelphone
{
    return [self sea_evaluateWithFormat:@"\\d{3}-\\d{8}|\\d{4}-\\d{7,8}"];
}

- (BOOL)isEmail
{
    return [self sea_evaluateWithFormat:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)isCardId
{
    if(self.length != 18){
        return NO;
    }
    
    NSArray *codeArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSDictionary *checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil] forKeys:[NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil]];
    
    NSScanner *scan = [NSScanner scannerWithString:[self substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum){
        return NO;
    }
    int sumValue = 0;
    
    for (int i = 0; i < 17; i++){
        sumValue += [[self substringWithRange:NSMakeRange(i , 1) ] intValue] * [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString *strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue % 11]];
    
    if ([strlast isEqualToString:[[self substringWithRange:NSMakeRange(17, 1)] uppercaseString]]){
        return YES;
    }
    return  NO;
}

- (BOOL)isURL
{
    NSString *urlRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSString *str = [NSString sea_encodeStringWithUTF8:self];
    
    if(![str sea_evaluateWithFormat:urlRegex]){
        urlRegex = @"\\b(https?)://(?:(\\S+?)(?::(\\S+?))?@)?([a-zA-Z0-9\\-.]+)(?::(\\d+))?((?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
        return [str sea_evaluateWithFormat:urlRegex];
    }
    return YES;
}

- (BOOL)isChinese
{
    return [self sea_evaluateWithFormat:@"^[\u4e00-\u9fa5]$"];
}

- (BOOL)isInteger
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isDigitalOnly
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length == 0;
}

- (BOOL)isAlphabetOnly
{
    return [self sea_evaluateWithFormat:@"^[A-Za-z]+$"];
}

- (BOOL)isConsistOfAlphabetOrDigital
{
    return [self sea_evaluateWithFormat:@"^[A-Za-z0-9]+$"];
}

- (BOOL)isBankCard
{
    if(self.length == 0)
        return NO;
    
    if(![self isDigitalOnly])
        return NO;
    
    BOOL match = NO;
    // 银行卡类型列表 unionpay electron maestro dankort interpayment visa mastercard amex diners discover jcb
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
    
    for(NSString *format in formats){
        if([self sea_evaluateWithFormat:format]){
            match = YES;
            break;
        }
    }
    
    return match;
}

#pragma mark- 正则

- (BOOL)sea_evaluateWithFormat:(NSString*) format
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    return [predicate evaluateWithObject:self];
}

#pragma mark- 格式化

- (NSString*)sea_formatTelphone
{
    NSString *number = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];;
    if(number.length >= 4){
        if(number.length > 30){
            number = [number stringByReplacingCharactersInRange:NSMakeRange(30, number.length - 30) withString:@""];
        }
        
        NSInteger codeIndex = 0;
        ///区号3位
        if([number hasPrefix:@"02"] || [number hasPrefix:@"01"] || [number hasPrefix:@"85"]){
            codeIndex = 3;
        }else if(number.length > 4){
            ///区号四位
            codeIndex = 4;
        }
        
        if(codeIndex != 0){
            number = [number stringByReplacingCharactersInRange:NSMakeRange(codeIndex, 0) withString:@"-"];
        }
    }
    
    return number;
}

@end

@implementation NSMutableString (customMutableString)

- (void)sea_removeLastCharacter
{
    if(self.length == 0)
        return;
    [self deleteCharactersInRange:NSMakeRange(self.length - 1, 1)];
}

- (void)sea_removeLastString:(NSString*) str
{
    if(self.length < str.length)
        return;
    [self deleteCharactersInRange:NSMakeRange(self.length - str.length, str.length)];
}

@end
