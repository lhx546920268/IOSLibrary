//
//  SeaConstant.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/3/29.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaConstant.h"
#import "UIColor+Utils.h"
#import "SeaColorMacro.h"

static UIColor *sharedAppMainColor = nil;
static UIColor *sharedAppMainTintColor = nil;
static UIColor *sharedGrayBackgroundColor = nil;

static UIColor *sharedButtonBackgroundColor = nil;
static UIColor *sharedButtonDisableBackgroundColor = nil;
static UIColor *sharedButtonTitleColor = nil;
static UIColor *sharedButtonDisableTitleColor = nil;

static NSString *sharedMainFontName = nil;
static NSString *sharedMainNumberFontName = nil;
static NSString *sharedBadNetworkText = nil;

static UIColor *sharedSeparatorColor = nil;
static CGFloat sharedSeparatorWidth = 0;

static UIStatusBarStyle sharedStatusBarStyle;

static UIColor *sharedWebProgressColor = nil;

@implementation SeaConstant

+ (void)setGrayBackgroundColor:(UIColor *)color
{
    sharedGrayBackgroundColor = color;
}

+ (UIColor*)grayBackgroundColor
{
    return sharedGrayBackgroundColor;
}

+ (void)setAppMainColor:(UIColor*) color
{
    sharedAppMainColor = color;
}

+ (UIColor*)appMainColor
{
    return sharedAppMainColor;
}

+ (void)setAppMainTintColor:(UIColor*) color
{
    sharedAppMainTintColor = color;
}

+ (UIColor*)appMainTintColor
{
    return sharedAppMainTintColor;
}

///字体
+ (void)setMainFontName:(NSString*) name
{
    sharedMainFontName = name;
}

+ (NSString*)mainFontName
{
    return sharedMainFontName;
}

///数字字体
+ (void)setMainNumberFontName:(NSString*) name
{
    sharedMainNumberFontName = name;
}

+ (NSString*)mainNumberFontName
{
    return sharedMainNumberFontName;
}

///网络错误提示信息
+ (void)setBadNetworkText:(NSString *)msg
{
    sharedBadNetworkText = msg;
}

+ (NSString*)badNetworkText
{
    return sharedBadNetworkText;
}

///分割线颜色
+ (void)setSeparatorColor:(UIColor*) color
{
    sharedSeparatorColor = color;
}

+ (UIColor*)separatorColor
{
    return sharedSeparatorColor;
}

///分割线大小
+ (void)setSeparatorWidth:(CGFloat) width
{
    sharedSeparatorWidth = width;
}

+ (CGFloat)separatorWidth
{
    return sharedSeparatorWidth;
}

///按钮背景颜色
+ (void)setButtonBackgroundColor:(UIColor*) color
{
    sharedButtonBackgroundColor = color;
}

+ (UIColor*)buttonBackgroundColor
{
    return sharedButtonBackgroundColor;
}

///按钮无法点击时背景颜色
+ (void)setButtonDisableBackgroundColor:(UIColor *)color
{
    sharedButtonDisableBackgroundColor = color;
}

+ (UIColor*)buttonDisableBackgroundColor
{
    return sharedButtonDisableBackgroundColor;
}

///按钮字体颜色
+ (void)setButtonTitleColor:(UIColor*) color
{
    sharedButtonTitleColor = color;
}

+ (UIColor*)buttonTitleColor
{
    return sharedButtonTitleColor;
}

///按钮字体不能点击时的颜色
+ (void)setButtonDisableTitleColor:(UIColor*) color
{
    sharedButtonDisableTitleColor = color;
}

+ (UIColor*)buttonDisableTitleColor
{
    return sharedButtonDisableTitleColor;
}

///状态栏样式
+ (void)setStatusBarStyle:(UIStatusBarStyle) statusBarStyle
{
    sharedStatusBarStyle = statusBarStyle;
}

+ (UIStatusBarStyle)statusBarStyle
{
    return sharedStatusBarStyle;
}

+ (void)setWebProgressColor:(UIColor*) color
{
    sharedWebProgressColor = color;
}

+ (UIColor*)webProgressColor
{
    return sharedWebProgressColor;
}

/**初始化
 */
+ (void)initialize
{
    if(self != [SeaConstant class])
        return;
    
    //视图主要背景颜色
    sharedGrayBackgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    
    //app主色调
    sharedAppMainColor = [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0];
    sharedAppMainTintColor = [UIColor whiteColor];
    
    ///按钮颜色
    sharedButtonBackgroundColor = [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0];
    sharedButtonDisableBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    sharedButtonTitleColor = [UIColor whiteColor];
    sharedButtonDisableTitleColor = [UIColor grayColor];
    
    //主要字体名称
    sharedMainFontName = [UIFont systemFontOfSize:14].fontName;//
    
    //数字字体、英文字体
    sharedMainNumberFontName = [UIFont systemFontOfSize:14].fontName;
    
    //网络状态不好加载数据失败提示信息
    sharedBadNetworkText = @"网络状态不佳";
    
    //分割线颜色
    sharedSeparatorColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    sharedSeparatorWidth = 1.0 / [UIScreen mainScreen].scale;
    
    sharedStatusBarStyle = UIStatusBarStyleDefault;
    
    sharedWebProgressColor = UIKitTintColor;
    
}

@end
