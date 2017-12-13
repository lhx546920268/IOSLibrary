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

#define _barButtonItemSpace_ 6.0


/**objc rutime 属性，key **/

/**状态栏隐藏
 */
static char SeaStatusBarHiddenKey;
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

- (void)setSea_showNetworkActivity:(BOOL)sea_showNetworkActivity
{
    [self.view setSea_showNetworkActivity:sea_showNetworkActivity];
}

- (BOOL)sea_showNetworkActivity
{
    return [self.view sea_showNetworkActivity];
}

- (void)setSea_showFailPage:(BOOL)sea_showFailPage
{
    [self.view setSea_showFailPage:sea_showFailPage];
    if(sea_showFailPage){
        WeakSelf(self);
        self.view.sea_reloadDataHandler() = ^(void){
            [weakSelf reloadDataFromNetwork];
        };
    }
}

- (BOOL)sea_showFailPage
{
    return [self.view sea_showFailPage];
}

/**重新加载数据 默认不做任何事，子类可以重写该方法
 */
- (void)reloadDataFromNetwork{
    
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
        
        UIBarButtonItem *item = self.sea_leftBarButtonItem;
        item.tintColor = sea_iconTintColor;
        item.customView.tintColor = sea_iconTintColor;
        item = self.sea_rightBarButtonItem;
        item.tintColor = sea_iconTintColor;
        item.customView.tintColor = sea_iconTintColor;
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
    if(self.sea_statusBarHeight != sea_statusBarHidden)
    {
        objc_setAssociatedObject(self, &SeaStatusBarHiddenKey, [NSNumber numberWithBool:sea_statusBarHidden], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    if(sea_showBackItem)
    {
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

- (BOOL)sea_showBackItem
{
    return [self.sea_leftBarButtonItem.customView isKindOfClass:[UIImageView class]];
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

/**左边导航栏图标 返回非 UIBarButtonSystemItemFixedSpace类型的
 */
- (UIBarButtonItem*)sea_leftBarButtonItem
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
- (UIBarButtonItem*)sea_rightBarButtonItem
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
- (void)setSea_tabBarController:(SeaTabBarController *)Sea_TabBarController
{
    objc_setAssociatedObject(self, &Sea_TabBarControllerKey, Sea_TabBarController, OBJC_ASSOCIATION_ASSIGN);
}

- (SeaTabBarController*)sea_tabBarController
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
