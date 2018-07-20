//
//  UIFont+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UIFont+Utils.h"
#import "SeaBasic.h"

@implementation UIFont (Utils)

+ (UIFont*)sea_fontFromCTFont:(CTFontRef) ctFont
{
    if(ctFont == NULL)
        return nil;
    
    CFStringRef fontName = CTFontCopyPostScriptName(ctFont);
    CGFloat fontSize = CTFontGetSize(ctFont);
    
    UIFont *ret = [UIFont fontWithName:(__bridge NSString*)fontName size:fontSize];
    CFRelease(fontName);
    return ret;
}

- (BOOL)isEqualToFont:(UIFont*) font
{
    if(!font)
        return NO;
    
    return [self.fontName isEqualToString:font.fontName] && self.pointSize == font.pointSize;
}

+ (UIFont*)appFontWithSize:(CGFloat) size
{
    return [UIFont fontWithName:SeaMainFontName size:size];
}

+ (UIFont*)appNumberFontWithSize:(CGFloat) size
{
    return [UIFont fontWithName:SeaMainNumberFontName size:size];
}

@end
