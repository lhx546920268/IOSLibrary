//
//  NSString+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/29.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "NSString+Utils.h"

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

@end
