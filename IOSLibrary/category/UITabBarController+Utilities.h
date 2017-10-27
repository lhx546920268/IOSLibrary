//
//  UITabBarController+Utilities.h
//  WanShoes
//
//  Created by 罗海雄 on 16/4/5.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (Utilities)

/**以默认样式在tabBar 上面显示一个点， 红色，10 * 10
 */
- (void)addRedPointAtIndex:(NSInteger) index;

/**在tabBar 上面显示一个点
 *@param size 点大小
 *@param color 点颜色
 *@param index 点所在的 tabBarItem
 */
- (void)addPointWithSize:(CGSize) size color:(UIColor*) color atIndex:(NSInteger) index;



@end
