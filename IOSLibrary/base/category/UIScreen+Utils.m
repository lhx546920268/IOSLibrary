//
//  UIScreen+Utils.m
//  IOSLibrary
//
//  Created by luohaixiong on 2019/3/30.
//  Copyright © 2019年 罗海雄. All rights reserved.
//

#import "UIScreen+Utils.h"

@implementation UIScreen (Utils)

+ (CGFloat)screenWidth
{
    return UIScreen.screenSize.width;
}

+ (CGFloat)screenHeight
{
    return UIScreen.screenSize.height;
}

+ (CGSize)screenSize
{
    return UIScreen.screenBounds.size;
}

+ (CGRect)screenBounds
{
    CGRect bounds = [UIScreen mainScreen].nativeBounds;
    bounds.size.width /= [UIScreen mainScreen].nativeScale;
    bounds.size.height /= [UIScreen mainScreen].nativeScale;
    
    return bounds;
}

@end
