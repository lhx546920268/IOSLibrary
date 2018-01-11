//
//  SeaImageGenerator.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/10/25.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 draw 创建图片
 */
@interface SeaImageGenerator : NSObject

/**
 [self untickWithColor:color size:CGSizeMake(21, 21)]
 */
+ (UIImage*)untickWithColor:(UIColor*) color;

/**
 未打钩图片

 @param color 圈圈颜色
 @param size 大小
 @return 生成的图片
 */
+ (UIImage*)untickWithColor:(UIColor*) color size:(CGSize) size;

/**
 [self tickWithFillColor:fillColor tickColor:tickColor size:CGSizeMake(21, 21)]
 */
+ (UIImage*)tickWithFillColor:(UIColor*) fillColor tickColor:(UIColor*) tickColor;

/**
 打钩的选中图标

 @param fillColor 填充颜色
 @param tickColor 勾颜色
 @param size 大小
 @return 生成的图片
 */
+ (UIImage*)tickWithFillColor:(UIColor*) fillColor tickColor:(UIColor*) tickColor size:(CGSize) size;

/**
 三角形图标
 @param color 图标颜色
 @param size 大小
 @return 生成的图片
 */
+ (UIImage*)triangleWithColor:(UIColor*) color size:(CGSize) size;
    
@end
