//
//  SeaPageViewController.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/10.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaCollectionViewController.h"

@class SeaMenuBar;

/**
 翻页视图控制器
 */
@interface SeaPageViewController : SeaCollectionViewController

/**
 顶部菜单
 */
@property(nonatomic, readonly) SeaMenuBar *menuBar;

/**
 刷新数据
 */
- (void)reloadData;

/**
 跳转到某一页

 @param page 页码
 @param animate 是否动画
 */
- (void)setPage:(NSUInteger) page animate:(BOOL) animate;

///获取对应下标的controller ，子类要重新
- (UIViewController*)viewControllerForIndex:(NSUInteger) index;

@end
