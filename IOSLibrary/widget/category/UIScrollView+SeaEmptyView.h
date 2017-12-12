//
//  UIScrollView+SeaEmptyView.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/12.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///用于scrollView 的空视图
@interface UIScrollView (SeaEmptyView)

///是否显示空视图 default is 'NO'， 当为YES时，如果是UITableView 或者 UIScrollView，还需要没有数据时才显示
@property(nonatomic,assign) BOOL sea_shouldShowEmptyView;

///空视图偏移量 default is UIEdgeInsetZero
@property(nonatomic,assign) UIEdgeInsets sea_emptyViewInsets;

///调整emptyView
- (void)layoutEmtpyView;

///当前是空数据 UIScrollView 一定是空的，其他的不一定
- (BOOL)isEmptyData;

@end
