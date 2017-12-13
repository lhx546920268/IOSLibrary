//
//  UIViewController+Utilities.h
//  Sea
//
//  Created by 罗海雄 on 15/9/14.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaButton.h"

@class SeaFailPageView,
SeaPageLoadingView,
SeaNavigationController,
SeaTabBarController,
SeaNetworkActivityView,
SeaToast,
SeaEmptyView;


/**导航条按钮位置
 */
typedef NS_ENUM(NSInteger, SeaNavigationItemPosition)
{
    SeaNavigationItemPositionLeft = 0, //左边
    SeaNavigationItemPositionRight = 1 //右边
};

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
@property(nonatomic, readonly) UIView *sea_pageLoadingView;

///显示菊花
@property(nonatomic, assign) BOOL sea_showNetworkActivity;

///菊花 默认SeaNetworkActivityView
@property(nonatomic, readonly) UIView *sea_networkActivity;

///显示加载失败页面
@property(nonatomic, assign) BOOL sea_showFailPage;

///失败页面 默认 SeaFailPageView
@property(nonatomic, readonly) UIView *sea_failPageView;

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

/**左边导航栏图标 返回非 UIBarButtonSystemItemFixedSpace类型的
 */
@property(nonatomic,readonly) UIBarButtonItem *sea_leftBarButtonItem;

/**右边导航栏图标 返回非 UIBarButtonSystemItemFixedSpace类型的
 */
@property(nonatomic,readonly) UIBarButtonItem *sea_rightBarButtonItem;


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

/**获取导航栏按钮 标题和图标只需设置一个
 *@param title 标题
 *@param icon 按钮图标
 *@param action 按钮点击方法
 */
- (UIBarButtonItem*)barButtonItemWithTitle:(NSString*) title icon:(UIImage*) icon action:(SEL) action;

/**获取系统导航栏按钮
 *@param style 系统barButtonItem 样式
 *@param action 按钮点击方法
 *@return 一个根据style 初始化的 UIBarButtonItem 对象，颜色是 iconTintColor
 */
- (UIBarButtonItem*)systemBarButtonItemWithStyle:(UIBarButtonSystemItem) style action:(SEL) action;

/**获取自定义按钮的导航栏按钮
 *@param type 自定义按钮类型
 *@param action 按钮点击方法
 *@return 一个初始化的 UIBarButtonItem
 */
- (UIBarButtonItem*)itemWithButtonWithType:(SeaButtonType) type action:(SEL) action;

/**设置导航条左边按钮 标题和图标只需设置一个
 *@param title 标题
 *@param icon 按钮图标
 *@param action 按钮点击方法
 *@param position 按钮位置
 */
- (void)setBarItemsWithTitle:(NSString*) title icon:(UIImage*) icon action:(SEL) action position:(SeaNavigationItemPosition) position;

/**通过系统barButtonItem 设置导航条左边按钮
 *@param style 系统barButtonItem 样式
 *@param action 按钮点击方法
 *@param position 按钮位置
 */
- (void)setBarItemsWithStyle:(UIBarButtonSystemItem) style action:(SEL) action position:(SeaNavigationItemPosition) position;

/**通过自定的按钮类型 设置导航条左边按钮
 *@param buttonType 自定义按钮类型
 *@param action 按钮点击方法
 *@param position 按钮位置
 */
- (void)setBarItemWithButtonType:(SeaButtonType) buttonType action:(SEL) action position:(SeaNavigationItemPosition) position;

/**通过自定义视图 设置导航条右边按钮
 *@param customView 自定义视图
 */
- (void)setBarItemWithCustomView:(UIView*) customView position:(SeaNavigationItemPosition) position;

/**设置dismiss 按钮
 *@param position 按钮位置
 */
- (void)setDismissBarItemWithPosition:(SeaNavigationItemPosition) position;

///设置item
- (void)setBarItem:(UIBarButtonItem*) item position:(SeaNavigationItemPosition) position;

///设置items
- (void)setBarItems:(NSArray*) items position:(SeaNavigationItemPosition) position;

/**设置导航条样式 默认不透明
 *@param backgroundColor 背景颜色
 *@param titleColor 标题颜色
 *@param font 标题字体
 */
- (void)setupNavigationBarWithBackgroundColor:(UIColor*) backgroundColor titleColor:(UIColor*) titleColor titleFont:(UIFont*) font;

/**设置默认导航栏样式
 */
- (void)setupDefaultNavigationBar;

/**通过添加navigationBar展现
 *@param viewController 用于 presentViewController:self
 *@param animated 是否动画展示
 *@param completion 视图出现完成回调
 */
- (void)showInViewController:(UIViewController*) viewController animated:(BOOL) animated completion:(void(^)(void)) completion;

/**直接展现 没有导航条
 *@param viewController 用于 presentViewController:self
 *@param animated 是否动画展示
 *@param completion 视图出现完成回调
 */
- (void)showInViewControllerWithoutNavigationBar:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

/**创建导航栏并返回 UINavigationController
 */
- (UINavigationController*)createdInNavigationController;


/**重新加载数据 默认不做任何事，子类可以重写该方法
 */
- (void)reloadDataFromNetwork;

#pragma mark- alert

/**网络请求指示器信息
 *@param msg 提示的信息
 */
- (void)setShowNetworkActivityWithMsg:(NSString*) msg;

/**提示信息
 *@param msg 要提示的信息
 */
- (void)alertMsg:(NSString*) msg;

/**网络不佳的提示信息
 *@param msg 要提示的信息
 */
- (void)alerBadNetworkMsg:(NSString*) msg;


#pragma mark- Class Method

/**获取导航栏按钮 标题和图标只需设置一个
 *@param title 标题
 *@param icon 按钮图标
 *@param target 方法执行者
 *@param action 按钮点击方法
 *@param tintColor 主题颜色
 */
+ (UIBarButtonItem*)barButtonItemWithTitle:(NSString*) title icon:(UIImage*) icon target:(id) target action:(SEL) action tintColor:(UIColor*) tintColor;

/**设置导航条样式 默认不透明
 *@param navigationBar 要设置的导航栏
 *@param backgroundColor 背景颜色
 *@param titleColor 标题颜色
 *@param font 标题字体
 *@param tintColor 着色，如返回按钮颜色
 */
+ (void)setupNavigationBar:(UINavigationBar*)navigationBar withBackgroundColor:(UIColor*) backgroundColor titleColor:(UIColor*) titleColor titleFont:(UIFont*) font tintColor:(UIColor*) tintColor;

@end
