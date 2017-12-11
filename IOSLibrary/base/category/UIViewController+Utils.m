//
//  UIViewController+Utilities.m
//  Sea
//
//  Created by 罗海雄 on 15/9/14.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "Sea"
#import "SeaNavigationController.h"
#import "SeaBadNetworkRemindView.h"
#import "SeaNetworkActivityView.h"
#import "SeaToast.h"
#import "SeaTabBar.h"
#import "SeaTabBarController.h"
#import <objc/runtime.h>
#import "SeaTextInsetLabel.h"
#import "SeaBasic.h"

#define _barButtonItemSpace_ 6.0


/**objc rutime 属性，key **/

/**状态栏隐藏
 */
static char SeastatusBarHiddenKey;

/**是否网络加载指示器
 */
static char SeaShowNetworkActivityKey;

/**网络加载指示器
 */
static char SeaNetworkActivityViewKey;

/**是否网络请求
 */
static char SeaRequestingKey;

/**是否正在全屏加载
 */
static char SeaLoadingKey;

/**全屏加载视图
 */
static char SeaLoadingIndicatorKey;

/**没有数据
 */
static char SeaHasNoMsgViewkey;

/**按钮标题颜色
 */
static char SeaIconTintColorKey;

/**重新加载视图
 */
static char SeaBadNetworkRemindViewKey;

/**提示信息框
 */
static char SeaToastKey;

/**自定义tabBar
 */
static char Sea_TabBarControllerKey;

/**是否隐藏
 */
static char SeaHideTabBarKey;

/**过渡代理
 */
static char SeaTransitioningDelegateKey;

@implementation UIViewController (Utils)

#pragma mark- property readonly

/**状态栏高度
 */
- (CGFloat)statusBarHeight
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
    if(self.navigationController.navigationBarHidden)
    {
        return 44.0;
    }
    else
    {
        return self.navigationController.navigationBar.height;
    }
}

/**选项卡高度
 */
- (CGFloat)tabBarHeight
{
    if(self.Sea_TabBarController)
    {
        return self.Sea_TabBarController.tabBar.height;
    }
    else
    {
        return self.tabBarController.tabBar.height;
    }
}

/**工具条高度
 */
- (CGFloat)toolBarHeight
{
    CGFloat height = self.navigationController.toolbar.height;
    
    return MAX(height, SeaToolBarHeight);
}

//获取可显示内容的高度
- (CGFloat)contentHeight
{
    CGFloat contentHeight = SeaScreenHeight;
    
    BOOL existNav = self.navigationController.navigationBar && !self.navigationController.navigationBar.translucent && !self.navigationController.navigationBarHidden;
    
    if(existNav)
    {
        contentHeight -= self.sea_navigationBarHeight;
    }
    
    if(self.tabBarController && !self.tabBarController.tabBar.hidden && !self.hidesBottomBarWhenPushed)
    {
        contentHeight -= self.tabBarController.tabBar.height;
    }
    
    if(self.Sea_TabBarController && !self.Sea_TabBarController.tabBar.hidden && !self.hideTabBar)
    {
        contentHeight -= self.Sea_TabBarController.tabBar.height;
    }
    
    if(!self.navigationController.toolbar.hidden && !self.hidesBottomBarWhenPushed && !self.navigationController.toolbar.translucent)
    {
        contentHeight -= self.toolBarHeight;
    }
    //
    if(![UIApplication sharedApplication].statusBarHidden && !self.navigationController.navigationBar.translucent)
    {
        contentHeight -= self.statusBarHeight;
    }
    
    return contentHeight;
}

/**内容起始y 会判断导航栏是否透明
 */
- (CGFloat)contentY
{
    CGFloat y = 0;
    if(self.navigationController.navigationBar.translucent)
    {
        y += self.sea_navigationBarHeight + self.statusBarHeight;
    }
    
    return y;
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
- (void)setIconTintColor:(UIColor *)iconTintColor
{
    if(![self.iconTintColor isEqualToColor:iconTintColor])
    {
        objc_setAssociatedObject(self, &SeaIconTintColorKey, iconTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if(iconTintColor)
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.navigationController.navigationBar.titleTextAttributes];
            [dic setObject:iconTintColor forKey:NSForegroundColorAttributeName];
            self.navigationController.navigationBar.titleTextAttributes = dic;
            self.navigationController.navigationBar.tintColor = iconTintColor;
            
            UIBarButtonItem *item = self.leftBarButtonItem;
            item.tintColor = iconTintColor;
            item.customView.tintColor = iconTintColor;
            item = self.rightBarButtonItem;
            item.tintColor = iconTintColor;
            item.customView.tintColor = iconTintColor;
        }
    }
}

- (UIColor*)iconTintColor
{
    UIColor *color = objc_getAssociatedObject(self, &SeaIconTintColorKey);
    if(color == nil)
        color = [SeaBasicInitialization sea_tintColor];
    
    return color;
}

/**用于 present ViewController 的 statusBar 隐藏状态控制 default is 'NO' ，不隐藏
 */
- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    if(self.statusBarHidden != statusBarHidden)
    {
        objc_setAssociatedObject(self, &SeastatusBarHiddenKey, [NSNumber numberWithBool:statusBarHidden], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (BOOL)statusBarHidden
{
    return [objc_getAssociatedObject(self, &SeastatusBarHiddenKey) boolValue];
}

//设置返回按钮
- (void)setBackItem:(BOOL)backItem
{
    if(backItem)
    {
        //        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""  style:UIBarButtonItemStylePlain  target:self  action:@selector(back)];
        //        self.navigationItem.backBarButtonItem = backButton;

        UIImage *image = [UIImage imageNamed:@"back_icon"];
        ///ios7 的 imageAssets 不支持 Template
        if(image.renderingMode != UIImageRenderingModeAlwaysTemplate)
        {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 5.0, 25)];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeLeft;
        imageView.userInteractionEnabled = YES;
        imageView.tintColor = self.iconTintColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
        [imageView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBack:)];
        longPress.minimumPressDuration = 1.0;
        [imageView addGestureRecognizer:longPress];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
        [self setBarItem:item position:SeaNavigationItemPositionLeft];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = nil;
    }
}

- (BOOL)backItem
{
    return [self.leftBarButtonItem.customView isKindOfClass:[UIImageView class]];
}

//设置网络活动指示
- (void)setShowNetworkActivity:(BOOL)showNetworkActivity
{
    if(self.showNetworkActivity != showNetworkActivity)
    {
        objc_setAssociatedObject(self, &SeaShowNetworkActivityKey, [NSNumber numberWithBool:showNetworkActivity], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if(showNetworkActivity)
        {
            if(!self.networkActivityView)
            {
                CGFloat width = SeaNetworkActivityViewWidth;
                CGFloat height = SeaNetworkActivityViewHeight;
                SeaNetworkActivityView *view = [[SeaNetworkActivityView alloc] initWithFrame:CGRectMake((SeaScreenWidth - width) / 2.0, ([self contentHeight] - height) / 2.0, width, height)];
                [self.view addSubview:view];
                self.networkActivityView = view;
            }
            
            [self.view bringSubviewToFront:self.networkActivityView];
            self.networkActivityView.msg = @"请稍后...";
            self.networkActivityView.hidden = NO;
        }
        else
        {
            self.networkActivityView.hidden = YES;
        }
    }
}

- (BOOL)showNetworkActivity
{
    return [objc_getAssociatedObject(self, &SeaShowNetworkActivityKey) boolValue];
}

//设置网络加载指示器
- (void)setNetworkActivityView:(SeaNetworkActivityView *)networkActivityView
{
    objc_setAssociatedObject(self, &SeaNetworkActivityViewKey, networkActivityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SeaNetworkActivityView*)networkActivityView
{
    return objc_getAssociatedObject(self, &SeaNetworkActivityViewKey);
}

//设置网络请求
- (void)setRequesting:(BOOL)requesting
{
    if(self.requesting != requesting)
    {
        objc_setAssociatedObject(self, &SeaRequestingKey, [NSNumber numberWithBool:requesting], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if(!requesting)
        {
            self.showNetworkActivity = NO;
        }
        self.view.userInteractionEnabled = !requesting;
    }
}

- (BOOL)requesting
{
    return [objc_getAssociatedObject(self, &SeaRequestingKey) boolValue];
}

- (void)setLoading:(BOOL)loading
{
    if(self.loading != loading)
    {
        objc_setAssociatedObject(self, &SeaLoadingKey, [NSNumber numberWithBool:loading], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if(loading)
        {
            [self.badNetworkRemindView removeFromSuperview];
            self.badNetworkRemindView = nil;
            
            //创建载入视图
            if(!self.loadingIndicator)
            {
                
                // CGFloat y = ([self contentHeight] - _SeaLoadingIndicatorHeight_) / 2.0;
//                SeaLoadingIndicator *indicator = [[SeaLoadingIndicator alloc] initWithFrame:CGRectMake(0, 0, SeaScreenWidth, [self contentHeight] - self.view.top) title:@"正在载入..."];
                SeaPageLoadingView *indicator = [[SeaLoadingIndicator alloc] initWithFrame:CGRectMake(0, 0, SeaScreenWidth, [self contentHeight]) title:@"正在载入..."];
                [self.view addSubview:indicator];
                self.loadingIndicator = indicator;
            }
            
            self.loadingIndicator.loading = YES;
            [self.view bringSubviewToFront:self.loadingIndicator];
        }
        else
        {
            self.loadingIndicator.loading = NO;
            [self.loadingIndicator removeFromSuperview];
            self.loadingIndicator = nil;
        }
    }
}

- (BOOL)loading
{
    return [objc_getAssociatedObject(self, &SeaLoadingKey) boolValue];
}

//全屏载入视图
- (void)setLoadingIndicator:(SeaPageLoadingView *)loadingIndicator
{
    objc_setAssociatedObject(self, &SeaLoadingIndicatorKey, loadingIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SeaPageLoadingView*)loadingIndicator
{
    return objc_getAssociatedObject(self, &SeaLoadingIndicatorKey);
}

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

#pragma mark- loadView

/**显示没有数据时的视图
 *@param hidden 是否显示
 *@param msg 提示的信息
 */
- (void)setHasNoMsgViewHidden:(BOOL) hidden msg:(NSString*) msg
{
    if(!hidden && !self.hasNoMsgView)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SeaScreenWidth, self.view.height)];
        label.backgroundColor = self.view.backgroundColor;
        label.font = [UIFont fontWithName:SeaMainFontName size:18.0];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        
        self.hasNoMsgView = label;
        [self.view addSubview:self.hasNoMsgView];
    }

    if([self.hasNoMsgView isKindOfClass:[UILabel class]])
    {
        UILabel *label = (UILabel*)self.hasNoMsgView;
        label.text = msg;
    }

    self.hasNoMsgView.hidden = hidden;
    [self.hasNoMsgView.superview bringSubviewToFront:self.hasNoMsgView];
}

/**设置没有信息时的视图
 */
- (void)setHasNoMsgView:(UIView *)hasNoMsgView
{
    objc_setAssociatedObject(self, &SeaHasNoMsgViewkey, hasNoMsgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)hasNoMsgView
{
    return objc_getAssociatedObject(self, &SeaHasNoMsgViewkey);
}

#pragma mark- back

//返回方法
- (void)back
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    if(self.navigationController.viewControllers.count == 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**返回根视图，支持present和push出来的视图
 *@param flag 是否动画
 */
- (void)backToRootViewControllerWithAnimated:(BOOL) flag
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
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        [self backToRootViewControllerWithAnimated:YES];
    }
}

//dismss
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- navigation

/**左边导航栏图标 返回非 UIBarButtonSystemItemFixedSpace类型的
 */
- (UIBarButtonItem*)leftBarButtonItem
{
    if(self.navigationItem.leftBarButtonItems.count > 0)
    {
        for(UIBarButtonItem *item in self.navigationItem.leftBarButtonItems)
        {
            if(item.width == 0)
            {
                return item;
            }
        }
    }
    
    return self.navigationItem.leftBarButtonItem;
}

/**右边导航栏图标 返回非 UIBarButtonSystemItemFixedSpace类型的
 */
- (UIBarButtonItem*)rightBarButtonItem
{
    if(self.navigationItem.rightBarButtonItems.count > 0)
    {
        for(UIBarButtonItem *item in self.navigationItem.rightBarButtonItems)
        {
            if(item.width == 0)
            {
                return item;
            }
        }
    }
    
    return self.navigationItem.rightBarButtonItem;
}

/**获取导航栏按钮 标题和图标只需设置一个
 *@param title 标题
 *@param icon 按钮图标
 *@param action 按钮点击方法
 */
- (UIBarButtonItem*)barButtonItemWithTitle:(NSString*) title icon:(UIImage*) icon action:(SEL) action
{
    return [[self class] barButtonItemWithTitle:title icon:icon target:self action:action tintColor:self.iconTintColor];
}

/**获取系统导航栏按钮
 *@param style 系统barButtonItem 样式
 *@param action 按钮点击方法
 *@return 一个根据style 初始化的 UIBarButtonItem 对象，颜色是 iconTintColor
 */
- (UIBarButtonItem*)systemBarButtonItemWithStyle:(UIBarButtonSystemItem) style action:(SEL) action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:style target:self action:action];
    item.tintColor = self.iconTintColor;
    return item;
}

/**获取自定义按钮的导航栏按钮
 *@param type 自定义按钮类型
 *@param action 按钮点击方法
 *@return 一个初始化的 UIBarButtonItem
 */
- (UIBarButtonItem*)itemWithButtonWithType:(SeaButtonType) type action:(SEL) action
{
    SeaButton *button = [[SeaButton alloc] initWithFrame:CGRectMake(0, 0, 25, 35) buttonType:type];
    button.lineColor = self.iconTintColor;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

/**设置导航条左边按钮 标题和图标只需设置一个
 *@param title 标题
 *@param icon 按钮图标
 *@param action 按钮点击方法
 *@param position 按钮位置
 */
- (void)setBarItemsWithTitle:(NSString*) title icon:(UIImage*) icon action:(SEL) action position:(SeaNavigationItemPosition) position
{
    UIBarButtonItem *item = [self barButtonItemWithTitle:title icon:icon action:action];
    [self setBarItem:item position:position];
}

/**通过系统barButtonItem 设置导航条左边按钮
 *@param style 系统barButtonItem 样式
 *@param action 按钮点击方法
 *@param position 按钮位置
 */
- (void)setBarItemsWithStyle:(UIBarButtonSystemItem) style action:(SEL) action position:(SeaNavigationItemPosition) position
{
    [self setBarItem:[self systemBarButtonItemWithStyle:style action:action] position:position];
}

/**通过自定的按钮类型 设置导航条左边按钮
 *@param buttonType 自定义按钮类型
 *@param action 按钮点击方法
 *@param position 按钮位置
 */
- (void)setBarItemWithButtonType:(SeaButtonType) buttonType action:(SEL) action position:(SeaNavigationItemPosition) position
{
    [self setBarItem:[self itemWithButtonWithType:buttonType action:action] position:position];
}

/**通过自定义视图 设置导航条右边按钮
 *@param customView 自定义视图
 */
- (void)setBarItemWithCustomView:(UIView*) customView position:(SeaNavigationItemPosition) position
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customView];
    [self setBarItem:item position:position];
}

///设置item
- (void)setBarItem:(UIBarButtonItem*) item position:(SeaNavigationItemPosition) position
{
    item.tintColor = self.iconTintColor;
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem1.width = -5.0;
    
    UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem2.width = 10.0;

    switch (position)
    {
        case SeaNavigationItemPositionLeft :
        {
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceItem1, item, spaceItem2,nil];
        }
            break;
        case SeaNavigationItemPositionRight :
        {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem1, item, spaceItem2, nil];
        }
            break;
        default:
            break;
    }
}

///设置items
- (void)setBarItems:(NSArray*) items position:(SeaNavigationItemPosition) position
{
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem1.width = -5.0;
    
    UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem2.width = 10.0;
    
    NSMutableArray *items2 = [NSMutableArray arrayWithArray:items];
    [items2 insertObject:spaceItem1 atIndex:0];
    [items2 addObject:spaceItem2];
    
    switch (position)
    {
        case SeaNavigationItemPositionLeft :
        {
            self.navigationItem.leftBarButtonItems = items2;
        }
            break;
        case SeaNavigationItemPositionRight :
        {
            self.navigationItem.rightBarButtonItems = items2;
        }
            break;
        default:
            break;
    }
}

/**设置dismiss 按钮
 *@param position 按钮位置
 */
- (void)setDismissBarItemWithPosition:(SeaNavigationItemPosition) position
{
    SeaButton *button = [[SeaButton alloc] initWithFrame:CGRectMake(0, 0, 25, 35) buttonType:SeaButtonTypeClose];
    button.lineColor = self.iconTintColor;
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    switch (position)
    {
        case SeaNavigationItemPositionLeft :
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            break;
        case SeaNavigationItemPositionRight :
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            break;
        default:
            break;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    switch (position)
    {
        case SeaNavigationItemPositionLeft :
        {
            self.navigationItem.leftBarButtonItem = item;
        }
            break;
        case SeaNavigationItemPositionRight :
        {
            self.navigationItem.rightBarButtonItem = item;
        }
            break;
        default:
            break;
    }
}

/**设置导航条样式 默认不透明
 *@param backgroundColor 背景颜色
 *@param titleColor 标题颜色
 *@param font 标题字体
 */
- (void)setupNavigationBarWithBackgroundColor:(UIColor*) backgroundColor titleColor:(UIColor*) titleColor titleFont:(UIFont*) font
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [UIViewController setupNavigationBar:navigationBar withBackgroundColor:backgroundColor titleColor:titleColor titleFont:font];
}

- (void)setupDefaultNavigationBar
{
    //设置默认导航条
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
   // navigationBar.translucent = NO;
    [UIViewController setupNavigationBar:navigationBar withBackgroundColor:SeaNavigationBarBackgroundColor titleColor:SeaTintColor titleFont:[UIFont fontWithName:SeaMainFontName size:17.0]];
}

#pragma mark- 显示

/**通过添加navigationBar展现
 *@param viewController 用于 presentViewController:self
 *@param animated 是否动画展示
 *@param completion 视图出现完成回调
 */
- (void)showInViewController:(UIViewController*) viewController animated:(BOOL) animated completion:(void (^)(void))completion
{
    SeaNavigationController *nav = [[SeaNavigationController alloc] initWithRootViewController:self];
    
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [viewController presentViewController:nav animated:animated completion:completion];
}

/**直接展现 没有导航条
 *@param viewController 用于 presentViewController:self
 *@param animated 是否动画展示
 *@param completion 视图出现完成回调
 */
- (void)showInViewControllerWithoutNavigationBar:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    [viewController presentViewController:self animated:animated completion:completion];
}

/**创建导航栏并返回 UINavigationController
 */
- (UINavigationController*)createdInNavigationController
{
    SeaNavigationController *nav = [[SeaNavigationController alloc] initWithRootViewController:self];
    return nav;
}

#pragma mark- reload data

/**加载数据失败
 */
- (void)failToLoadData
{
    self.loading = NO;
    if(!self.badNetworkRemindView)
    {
        Sea *view = [[SeaBadNetworkRemindView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) message:nil];
        view.delegate = self;
        [self.view addSubview:view];
        self.badNetworkRemindView = view;
    }
    
    [self.view bringSubviewToFront:self.badNetworkRemindView];
    
    self.badNetworkRemindView.hidden = NO;
}

- (void)badNetworkRemindViewDidReloadData:(Sea *)view
{
    self.loading = YES;
    [self reloadDataFromNetwork];
}

- (BOOL)loadDidFail
{
    return self.badNetworkRemindView != nil && self.badNetworkRemindView.hidden != YES;
}

/**加载失败
 */
- (void)setBadNetworkRemindView:(Sea *)badNetworkRemindView
{
    objc_setAssociatedObject(self, &SeaBadNetworkRemindViewKey, badNetworkRemindView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (Sea*)badNetworkRemindView
{
    return objc_getAssociatedObject(self, &SeaBadNetworkRemindViewKey);
}

/**重新加载数据 默认不做任何事，子类可以重写该方法
 */
- (void)reloadDataFromNetwork{};


#pragma mark- alert

/**网络请求指示器信息
 *@param msg 提示的信息
 */
- (void)setShowNetworkActivityWithMsg:(NSString*) msg
{
    self.showNetworkActivity = YES;
    self.networkActivityView.msg = msg;
}

/**提示信息
 *@param msg 要提示的信息
 */
- (void)alertMsg:(NSString*) msg
{
    if(!self.toast)
    {
        SeaToast *toast = [[SeaToast alloc] init];
        [self.view addSubview:toast];
        toast.removeFromSuperViewAfterHidden = NO;
        self.toast = toast;
    }
    
    self.toast.text = msg;
    [self.view bringSubviewToFront:self.toast];
    [self.toast showAndHideDelay:2.0];
}

- (void)setToast:(SeaToast *)toast
{
    objc_setAssociatedObject(self, &SeaToastKey, toast, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**提示信息
 */
- (SeaToast*)toast
{
    return objc_getAssociatedObject(self, &SeaToastKey);
}

/**网络不佳的提示信息
 *@param msg 要提示的信息
 */
- (void)alerBadNetworkMsg:(NSString*) msg
{
    [self alertMsg:[NSString stringWithFormat:@"%@\n%@", SeaAlertMsgWhenBadNetwork, msg]];
}


#pragma mark- sea_tabBar

/**关联的选项卡 default is 'nil'
 */
- (void)setSea_TabBarController:(SeaTabBarController *)Sea_TabBarController
{
    objc_setAssociatedObject(self, &Sea_TabBarControllerKey, Sea_TabBarController, OBJC_ASSOCIATION_ASSIGN);
}

- (SeaTabBarController*)Sea_TabBarController
{
    return objc_getAssociatedObject(self, &Sea_TabBarControllerKey);
}

/**当viewWillAppear时是否隐藏选项卡 default is 'YES'
 */
- (void)setHideTabBar:(BOOL)hideTabBar
{
    objc_setAssociatedObject(self, &SeaHideTabBarKey, [NSNumber numberWithBool:hideTabBar], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hideTabBar
{
    return [objc_getAssociatedObject(self, &SeaHideTabBarKey) boolValue];
}

#pragma mark- Class Method

/**获取导航栏按钮 标题和图标只需设置一个
 *@param title 标题
 *@param icon 按钮图标
 *@param target 方法执行者
 *@param action 按钮点击方法
 *@param tintColor 主题颜色
 */
+ (UIBarButtonItem*)barButtonItemWithTitle:(NSString*) title icon:(UIImage*) icon target:(id) target action:(SEL) action tintColor:(UIColor*) tintColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    ///ios7 的 imageAssets 不支持 Template
    if(icon.renderingMode != UIImageRenderingModeAlwaysTemplate)
    {
        icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    if(action && target)
    {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        //[button setShowsTouchWhenHighlighted:YES];
    }
    else
    {
        //[button setAdjustsImageWhenDisabled:NO];
        [button setAdjustsImageWhenHighlighted:NO];
    }
    
    if(title)
    {
        button.titleLabel.font = [UIFont fontWithName:SeaMainFontName size:16.0];
        CGSize size = [title stringSizeWithFont:button.titleLabel.font contraintWith:CGFLOAT_MAX];
        [button setFrame:CGRectMake(0, 0, size.width, size.height)];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
        UIColor *titleColor = tintColor;
        if(titleColor == nil)
            titleColor = [UIColor whiteColor];
        
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    else if(icon)
    {
        [button setImage:icon forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, icon.size.width, icon.size.height)];
    }
    
    button.tintColor = tintColor;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    backBarButtonItem.tintColor = tintColor;
    
    return backBarButtonItem;
    
}

/**设置导航条样式 默认不透明
 *@param navigationBar 要设置的导航栏
 *@param backgroundColor 背景颜色
 *@param titleColor 标题颜色
 *@param font 标题字体
 */
+ (void)setupNavigationBar:(UINavigationBar*)navigationBar withBackgroundColor:(UIColor*) backgroundColor titleColor:(UIColor*) titleColor titleFont:(UIFont*) font
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if(!titleColor)
        titleColor = SeaTintColor;
    if(!font)
        font = [UIFont fontWithName:SeaMainFontName size:17.0];

    if([titleColor isEqualToColor:[UIColor whiteColor]])
    {
        [dic setObject:titleColor forKey:NSForegroundColorAttributeName];
    }
    else
    {
        [dic setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    }
    [dic setObject:font forKey:NSFontAttributeName];

    [navigationBar setTitleTextAttributes:dic];

    navigationBar.tintColor = titleColor;

    if(backgroundColor)
    {
        navigationBar.barTintColor = backgroundColor;
       // UIImage *image = [UIImage imageWithColor:backgroundColor size:CGSizeMake(1,1)];
      //  [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
       // navigationBar.shadowImage = [UIImage new];
    }
}


@end
