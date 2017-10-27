//
//  SeaBasicInitialization.m
//  SeaShopBasic
//
//  Created by 罗海雄 on 15/11/2.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "SeaBasicInitialization.h"
#import "UIColor+colorUtilities.h"

static UIColor *shareAppMainColor = nil;
static UIColor *shareBackgroundColor = nil;
static UIColor *shareButtonBackgroundColor = nil;
static NSString *shareMainFontName = nil;
static NSString *shareMainNumberFontName = nil;
static UIColor *shareMainGrayColor = nil;
static NSString *shareAlertMsgWhenBadNetwork = nil;
static UIColor *shareSeparatorLineColor = nil;
static CGFloat shareSeparatorLineWidth = 0;
static UIColor *shareNavigationBarColor = nil;
static UIColor *shareTintColor = nil;
static UIStatusBarStyle shareStatusBarStyle;
static UIColor *shareButtonTitleColor = nil;

@implementation SeaBasicInitialization

+ (void)sea_setBackgroundColor:(UIColor*) color
{
    shareBackgroundColor = color;
}

+ (UIColor*)sea_backgroundColor
{
    return shareBackgroundColor;
}

+ (void)sea_setAppMainColor:(UIColor*) color
{
    shareAppMainColor = color;
}

+ (UIColor*)sea_appMainColor
{

    return shareAppMainColor;
}

///字体
+ (void)sea_setMainFontName:(NSString*) name
{
    shareMainFontName = name;
}

+ (NSString*)sea_mainFontName
{
    return shareMainFontName;
}

///数字字体
+ (void)sea_setMainNumberFontName:(NSString*) name
{
    shareMainNumberFontName = name;
}

+ (NSString*)sea_mainNumberFontName
{
    return shareMainNumberFontName;
}

///字体颜色 #666666
+ (void)sea_setMainTextColor:(UIColor*) color
{
    shareMainGrayColor = color;
}

+ (UIColor*)sea_mainTextColor
{
    return shareMainGrayColor;
}

///网络错误提示信息
+ (void)sea_setAlertMsgWhenBadNetwork:(NSString*) msg
{
    shareAlertMsgWhenBadNetwork = msg;
}

+ (NSString*)sea_alertMsgWhenBadNetwork
{
    return shareAlertMsgWhenBadNetwork;
}

///分割线颜色
+ (void)sea_setseparatorLineColor:(UIColor*) color
{
    shareSeparatorLineColor = color;
}

+ (UIColor*)sea_separatorLineColor
{
    return shareSeparatorLineColor;
}

///分割线大小
+ (void)sea_setseparatorLineWidth:(CGFloat) width
{
    shareSeparatorLineWidth = width;
}

+ (CGFloat)sea_separatorLineWidth
{
    return shareSeparatorLineWidth;
}

///红颜色
+ (void)sea_setButtonBackgroundColor:(UIColor*) color
{
    shareButtonBackgroundColor = color;
}

+ (UIColor*)sea_buttonBackgroundColor
{
    return shareButtonBackgroundColor;
}

///导航栏颜色
+ (void)sea_setNavigationBarColor:(UIColor*) color
{
    shareNavigationBarColor = color;
}

+ (UIColor*)sea_navigationBarColor
{
    return shareNavigationBarColor;
}

///按钮字体颜色
+ (void)sea_setButtonTitleColor:(UIColor*) color
{
    shareButtonTitleColor = color;
}

+ (UIColor*)sea_buttonTitleColor
{
    return shareButtonTitleColor;
}

///状态栏样式
+ (void)sea_setStatusBarStyle:(UIStatusBarStyle) statusBarStyle
{
    shareStatusBarStyle = statusBarStyle;
}

+ (UIStatusBarStyle)sea_statusBarStyle
{
    return shareStatusBarStyle;
}

/**初始化
 */
+ (void)initialize
{
    if(self != [SeaBasicInitialization class])
        return;

    //视图主要背景颜色
    shareBackgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    
    //app主色调
    shareAppMainColor = [UIColor colorFromHexadecimal:@"9D1202"];

    
    ///按钮颜色
    shareButtonBackgroundColor = [UIColor colorFromHexadecimal:@"9D1202"];
    
    shareButtonTitleColor = [UIColor blackColor];
    
        //主要字体名称
    shareMainFontName = [UIFont systemFontOfSize:14].fontName;//
    
        //数字字体、英文字体
    shareMainNumberFontName = [UIFont systemFontOfSize:14].fontName;

    ///主要字体颜色
    shareMainGrayColor = [UIColor colorFromHexadecimal:@"666666"];

    
    //网络状态不好加载数据失败提示信息
    shareAlertMsgWhenBadNetwork = @"网络状态不佳";
    
        //分割线颜色
    shareSeparatorLineColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    shareSeparatorLineWidth = 0.5;
    
    shareNavigationBarColor = [UIColor colorFromHexadecimal:@"9D1202"];
    shareTintColor = [UIColor whiteColor];
    
    shareStatusBarStyle = UIStatusBarStyleDefault;
}

///导航栏tintColor
+ (void)sea_setTintColor:(UIColor*) color
{
    shareTintColor = color;
}

+ (UIColor*)sea_tintColor
{
    return shareTintColor;
}

@end
