//
//  SeaImageGenerator.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/10/25.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaImageGenerator.h"
#import "UIImage+Utils.h"

@implementation SeaImageGenerator

+ (UIImage*)untickWithColor:(UIColor *)color
{
    return [self untickWithColor:color size:CGSizeMake(21, 21)];
}

+ (UIImage*)untickWithColor:(UIColor*) color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, SeaImageScale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, size.width / 2.0, size.height / 2.0, size.width / 2.0, 0, M_PI * 2, NO);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokePath(context);
    
    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return icon;
}

+ (UIImage*)tickWithFillColor:(UIColor *)fillColor tickColor:(UIColor *)tickColor
{
    return [self tickWithFillColor:fillColor tickColor:tickColor size:CGSizeMake(21, 21)];
}

+ (UIImage*)tickWithFillColor:(UIColor*) backgroundColor tickColor:(UIColor*) tickColor size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, SeaImageScale);
    
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

+ (UIImage*)triangleWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floor(size.width), floor(size.height)), NO, SeaImageScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, size.width, 0);
    CGContextAddLineToPoint(context, size.width / 2.0, size.height);
    CGContextAddLineToPoint(context, 0, 0);
    
    CGContextFillPath(context);
    
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

@end
