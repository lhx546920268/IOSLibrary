//
//  UITabBarController+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UITabBarController+Utils.h"
#import <objc/runtime.h>
#import "SeaBasic.h"

@implementation UITabBarController (Utils)

/**以默认样式在tabBar 上面显示一个点， 红色，10 * 10
 */
- (void)sea_addRedPointAtIndex:(NSInteger) index
{
    [self sea_addPointWithSize:CGSizeMake(10, 10) color:[UIColor redColor] atIndex:index];
}

/**在tabBar 上面显示一个点
 *@param size 点大小
 *@param color 点颜色
 *@param index 点所在的 tabBarItem
 */
- (void)sea_addPointWithSize:(CGSize) size color:(UIColor*) color atIndex:(NSInteger) index
{
#if SeaDebug
    NSAssert(index < self.tabBar.items.count, @"addPointWithSize:(CGSize) size color:(UIColor*) color atIndex:(NSInteger) index ， index 已越界");
#endif
    
    NSMutableDictionary *dic = [self sea_pointDictionary];
    UIView *point = [dic objectForKey:@(index)];
    
    if(!point)
    {
        point = [[UIView alloc] init];
        point.userInteractionEnabled = NO;
        [self.tabBar addSubview:point];
        [dic setObject:point forKey:@(index)];
    }
    
    UITabBarItem *item = [self.tabBar.items objectAtIndex:index];
    UIImage *image = item.image != nil ? item.image : item.selectedImage;
    
    point.backgroundColor = color;
    
    CGFloat width = SeaScreenWidth / self.viewControllers.count;
    CGFloat x = width * index + width / 2.0 + image.size.width / 2.0;
    if(x + size.width > width * (index + 1))
    {
        x = width * (index + 1) - size.width;
    }
    
    ///x 轴是小数时，点会变成不圆的
    point.frame = CGRectMake(floorf(x), 5.0, size.width, size.height);
    point.layer.cornerRadius = MAX(size.width, size.height) / 2.0;
    point.layer.masksToBounds = YES;
}

///获取存放点的字典
- (NSMutableDictionary*)sea_pointDictionary
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, _cmd);
    if(!dic)
    {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dic;
}

@end
