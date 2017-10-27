//
//  SeaBasicInitialization.h
//  SeaShopBasic
//
//  Created by 罗海雄 on 15/11/2.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeaBasicInitialization : NSObject

///viewController背景颜色
+ (void)sea_setBackgroundColor:(UIColor*) color;
+ (UIColor*)sea_backgroundColor;

///app主色调
+ (void)sea_setAppMainColor:(UIColor*) color;
+ (UIColor*)sea_appMainColor;

///字体
+ (void)sea_setMainFontName:(NSString*) name;
+ (NSString*)sea_mainFontName;

///数字字体
+ (void)sea_setMainNumberFontName:(NSString*) name;
+ (NSString*)sea_mainNumberFontName;

///字体颜色 #666666
+ (void)sea_setMainTextColor:(UIColor*) color;
+ (UIColor*)sea_mainTextColor;

///网络错误提示信息
+ (void)sea_setAlertMsgWhenBadNetwork:(NSString*) msg;
+ (NSString*)sea_alertMsgWhenBadNetwork;

///分割线颜色
+ (void)sea_setseparatorLineColor:(UIColor*) color;
+ (UIColor*)sea_separatorLineColor;

///分割线大小
+ (void)sea_setseparatorLineWidth:(CGFloat) width;
+ (CGFloat)sea_separatorLineWidth;

///按钮颜色
+ (void)sea_setButtonBackgroundColor:(UIColor*) color;
+ (UIColor*)sea_buttonBackgroundColor;

///按钮字体颜色
+ (void)sea_setButtonTitleColor:(UIColor*) color;
+ (UIColor*)sea_buttonTitleColor;

///导航栏颜色
+ (void)sea_setNavigationBarColor:(UIColor*) color;
+ (UIColor*)sea_navigationBarColor;

///导航栏tintColor，按钮标题颜色
+ (void)sea_setTintColor:(UIColor*) color;
+ (UIColor*)sea_tintColor;

///状态栏样式
+ (void)sea_setStatusBarStyle:(UIStatusBarStyle) statusBarStyle;
+ (UIStatusBarStyle)sea_statusBarStyle;

@end
