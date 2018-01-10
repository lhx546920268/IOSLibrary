//
//  UIViewController+Utilities.h
//  Sea
//
//  Created by 罗海雄 on 15/9/14.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaFailPageView,
SeaPageLoadingView,
SeaNavigationController,
SeaTabBarController,
SeaNetworkActivityView,
SeaToast,
SeaEmptyView;


@interface UIViewController (Utils)

///是否使用系统返回按钮 default is '【SeaBasicInitialization sea_useSystemBackItem]'
//@property(nonatomic, assign) BOOL sea_useSystemBackItem;

///显示返回按钮 图片名称 back_icon
@property(nonatomic, assign) BOOL sea_showBackItem;

///导航栏按钮或按钮字体颜色
@property(nonatomic, strong) UIColor *sea_iconTintColor;

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

///statusBar 隐藏状态控制 default is 'NO' ，不隐藏
@property(nonatomic,assign) BOOL sea_statusBarHidden;

///状态栏高度
@property(nonatomic,readonly) CGFloat sea_statusBarHeight;

///导航栏高度
@property(nonatomic,readonly) CGFloat sea_navigationBarHeight;

///选项卡高度
@property(nonatomic,readonly) CGFloat sea_tabBarHeight;

///工具条高度
@property(nonatomic,readonly) CGFloat sea_toolBarHeight;

///自定义的导航栏
@property(nonatomic,readonly) SeaNavigationController *sea_navigationController;

///过渡动画代理 设置这个可防止 transitioningDelegate 提前释放，不要设置为 self，否则会抛出异常
@property(nonatomic,strong) id<UIViewControllerTransitioningDelegate> sea_transitioningDelegate;

///空视图
@property(nonatomic,readonly) SeaEmptyView *sea_emptyView;

///设置显示空视图
@property(nonatomic,assign) BOOL sea_showEmptyView;

/**关联的选项卡 default is 'nil'
 */
@property(nonatomic,weak) SeaTabBarController *sea_tabBarController;

/**当viewWillAppear时是否隐藏选项卡 default is 'YES'
 */
@property(nonatomic,assign) BOOL sea_hideTabBar;

/**重新加载数据 默认不做任何事，子类可以重写该方法
 */
- (void)sea_reloadData;


/**返回方法 支持present和push出来的视图
 */
- (void)sea_back;

/**返回方法 支持present和push出来的视图
 *@param flag 是否动画
 */
- (void)sea_backAnimated:(BOOL) flag;

/**返回根视图，支持present和push出来的视图
 *@param flag 是否动画
 */
- (void)sea_backToRootViewControllerAnimated:(BOOL) flag;

/**获取最上层的 presentedViewController
 */
- (UIViewController*)sea_topestPresentedViewController;

/**获取最底层的 presentingViewController
 */
- (UIViewController*)sea_rootPresentingViewController;

/**
 设置导航栏左边按钮

 @param title 按钮标题
 @param action 点击方法
 @return 按钮
 */
- (UIBarButtonItem*)sea_setLeftItemWithTitle:(NSString*) title action:(SEL) action;

/**
 设置导航栏左边按钮
 
 @param image 按钮图标
 @param action 点击方法
 @return 按钮
 */
- (UIBarButtonItem*)sea_setLeftItemWithImage:(UIImage*) image action:(SEL) action;

/**
 设置导航栏左边按钮
 
 @param systemItem 系统按钮图标
 @param action 点击方法
 @return 按钮
 */
- (UIBarButtonItem*)sea_setLeftItemWithSystemItem:(UIBarButtonSystemItem) systemItem action:(SEL) action;

/**
 设置导航栏左边按钮

 @param customView 自定义视图
 @return 按钮
 */
- (UIBarButtonItem*)sea_setLeftItemWithCustomView:(UIView*) customView;

/**
 设置导航栏右边按钮
 
 @param title 按钮标题
 @param action 点击方法
 @return 按钮
 */
- (UIBarButtonItem*)sea_setRightItemWithTitle:(NSString*) title action:(SEL) action;

/**
 设置导航栏右边按钮
 
 @param image 按钮图标
 @param action 点击方法
 @return 按钮
 */
- (UIBarButtonItem*)sea_setRightItemWithImage:(UIImage*) image action:(SEL) action;

/**
 设置导航栏右边按钮
 
 @param systemItem 系统按钮图标
 @param action 点击方法
 @return 按钮
 */
- (UIBarButtonItem*)sea_setRightItemWithSystemItem:(UIBarButtonSystemItem) systemItem action:(SEL) action;

/**
 设置导航栏右边按钮
 
 @param customView 自定义视图
 @return 按钮
 */
- (UIBarButtonItem*)sea_setRightItemWithCustomView:(UIView*) customView;


/**设置导航条样式 默认不透明
 *@param backgroundColor 背景颜色
 *@param titleColor 标题颜色
 *@param font 标题字体
 *@param tintColor 着色
 */
- (void)sea_setNavigationBarWithBackgroundColor:(UIColor*) backgroundColor titleColor:(UIColor*) titleColor titleFont:(UIFont*) font tintColor:(UIColor*) tintColor;

/**设置默认导航栏样式
 */
- (void)sea_setDefaultNavigationBar;

/**创建导航栏并返回 UINavigationController
 */
- (UINavigationController*)sea_createWithNavigationController;

#pragma mark- alert

/**提示信息
 *@param msg 要提示的信息
 */
- (void)sea_alertMsg:(NSString*) msg;

/**网络不佳的提示信息
 *@param msg 要提示的信息
 */
- (void)sea_alerBadNetworkMsg:(NSString*) msg;


#pragma mark- Class Method

+ (UIBarButtonItem*)sea_barItemWithImage:(UIImage*) image target:(id) target action:(SEL) action;
+ (UIBarButtonItem*)sea_barItemWithTitle:(NSString*) title target:(id) target action:(SEL) action;
+ (UIBarButtonItem*)sea_barItemWithCustomView:(UIView*) customView;
+ (UIBarButtonItem*)sea_barItemWithSystemItem:(UIBarButtonSystemItem) systemItem target:(id) target action:(SEL) action;

/**设置导航条样式 默认不透明
 *@param navigationBar 要设置的导航栏
 *@param backgroundColor 背景颜色
 *@param titleColor 标题颜色
 *@param font 标题字体
 *@param tintColor 着色，如返回按钮颜色
 */
+ (void)setupNavigationBar:(UINavigationBar*)navigationBar withBackgroundColor:(UIColor*) backgroundColor titleColor:(UIColor*) titleColor titleFont:(UIFont*) font tintColor:(UIColor*) tintColor;

@end
