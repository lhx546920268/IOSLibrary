//
//  SeaPageViewController.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/10.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <IOSLibrary/IOSLibrary.h>

@class SeaMenuBar;

/**
 翻页视图控制器
 */
@interface SeaPageViewController : SeaViewController

/**
 顶部菜单
 */
@property(nonatomic, readonly) SeaMenuBar *menuBar;

- (void)reloadData;

- (void)setPage:(NSUInteger) page animate:(BOOL) animate;

@end
