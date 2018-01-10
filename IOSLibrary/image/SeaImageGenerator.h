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

///未打钩图片
+ (UIImage*)untickIconWithColor:(UIColor*) color;
    
///打钩的选中图标
+ (UIImage*)tickingIconWithBackgroundColor:(UIColor*) backgroundColor tickColor:(UIColor*) tickColor;
    
@end
