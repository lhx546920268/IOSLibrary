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
 顶部菜单 当 shouldUseMenuBar = NO，return nil
 */
@property(nonatomic, readonly) SeaMenuBar *menuBar;

/**
 是否需要用菜单 menuBar default is 'YES'
 */
@property(nonatomic, assign) BOOL shouldUseMenuBar;

/**
 当前页码
 */
@property(nonatomic, readonly) NSInteger currentPage;

/**
 当前显示的 viewController
 */
@property(nonatomic, readonly, weak) UIViewController *currentViewController;

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

/**
 获取对应下标的controller ，子类要重写
 
 @param index 对应下标
 @return 对应下标的controller
 */
- (UIViewController*)viewControllerForIndex:(NSUInteger) index;

/**
 页数量 默认是返回 menuBar.titles.count，如果 shouldUseMenuBar = NO,需要重写该方法

 @return 页数量
 */
- (NSInteger)numberOfPage;

/**
 滑动到某一页，setPage 时不调用

 @param page 某一页
 */
- (void)onScrollTopPage:(NSInteger) page;

@end
