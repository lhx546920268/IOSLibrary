//
//  SeaDefaultRefreshControl.h
//  IOSLibrary
//
//  Created by luohaixiong on 2018/7/20.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaRefreshControl.h"

/**
 默认的下拉刷新控件
 */
@interface SeaDefaultRefreshControl : SeaRefreshControl

/**
 刷新控制的状态信息视图
 */
@property(nonatomic,readonly) UILabel *statusLabel;

/**
 刷新指示器
 */
@property(nonatomic,readonly) UIActivityIndicatorView *indicatorView;

/**
 是否要显示菊花 默认显示
 */
@property(nonatomic, assign) BOOL showIndicatorView;

@end
