//
//  UIView+SeaEmptyView.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/12.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaEmptyView.h"

///空视图
@interface UIView (SeaEmptyView)

///空视图 不要直接设置这个 使用 sea_showEmptyView
@property(nonatomic, strong) SeaEmptyView *sea_emptyView;

///设置显示空视图
@property(nonatomic, assign) BOOL sea_showEmptyView;

///空视图代理
@property(nonatomic, weak) id<SeaEmptyViewDelegate> sea_emptyViewDelegate;

///旧的视图大小，防止 layoutSubviews 时重复计算
@property(nonatomic, assign) CGSize sea_oldSize;

///调整emptyView
- (void)layoutEmtpyView;

@end
