//
//  SeaConstant.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/3/29.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///常量
@interface SeaConstant : NSObject

///灰色背景颜色
+ (void)setGrayBackgroundColor:(UIColor*) color;
+ (UIColor*)grayBackgroundColor;

///app主色调
+ (void)setAppMainColor:(UIColor*) color;
+ (UIColor*)appMainColor;

+ (void)setAppMainTintColor:(UIColor*) color;
+ (UIColor*)appMainTintColor;

#pragma mark- font

///字体
+ (void)setMainFontName:(NSString*) name;
+ (NSString*)mainFontName;

///数字字体
+ (void)setMainNumberFontName:(NSString*) name;
+ (NSString*)mainNumberFontName;

///网络错误提示信息
+ (void)setBadNetworkText:(NSString*) msg;
+ (NSString*)badNetworkText;

#pragma mark- 分割线

///分割线颜色
+ (void)setSeparatorColor:(UIColor*) color;
+ (UIColor*)separatorColor;

///分割线大小
+ (void)setSeparatorWidth:(CGFloat) width;
+ (CGFloat)separatorWidth;

#pragma mark- 按钮

///按钮颜色
+ (void)setButtonBackgroundColor:(UIColor*) color;
+ (UIColor*)buttonBackgroundColor;

///按钮不能点击时的背景颜色
+ (void)setButtonDisableBackgroundColor:(UIColor*) color;
+ (UIColor*)buttonDisableBackgroundColor;

///按钮字体颜色
+ (void)setButtonTitleColor:(UIColor*) color;
+ (UIColor*)buttonTitleColor;

///按钮字体不能点击时的颜色
+ (void)setButtonDisableTitleColor:(UIColor*) color;
+ (UIColor*)buttonDisableTitleColor;

#pragma mark- 状态栏

///状态栏样式
+ (void)setStatusBarStyle:(UIStatusBarStyle) statusBarStyle;
+ (UIStatusBarStyle)statusBarStyle;

@end
