//
//  UIViewController+Utilities.m
//  Sea
//
//  Created by 罗海雄 on 15/9/14.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "SeaNavigationController.h"
#import "UIView+SeaToast.h"
#import "UIView+SeaLoading.h"
#import "SeaTabBar.h"
#import "SeaTabBarController.h"
#import <objc/runtime.h>
#import "SeaBasic.h"
#import "UIView+Utils.h"
#import "UINavigationItem+Utils.h"
#import "SeaNetworkActivityView.h"
#import "UIColor+Utils.h"
#import "UIView+SeaEmptyView.h"

/**导航条按钮位置
 */
typedef NS_ENUM(NSInteger, SeaNavigationItemPosition)
{
    SeaNavigationItemPositionLeft = 0, //左边
    SeaNavigationItemPositionRight = 1 //右边
};

/**objc rutime 属性，key **/

/**状态栏隐藏
 */
static char SeaStatusBarHiddenKey;

/**按钮标题颜色
 */
static char SeaIconTintColorKey;

/**自定义tabBar
 */
static char SeaTabBarControllerKey;

/**是否隐藏
 */
static char SeaHideTabBarKey;

/**过渡代理
 */
static char SeaTransitioningDelegateKey;

@implementation UIViewController (Utils)

#pragma mark- loading

- (void)setSea_showPageLoading:(BOOL)sea_showPageLoading
{
    [self.view setSea_showPageLoading:sea_showPageLoading];
}

- (BOOL)sea_showPageLoading
{
    return [self.view sea_showPageLoading];
}

- (void)setSea_pageLoadingView:(UIView *)sea_pageLoadingView
{
    self.view.sea_pageLoadingView = sea_pageLoadingView;
}

- (UIView*)sea_pageLoadingView
{
    return self.view.sea_pageLoadingView;
}

- (void)setSea_showNetworkActivity:(BOOL)sea_showNetworkActivity
{
    [self.view setSea_showNetworkActivity:sea_showNetworkActivity];
}

- (BOOL)sea_showNetworkActivity
{
    return [self.view sea_showNetworkActivity];
}

- (void)setSea_networkActivity:(UIView *)sea_networkActivity
{
    self.view.sea_networkActivity = sea_networkActivity;
}

- (UIView*)sea_networkActivity
{
    return self.view.sea_networkActivity;
}

- (void)setSea_showFailPage:(BOOL)sea_showFailPage
{
    [self.view setSea_showFailPage:sea_showFailPage];
    if(sea_showFailPage){
        WeakSelf(self);
        self.view.sea_reloadDataHandler = ^(void){
            [weakSelf sea_reloadData];
        };
    }
}

- (BOOL)sea_showFailPage
{
    return [self.view sea_showFailPage];
}

- (void)setSea_failPageView:(UIView *)sea_failPageView
{
    self.view.sea_failPageView = sea_failPageView;
}

- (UIView*)sea_failPageView
{
    return self.view.sea_failPageView;
}

/**重新加载数据 默认不做任何事，子类可以重写该方法
 */
- (void)sea_reloadData{
    
}

#pragma mark- empty view

- (void)setSea_showEmptyView:(BOOL)sea_showEmptyView
{
    self.view.sea_showEmptyView = sea_showEmptyView;
}

- (BOOL)sea_showEmptyView
{
    return self.view.sea_showEmptyView;
}

- (SeaEmptyView*)sea_emptyView
{
    return self.view.sea_emptyView;
}

#pragma mark- property readonly

/**状态栏高度
 */
- (CGFloat)sea_statusBarHeight
{
    if([UIApplication sharedApplication].statusBarHidden)
    {
        return SeaStatusHeight;
    }
    else
    {
        return [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
}

/**导航栏高度
 */
- (CGFloat)sea_navigationBarHeight
{
    return self.navigationController.navigationBar.height;
}

/**选项卡高度
 */
- (CGFloat)sea_tabBarHeight
{
    if(self.sea_tabBarController)
    {
        return self.sea_tabBarController.tabBar.height;
    }
    else
    {
        return self.tabBarController.tabBar.height;
    }
}

- (CGFloat)sea_toolBarHeight
{
    return SeaToolBarHeight;
}

/**工具条高度
 */
- (CGFloat)toolBarHeight
{
    CGFloat height = self.navigationController.toolbar.height;
    
    return MAX(height, SeaToolBarHeight);
}

/**自定义的导航栏
 */
- (SeaNavigationController*)sea_navigationController
{
    SeaNavigationController *nav = (SeaNavigationController*)self.navigationController;
    
    if([nav isKindOfClass:[SeaNavigationController class]])
    {
        return nav;
    }
    
    return nil;
}

#pragma mark- property setup

/**导航栏按钮或按钮字体颜色
 */
- (void)setSea_iconTintColor:(UIColor *)sea_iconTintColor
{
    if(![self.sea_iconTintColor isEqualToColor:sea_iconTintColor])
    {
        objc_setAssociatedObject(self, &SeaIconTintColorKey, sea_iconTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if(!sea_iconTintColor)
        {
            sea_iconTintColor = [SeaBasicInitialization sea_tintColor];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.navigationController.navigationBar.titleTextAttributes];
        [dic setObject:sea_iconTintColor forKey:NSForegroundColorAttributeName];
        self.navigationController.navigationBar.titleTextAttributes = dic;
        self.navigationController.navigationBar.tintColor = sea_iconTintColor;
    }
}

- (UIColor*)sea_iconTintColor
{
    UIColor *color = objc_getAssociatedObject(self, &SeaIconTintColorKey);
    if(color == nil)
        color = [SeaBasicInitialization sea_tintColor];
    
    return color;
}

/**用于 present ViewController 的 statusBar 隐藏状态控制 default is 'NO' ，不隐藏
 */
- (void)setSea_statusBarHidden:(BOOL)sea_statusBarHidden
{
    if(self.sea_statusBarHeight != sea_statusBarHidden){
        objc_setAssociatedObject(self, &SeaStatusBarHiddenKey,@(sea_statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (BOOL)sea_statusBarHidden
{
    return [objc_getAssociatedObject(self, &SeaStatusBarHiddenKey) boolValue];
}

//设置返回按钮
- (void)setSea_showBackItem:(BOOL)sea_showBackItem
{
    if(sea_showBackItem){
        UIImage *image = [UIImage imageNamed:@"back_icon"];
        ///ios7 的 imageAssets 不支持 Template
        if(image.renderingMode != UIImageRenderingModeAlwaysTemplate){
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 5.0, 25)];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeLeft;
        imageView.userInteractionEnabled = YES;
        imageView.tintColor = self.sea_iconTintColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sea_back)];
        [imageView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBack:)];
        longPress.minimumPressDuration = 1.0;
        [imageView addGestureRecognizer:longPress];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
        self.navigationItem.leftBarButtonItem = item;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = nil;
    }
}

- (BOOL)sea_showBackItem
{
    return [self.navigationItem.leftBarButtonItem.customView isKindOfClass:[UIImageView class]];
}


#pragma mark- triansition

- (void)setSea_transitioningDelegate:(id<UIViewControllerTransitioningDelegate>)sea_transitioningDelegate
{
#if SeaDebug
    NSAssert(![sea_transitioningDelegate isEqual:self], @"sea_transitioningDelegate 不能设置为self，如果要设置成self，使用 transitioningDelegate");
#endif
    objc_setAssociatedObject(self, &SeaTransitioningDelegateKey, sea_transitioningDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.transitioningDelegate = sea_transitioningDelegate;
}

- (id<UIViewControllerTransitioningDelegate>)sea_transitioningDelegate
{
    return objc_getAssociatedObject(self, &SeaTransitioningDelegateKey);
}

#pragma mark- back

//返回方法
- (void)sea_back
{
    [self sea_backAnimated:YES];
}

/**返回方法 支持present和push出来的视图
 *@param flag 是否动画
 */
- (void)sea_backAnimated:(BOOL) flag
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    if(self.navigationController.viewControllers.count == 1)
    {
        [self dismissViewControllerAnimated:flag completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:flag];
    }
}

/**返回根视图，支持present和push出来的视图
 *@param flag 是否动画
 */
- (void)sea_backToRootViewControllerAnimated:(BOOL) flag
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];

    ///是present出来的
    if(self.presentingViewController)
    {
        UIViewController *root = [self sea_rootPresentingViewController];
        if(root.navigationController.viewControllers.count > 1)
        {
            ///dismiss 之后还有 pop,所以dismiss无动画
            [root dismissViewControllerAnimated:NO completion:nil];
            [root.navigationController popToRootViewControllerAnimated:flag];
        }
        else
        {
            [root dismissViewControllerAnimated:flag completion:nil];
        }
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:flag];
    }
}

/**获取最上层的 presentedViewController
 */
- (UIViewController*)sea_topestPresentedViewController
{
    if(self.presentedViewController)
    {
        return [self.presentedViewController sea_topestPresentedViewController];
    }
    else
    {
        return self;
    }
}

/**获取最底层的 presentingViewController
 */
- (UIViewController*)sea_rootPresentingViewController
{
    if(self.presentingViewController)
    {
        return [self.presentingViewController sea_rootPresentingViewController];
    }
    else
    {
        return self;
    }
}

//长按返回第一个视图
- (void)longPressBack:(UILongPressGestureRecognizer*) longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        [self sea_backToRootViewControllerAnimated:YES];
    }
}


#pragma mark- navigation

- (void)setNavigationBarItem:(UIBarButtonItem*) item posiiton:(SeaNavigationItemPosition) position
{
    switch (position) {
        case SeaNavigationItemPositionLeft :
            self.navigationItem.leftBarButtonItem = item;
            break;
        case SeaNavigationItemPositionRight :
            self.navigationItem.rightBarButtonItem = item;
            break;
        default:
            break;
    }
}

- (UIBarButtonItem*)sea_setLeftItemWithTitle:(NSString*) title action:(SEL) action
{
    UIBarButtonItem *item = [[self class] sea_barItemWithTitle:title target:self action:action];
    [self setNavigationBarItem:item posiiton:SeaNavigationItemPositionLeft];
    
    return item;
}

- (UIBarButtonItem*)sea_setLeftItemWithImage:(UIImage*) image action:(SEL) action
{
    UIBarButtonItem *item = [[self class] sea_barItemWithImage:image target:self action:action];
    [self setNavigationBarItem:item posiiton:SeaNavigationItemPositionLeft];
    
    return item;
}

- (UIBarButtonItem*)sea_setLeftItemWithSystemItem:(UIBarButtonSystemItem) systemItem action:(SEL) action
{
    UIBarButtonItem *item = [[self class] sea_barItemWithSystemItem:systemItem target:self action:action];
    [self setNavigationBarItem:item posiiton:SeaNavigationItemPositionLeft];
    
    return item;
}

- (UIBarButtonItem*)sea_setLeftItemWithCustomView:(UIView*) customView
{
    UIBarButtonItem *item = [[self class] sea_barItemWithCustomView:customView];
    [self setNavigationBarItem:item posiiton:SeaNavigationItemPositionLeft];
    
    return item;
}

- (UIBarButtonItem*)sea_setRightItemWithTitle:(NSString*) title action:(SEL) action
{
    UIBarButtonItem *item = [[self class] sea_barItemWithTitle:title target:self action:action];
    [self setNavigationBarItem:item posiiton:SeaNavigationItemPositionRight];
    
    return item;
}

- (UIBarButtonItem*)sea_setRightItemWithImage:(UIImage*) image action:(SEL) action
{
    UIBarButtonItem *item = [[self class] sea_barItemWithImage:image target:self action:action];
    [self setNavigationBarItem:item posiiton:SeaNavigationItemPositionRight];
    
    return item;
}

- (UIBarButtonItem*)sea_setRightItemWithSystemItem:(UIBarButtonSystemItem) systemItem action:(SEL) action
{
    UIBarButtonItem *item = [[self class] sea_barItemWithSystemItem:systemItem target:self action:action];
    [self setNavigationBarItem:item posiiton:SeaNavigationItemPositionRight];
    
    return item;
}

- (UIBarButtonItem*)sea_setRightItemWithCustomView:(UIView*) customView
{
    UIBarButtonItem *item = [[self class] sea_barItemWithCustomView:customView];
    [self setNavigationBarItem:item posiiton:SeaNavigationItemPositionRight];
    
    return item;
}

- (void)sea_setNavigationBarWithBackgroundColor:(UIColor*) backgroundColor titleColor:(UIColor*) titleColor titleFont:(UIFont*) font tintColor:(UIColor*) tintColor
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [[self class] setupNavigationBar:navigationBar withBackgroundColor:backgroundColor titleColor:titleColor titleFont:font tintColor:tintColor];
}

- (void)sea_setDefaultNavigationBar
{
    //设置默认导航条
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
   // navigationBar.translucent = NO;
    [UIViewController setupNavigationBar:navigationBar withBackgroundColor:SeaNavigationBarBackgroundColor titleColor:SeaNavigationBarTitleColor titleFont:[UIFont fontWithName:SeaMainFontName size:17.0] tintColor:SeaTintColor];
}

/**创建导航栏并返回 UINavigationController
 */
- (UINavigationController*)sea_createWithNavigationController
{
    SeaNavigationController *nav = [[SeaNavigationController alloc] initWithRootViewController:self];
    return nav;
}



#pragma mark- alert

/**网络请求指示器信息
 *@param msg 提示的信息
 */
- (void)setShowNetworkActivityWithMsg:(NSString*) msg
{
    self.sea_showNetworkActivity = YES;
    if([self.sea_networkActivity isKindOfClass:[SeaNetworkActivityView class]]){
        SeaNetworkActivityView *view = (SeaNetworkActivityView*)self.sea_networkActivity;
        view.msg = msg;
    }
}

/**提示信息
 *@param msg 要提示的信息
 */
- (void)sea_alertMsg:(NSString*) msg
{
    [self.view sea_alertMessage:msg];
}


/**网络不佳的提示信息
 *@param msg 要提示的信息
 */
- (void)sea_alerBadNetworkMsg:(NSString*) msg
{
    [self sea_alertMsg:[NSString stringWithFormat:@"%@\n%@", SeaAlertMsgWhenBadNetwork, msg]];
}

#pragma mark- navigation

- (void)sea_pushViewController:(UIViewController*) viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark- sea_tabBar

/**关联的选项卡 default is 'nil'
 */
- (void)setSea_tabBarController:(SeaTabBarController *) tabBarController
{
    objc_setAssociatedObject(self, &SeaTabBarControllerKey, tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

- (SeaTabBarController*)sea_tabBarController
{
    return objc_getAssociatedObject(self, &SeaTabBarControllerKey);
}

/**当viewWillAppear时是否隐藏选项卡 default is 'YES'
 */
- (void)setSea_hideTabBar:(BOOL) hideTabBar
{
    objc_setAssociatedObject(self, &SeaHideTabBarKey, @(hideTabBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_hideTabBar
{
    return [objc_getAssociatedObject(self, &SeaHideTabBarKey) boolValue];
}

#pragma mark- Class Method

+ (UIBarButtonItem*)sea_barItemWithImage:(UIImage*) image target:(id) target action:(SEL) action
{
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
}

+ (UIBarButtonItem*)sea_barItemWithTitle:(NSString*) title target:(id) target action:(SEL) action
{
    return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

+ (UIBarButtonItem*)sea_barItemWithCustomView:(UIView*) customView
{
    return [[UIBarButtonItem alloc] initWithCustomView:customView];
}

+ (UIBarButtonItem*)sea_barItemWithSystemItem:(UIBarButtonSystemItem) systemItem target:(id) target action:(SEL) action
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:action];
}

/**设置导航条样式 默认不透明
 *@param navigationBar 要设置的导航栏
 *@param backgroundColor 背景颜色
 *@param titleColor 标题颜色
 *@param font 标题字体
 *@param tintColor 着色，如返回按钮颜色
 */
+ (void)setupNavigationBar:(UINavigationBar*)navigationBar withBackgroundColor:(UIColor*) backgroundColor titleColor:(UIColor*) titleColor titleFont:(UIFont*) font tintColor:(UIColor*) tintColor
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if(!titleColor)
        titleColor = SeaNavigationBarTitleColor;
    if(!font)
        font = SeaNavigationBarTitleFont;
    if(!tintColor)
        tintColor = SeaTintColor;

    [dic setObject:titleColor forKey:NSForegroundColorAttributeName];
    [dic setObject:font forKey:NSFontAttributeName];

    [navigationBar setTitleTextAttributes:dic];

    navigationBar.tintColor = tintColor;

    if(backgroundColor)
    {
        navigationBar.barTintColor = backgroundColor;
       // UIImage *image = [UIImage imageWithColor:backgroundColor size:CGSizeMake(1,1)];
      //  [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
       // navigationBar.shadowImage = [UIImage new];
    }
}


@end
