//
//  UITabBarController+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (Utils)

/**
 以默认样式在tabBar 上面显示一个点， 红色，10 * 10
 */
- (void)sea_addRedPointAtIndex:(NSInteger) index;

/**
 在tabBar 上面显示一个点
 *@param size 点大小
 *@param color 点颜色
 *@param index 点所在的 tabBarItem
 */
- (void)sea_addPointWithSize:(CGSize) size color:(UIColor*) color atIndex:(NSInteger) index;


@end
