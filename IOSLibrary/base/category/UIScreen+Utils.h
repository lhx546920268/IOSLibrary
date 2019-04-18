//
//  UIScreen+Utils.h
//  IOSLibrary
//
//  Created by luohaixiong on 2019/3/30.
//  Copyright © 2019年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///屏幕扩展
@interface UIScreen (Utils)

///获取屏幕宽度
@property(class, nonatomic, readonly) CGFloat screenWidth;

///屏幕高度
@property(class, nonatomic, readonly) CGFloat screenHeight;

///屏幕大小
@property(class, nonatomic, readonly) CGSize screenSize;

///屏幕bounds
@property(class, nonatomic, readonly) CGRect screenBounds;

@end

