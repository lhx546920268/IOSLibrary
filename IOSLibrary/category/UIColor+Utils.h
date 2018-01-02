//
//  UIColor+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///红
UIKIT_EXTERN NSString *const SeaColorRed;

///绿
UIKIT_EXTERN NSString *const SeaColorGreen;

///蓝
UIKIT_EXTERN NSString *const SeaColorBlue;

///透明度
UIKIT_EXTERN NSString *const SeaColorAlpha;


/**
 16进制可不带#，格式为 #c0f，c0f，#cc00ff，cc00ff，#fc0f，fc0f，#ffcc00ff，ffcc00ff
 返回的16进制是不带#的 小写字母
 返回的ARGB 值 rgb，透明度为0~1.0
 */
@interface UIColor (Utils)

/**
 获取颜色的ARGB值 0 ~ 1.0
 *@return 成功返回一个字典 SeaColorRed  否则nil
 */
- (NSDictionary<NSString*, NSNumber*>*)sea_colorARGB;

/**
 颜色是否相同
 *@param color 要比较的颜色
 */
- (BOOL)isEqualToColor:(UIColor*) color;

/**
 获取颜色的16进制 含透明度
 *@return 16进制颜色值，FFFFFFFF
 */
- (NSString*)sea_colorHex;

/**
 通过16进制值获取颜色 rgb，如果hex里面没有包含rgb，则透明度为1.0
 @param hex 16进制
 @return 颜色 ARBG
 */
+ (NSDictionary<NSString*, NSNumber*>*)sea_colorARGBFromHex:(NSString*) hex;

/**
 通过ARGB值获取颜色的16进制
 *@param red 红色 0~255
 *@param green 绿色 0~255
 *@param blue 蓝色 0~255
 *@param alpha 透明度
 *@return 16进制颜色值，FFFFFFFF
 */
+ (NSString*)sea_colorHexFromRed:(int) red green:(int) green  blue:(int) blue alpha:(CGFloat) alpha;

/**
 通过16进制颜色值获取颜色 当hex里面有没有透明度值时，透明度为 1.0
 *@param hex 16进制值
 *@return 一个 UIColor对象
 */
+ (UIColor*)sea_colorFromHex:(NSString*) hex;

/**
 通过16进制颜色值获取颜色 将忽略16进制值里面的透明度
 *@param hex 16进制值
 *@param alpha 0~1.0 透明度
 *@return 一个 UIColor对象
 */
+ (UIColor*)sea_colorFromHex:(NSString*) hex alpha:(CGFloat) alpha;

/**以整数rpg初始化
 *@param red 红色 0 ~ 255
 *@param green 绿色 0 ~ 255
 *@param blue 蓝色 0 ~ 255
 *@param alpha 透明度 0 ~ 1.0
 *@return 一个初始化的颜色对象
 */
+ (UIColor*)sea_colorWithRed:(int) red green:(int) green blue:(int) blue alpha:(CGFloat) alpha;

@end
