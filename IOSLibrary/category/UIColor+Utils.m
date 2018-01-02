//
//  UIColor+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UIColor+Utils.h"
#import "NSString+Utils.h"

///红
NSString *const SeaColorRed = @"red";

///绿
NSString *const SeaColorGreen = @"green";

///蓝
NSString *const SeaColorBlue = @"blue";

///透明度
NSString *const SeaColorAlpha = @"alpha";

@implementation UIColor (Utils)

- (NSDictionary<NSString*, NSNumber*>*)sea_colorARGB
{
    CGFloat red, green, blue, alpha;
    
    BOOL success = [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if(success){
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @(red), SeaColorRed,
                @(green), SeaColorGreen,
                @(blue), SeaColorBlue,
                @(alpha), SeaColorAlpha,
                nil];
    }
    
    return nil;
}

- (BOOL)isEqualToColor:(UIColor*) color
{
    NSDictionary *dic1 = [self sea_colorARGB];
    NSDictionary *dic2 = [color sea_colorARGB];
    
    if(dic1 == nil || dic2 == nil)
        return NO;
    
    CGFloat R1 = [[dic1 objectForKey:SeaColorRed] floatValue];
    CGFloat G1 = [[dic1 objectForKey:SeaColorGreen] floatValue];
    CGFloat B1 = [[dic1 objectForKey:SeaColorBlue] floatValue];
    CGFloat A1 = [[dic1 objectForKey:SeaColorAlpha] floatValue];
    
    CGFloat R2 = [[dic2 objectForKey:SeaColorRed] floatValue];
    CGFloat G2 = [[dic2 objectForKey:SeaColorGreen] floatValue];
    CGFloat B2 = [[dic2 objectForKey:SeaColorBlue] floatValue];
    CGFloat A2 = [[dic2 objectForKey:SeaColorAlpha] floatValue];
    
    return R1 == R2 && B1 == B2 && G1 == G2 && A1 == A2;
}

- (NSString*)sea_colorHex
{
    NSDictionary *dic = [self sea_colorARGB];
    if(dic != nil)
    {
        int R = [[dic objectForKey:SeaColorRed] floatValue] * 255;
        int G = [[dic objectForKey:SeaColorGreen] floatValue] * 255;
        int B = [[dic objectForKey:SeaColorBlue] floatValue] * 255;
        CGFloat A = [[dic objectForKey:SeaColorAlpha] floatValue];
        
        return [UIColor sea_colorHexFromRed:R green:G blue:B alpha:A];
    }
    return @"ff000000";
}

+ (NSDictionary<NSString*, NSNumber*>*)sea_colorARGBFromHex:(NSString*) hex
{
    if([NSString isEmpty:hex])
        return nil;
    hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hex = [hex uppercaseString];
    
    CGFloat alpha = 1.0;
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    
    int index = 0;
    int len = 0;
    int length = hex.length;
    switch (length) {
        case 3 :
        case 4 : {
            len = 1;
            if(length == 4){
                int a = [self sea_decimalFromHexChar:[hex characterAtIndex:index]];
                alpha = a * 16 + a;
                index += len;
            }
            int value = [self sea_decimalFromHexChar:[hex characterAtIndex:index]];
            red = value * 16 + value;
            index += len;
            
            value = [self sea_decimalFromHexChar:[hex characterAtIndex:index]];
            green = value * 16 + value;
            index += len;
            
            value = [self sea_decimalFromHexChar:[hex characterAtIndex:index]];
            blue = value * 16 + value;
        }
            break;
        case 6 :
        case 8 : {
            len = 2;
            if(length == 8){
                alpha = [self sea_decimalFromHex:[hex substringWithRange:NSMakeRange(index, len)]];
                index += len;
            }
            red = [self sea_decimalFromHex:[hex substringWithRange:NSMakeRange(index, len)]];
            index += len;
            
            green = [self sea_decimalFromHex:[hex substringWithRange:NSMakeRange(index, len)]];
            index += len;
            
            blue = [self sea_decimalFromHex:[hex substringWithRange:NSMakeRange(index, len)]];
        }
            break;
        default:
            break;
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @(red / 255.0f), SeaColorRed,
            @(green / 255.0f), SeaColorGreen,
            @(blue / 255.0f), SeaColorBlue,
            @(alpha / 255.0f), SeaColorAlpha,
            nil];
}

+ (NSString*)sea_colorHexFromRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha
{
    int a = alpha * 255;
    return [NSString stringWithFormat:@"%02x%02x%02x%02x", a, red, green, blue];
}

+ (UIColor*)sea_colorFromHex:(NSString*) hex
{
    return [UIColor sea_colorFromHex:hex alpha:1.0];
}

+ (UIColor*)sea_colorFromHex:(NSString*) hex alpha:(CGFloat) alpha
{
    hex = [hex uppercaseString];
    if(hex.length >= 6){
        NSInteger index = 0;
        if([hex hasPrefix:@"#"])
        {
            if(hex.length < 7)
                return nil;
            
            index = 1;
        }
        NSString *hexR = [hex substringWithRange:NSMakeRange(index, 2)];
        NSString *hexG = [hex substringWithRange:NSMakeRange(index + 2, 2)];
        NSString *hexB = [hex substringWithRange:NSMakeRange(index + 4, 2)];
        
        CGFloat R = [self sea_decimalFromHex:[hexR sea_firstCharacter]] * 16 + [self sea_decimalFromHex:[hexR characterAtIndex:1]];
        CGFloat G = [self sea_decimalFromHex:[hexG sea_firstCharacter]] * 16 + [self sea_decimalFromHex:[hexG characterAtIndex:1]];
        CGFloat B = [self sea_decimalFromHex:[hexB sea_firstCharacter]] * 16 + [self sea_decimalFromHex:[hexB characterAtIndex:1]];
        
        UIColor *color = [UIColor colorWithRed:R / 255.0f green:G / 255.0f blue:B / 255.0f alpha:alpha];
        
        return color;
    }else{
        return [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
    }
}

/**
 获取10进制
 *@param hex 16进制
 *@return 10进制值
 */
+ (int)sea_decimalFromHex:(NSString*) hex
{
    int result = 0;
    int than = 1;
    for(NSInteger i = hex.length - 1;i >= 0;i --){
        char c = [hex characterAtIndex:i];
        
        result += [self sea_decimalFromHexChar:c] * than;
        than *= 16;
    }
    return result;
}

/**
 获取10进制
 *@param c 16进制
 *@return 10进制值
 */
+ (int)sea_decimalFromHexChar:(char) c
{
    int value;
    switch (c) {
        case 'A' :
            value = 10;
            break;
        case 'B' :
            value = 11;
        case 'C' :
            value = 12;
        case 'D' :
            value = 13;
            break;
        case 'E' :
            value = 14;
            break;
        case 'F' :
            value = 15;
            break;
        default:
            value = [[NSString stringWithFormat:@"%c", c] intValue];;
            break;
    }
    return value;
}

+ (UIColor*)sea_colorWithRed:(int) r green:(int) g blue:(int) b alpha:(CGFloat) a
{
    r = MIN(255, abs(r));
    g = MIN(255, abs(g));
    b = MIN(255, abs(b));
    a = MIN(1.0, fabs(a));
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a];
}

@end
