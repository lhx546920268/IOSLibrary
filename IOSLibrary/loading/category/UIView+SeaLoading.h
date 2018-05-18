//
//  UIView+SeaLoading.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/8.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///显示加载中类目
@interface UIView (SeaLoading)

///页面第一次加载显示
@property(nonatomic, assign) BOOL sea_showPageLoading;

///页面第一次加载视图 默认 SeaPageLoadingView
@property(nonatomic, strong) UIView *sea_pageLoadingView;

///显示菊花
@property(nonatomic, assign) BOOL sea_showNetworkActivity;

///菊花 默认SeaNetworkActivityView
@property(nonatomic, strong) UIView *sea_networkActivity;

///显示加载失败页面
@property(nonatomic, assign) BOOL sea_showFailPage;

///失败页面 默认 SeaFailPageView
@property(nonatomic, strong) UIView *sea_failPageView;

///点击失败页面回调
@property(nonatomic, copy) void(^sea_reloadDataHandler)(void);

///点击失败视图
- (void)handlerTapFailPage:(UITapGestureRecognizer*) tap;

///延迟显示菊花，只是UI显示延迟，其实还是会遮住底层的UI，用户无法点击
- (void)sea_showNetworkActivityAfterDelay:(NSTimeInterval) delay;

@end
