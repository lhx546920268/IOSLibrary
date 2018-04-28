//
//  UIViewController+Utilities.m
//  IOSLibrary
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
#import "SeaPresentTransitionDelegate.h"
#import "UIViewController+Dialog.h"

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

/**过渡代理
 */
static char SeaTransitioningDelegateKey;

@implementation UIViewController (Utils)

#pragma mark- loading

- (void)setSea_showPageLoading:(BOOL)sea_showPageLoading
{
    if(self.isShowAsDialog){
        [self.dialog setSea_showPageLoading:sea_showPageLoading];
    }else{
        [self.view setSea_showPageLoading:sea_showPageLoading];
    }
}

- (BOOL)sea_showPageLoading
{
    if(self.isShowAsDialog){
        return [self.dialog sea_showPageLoading];
    }else{
        return [self.view sea_showPageLoading];
    }
}

- (void)setSea_pageLoadingView:(UIView *)sea_pageLoadingView
{
    if(self.isShowAsDialog){
        self.dialog.sea_pageLoadingView = sea_pageLoadingView;
    }else{
        self.view.sea_pageLoadingView = sea_pageLoadingView;
    }
}

- (UIView*)sea_pageLoadingView
{
    if(self.isShowAsDialog){
        return self.dialog.sea_pageLoadingView;
    }else{
        return self.view.sea_pageLoadingView;
    }
}

- (void)setSea_showNetworkActivity:(BOOL)sea_showNetworkActivity
{
    if(self.isShowAsDialog){
        [self.dialog setSea_showNetworkActivity:sea_showNetworkActivity];
    }else{
        [self.view setSea_showNetworkActivity:sea_showNetworkActivity];
    }
}

- (BOOL)sea_showNetworkActivity
{
    if(self.isShowAsDialog){
        return [self.dialog sea_showNetworkActivity];
    }else{
        return [self.view sea_showNetworkActivity];
    }
}

- (void)setSea_networkActivity:(UIView *)sea_networkActivity
{
    if(self.isShowAsDialog){
        self.dialog.sea_networkActivity = sea_networkActivity;
    }else{
        self.view.sea_networkActivity = sea_networkActivity;
    }
}

- (UIView*)sea_networkActivity
{
    if(self.isShowAsDialog){
        return self.dialog.sea_networkActivity;
    }else{
        return self.view.sea_networkActivity;
    }
}

- (void)setSea_showFailPage:(BOOL)sea_showFailPage
{
    if(self.isShowAsDialog){
        [self.dialog setSea_showFailPage:sea_showFailPage];
        if(sea_showFailPage){
            WeakSelf(self);
            self.dialog.sea_reloadDataHandler = ^(void){
                [weakSelf sea_reloadData];
            };
        }
    }else{
        [self.view setSea_showFailPage:sea_showFailPage];
        if(sea_showFailPage){
            WeakSelf(self);
            self.view.sea_reloadDataHandler = ^(void){
                [weakSelf sea_reloadData];
            };
        }
    }
}

- (BOOL)sea_showFailPage
{
    if(self.isShowAsDialog){
        return [self.dialog sea_showFailPage];
    }else{
        return [self.view sea_showFailPage];
    }
}

- (void)setSea_failPageView:(UIView *)sea_failPageView
{
    if(self.isShowAsDialog){
        self.dialog.sea_failPageView = sea_failPageView;
    }else{
        self.view.sea_failPageView = sea_failPageView;
    }
}

- (UIView*)sea_failPageView
{
    if(self.isShowAsDialog){
        return self.dialog.sea_failPageView;
    }else{
        return self.view.sea_failPageView;
    }
}

/**重新加载数据 默认不做任何事，子类可以重写该方法
 */
- (void)sea_reloadData{
    
}

#pragma mark- empty view

- (void)setSea_showEmptyView:(BOOL)sea_showEmptyView
{
    if(self.isShowAsDialog){
        self.dialog.sea_showEmptyView = sea_showEmptyView;
    }else{
        self.view.sea_showEmptyView = sea_showEmptyView;
    }
}

- (BOOL)sea_showEmptyView
{
    if(self.isShowAsDialog){
        return self.dialog.sea_showEmptyView;
    }else{
        return self.view.sea_showEmptyView;
    }
}

- (SeaEmptyView*)sea_emptyView
{
    if(self.isShowAsDialog){
        return self.dialog.sea_emptyView;
    }else{
        return self.view.sea_emptyView;
    }
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
    if(self.tabBarController){
        return self.tabBarController.tabBar.height;
    }else{
        return SeaTabBarHeight;
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
    if(![self.sea_iconTintColor isEqualToColor:sea_iconTintColor]){
        objc_setAssociatedObject(self, &SeaIconTintColorKey, sea_iconTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if(!sea_iconTintColor){
            sea_iconTintColor = [UIColor blackColor];
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
        color = [UINavigationBar appearance].tintColor;
    
    return color;
}

/**用于 present ViewController 的 statusBar 隐藏状态控制 default is 'NO' ，不隐藏
 */
- (void)setSea_statusBarHidden:(BOOL)sea_statusBarHidden
{
    if(self.sea_statusBarHeight != sea_statusBarHidden){
        objc_setAssociatedObject(self, &SeaStatusBarHiddenKey,@(sea_statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [UIView animateWithDuration:0.3 animations:^(void){
           [self setNeedsStatusBarAppearanceUpdate];
        }];
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
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 15.0, 44)];
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
    }else{
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

#pragma mark- tabBar

- (SeaTabBarController*)sea_tabBarController
{
    SeaTabBarController *controller = nil;
    UIViewController *vc = self;
    //present 出来的
    if(self.presentingViewController){
        vc = [self sea_rootPresentingViewController];
    }else if(self.navigationController){
        vc = self.navigationController;
    }
    
    if([vc isKindOfClass:[SeaTabBarController class]]){
        controller = (SeaTabBarController*)vc;
    }else if ([vc.parentViewController isKindOfClass:[SeaTabBarController class]]){
        controller = (SeaTabBarController*)vc.parentViewController;
    }
    
    return controller;
}

#pragma mark- back

- (void)sea_back
{
    [self sea_backAnimated:YES];
}

- (void)sea_backAnimated:(BOOL) flag
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];

    if(self.navigationController.viewControllers.count <= 1){
        [self dismissViewControllerAnimated:flag completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:flag];
    }
}

- (void)sea_backToRootViewControllerAnimated:(BOOL) flag
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];

    ///是present出来的
    if(self.presentingViewController){
        UIViewController *root = [self sea_rootPresentingViewController];
        if(root.navigationController.viewControllers.count > 1){
            ///dismiss 之后还有 pop,所以dismiss无动画
            [root dismissViewControllerAnimated:NO completion:nil];
            [root.navigationController popToRootViewControllerAnimated:flag];
        }else{
            [root dismissViewControllerAnimated:flag completion:nil];
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:flag];
    }
}

- (UIViewController*)sea_topestPresentedViewController
{
    if(self.presentedViewController){
        return [self.presentedViewController sea_topestPresentedViewController];
    }else{
        return self;
    }
}

- (UIViewController*)sea_rootPresentingViewController
{
    if(self.presentingViewController){
        return [self.presentingViewController sea_rootPresentingViewController];
    }else{
        return self;
    }
}

//长按返回第一个视图
- (void)longPressBack:(UILongPressGestureRecognizer*) longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan){
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

/**创建导航栏并返回 UINavigationController
 */
- (UINavigationController*)sea_createWithNavigationController
{
    SeaNavigationController *nav = [[SeaNavigationController alloc] initWithRootViewController:self];
    return nav;
}

#pragma mark- alert

- (void)setShowNetworkActivityWithMsg:(NSString*) msg
{
    self.sea_showNetworkActivity = YES;
    if([self.sea_networkActivity isKindOfClass:[SeaNetworkActivityView class]]){
        SeaNetworkActivityView *view = (SeaNetworkActivityView*)self.sea_networkActivity;
        view.msg = msg;
    }
}

- (void)sea_alertMsg:(NSString*) msg
{
    [self.view sea_alertMessage:msg];
}

- (void)sea_alertMsg:(NSString*) msg icon:(UIImage*) icon
{
    [self.view sea_alertMessage:msg icon:icon];
}

- (void)sea_alerBadNetworkMsg:(NSString*) msg
{
    [self sea_alertMsg:[NSString stringWithFormat:@"%@\n%@", SeaBadNetworkText, msg]];
}

#pragma mark- navigation

- (void)sea_pushViewController:(UIViewController*) viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)sea_pushViewControllerUseTransitionDelegate:(UIViewController *)viewController
{
    [SeaPresentTransitionDelegate pushViewController:viewController useNavigationBar:YES parentedViewConttroller:self];
}

#pragma mark- Class Method

+ (UIBarButtonItem*)sea_barItemWithImage:(UIImage*) image target:(id) target action:(SEL) action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, image.size.width + 3.0, image.size.height);
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    btn.tintColor = [UINavigationBar appearance].tintColor;
//    UIFont *font = [[[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal] objectForKey:NSFontAttributeName];
//    if(font == nil){
//        font = [UIFont systemFontOfSize:14];
//    }
//    btn.titleLabel.font = font;
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
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

+ (void)setupNavigationBar:(UINavigationBar*)navigationBar withBackgroundColor:(UIColor*) backgroundColor backgroundImage:(UIImage*) backgroundImage titleColor:(UIColor*) titleColor titleFont:(UIFont*) font tintColor:(UIColor*) tintColor
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if(!titleColor)
        titleColor = [UIColor blackColor];
    if(!font)
        font = [UIFont systemFontOfSize:17];
    if(!tintColor)
        tintColor = [UIColor blackColor];

    [dic setObject:titleColor forKey:NSForegroundColorAttributeName];
    [dic setObject:font forKey:NSFontAttributeName];

    [navigationBar setTitleTextAttributes:dic];

    navigationBar.tintColor = tintColor;

    if(backgroundColor){
        navigationBar.barTintColor = backgroundColor;
    }
    if(backgroundImage){
        [navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
}


@end
