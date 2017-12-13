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

///空视图
@property(nonatomic,readonly) SeaEmptyView *sea_emptyView;

///设置显示空视图
@property(nonatomic,assign) BOOL sea_showEmptyView;

///空视图代理
@property(nonatomic,weak) id<SeaEmptyViewDelegate> sea_emptyViewDelegate;

///调整emptyView
- (void)layoutEmtpyView;

@end
