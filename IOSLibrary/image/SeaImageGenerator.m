//
//  SeaImageGenerator.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/10/25.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaImageGenerator.h"

@implementation SeaImageGenerator

///未打钩图片
+ (UIImage*)untickIconWithColor:(UIColor*) color
{
    CGSize size = CGSizeMake(21, 21);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, size.width / 2.0, size.height / 2.0, size.width / 2.0, 0, M_PI * 2, NO);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokePath(context);
    
    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return icon;
}
    
///打钩的选中图标
+ (UIImage*)tickingIconWithBackgroundColor:(UIColor*) backgroundColor tickColor:(UIColor*) tickColor
{
    CGSize size = CGSizeMake(21, 21);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, size.width / 2.0, size.height / 2.0, size.width / 2.0, 0, M_PI * 2, NO);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillPath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.5);
    CGContextMoveToPoint(context, 3.0, size.height / 2.0);
    CGContextAddLineToPoint(context, size.width / 3.0, size.height / 4.0 * 3.0);
    CGContextAddLineToPoint(context, size.width / 4.0 * 3.0, size.height / 4.0);
    
    CGContextStrokePath(context);
    
    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return icon;
}

@end
