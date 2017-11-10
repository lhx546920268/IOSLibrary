//
//  SeaNavigationController.m
//  Sea

//
//

#import "SeaNavigationController.h"
#import "UIViewController+Utilities.h"
#import "SeaBasic.h"

@interface SeaNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

/**原来的样式
 */
@property(nonatomic,assign) UIStatusBarStyle orgStyle;

@end

@implementation SeaNavigationController


+ (void)initialize
{
    //设置默认导航条
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:[SeaNavigationController class], nil];
    [UIViewController setupNavigationBar:navigationBar withBackgroundColor:SeaNavigationBarBackgroundColor titleColor:SeaTintColor titleFont:[UIFont fontWithName:SeaMainFontName size:17.0]];
   // navigationBar.translucent = NO; ios 7.0会崩溃
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _targetStatusBarStyle = SeaStatusBarStyle;
        self.orgStyle = [UIApplication sharedApplication].statusBarStyle;
    }
    return self;
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//   
//    //这里要把状态栏样式还原
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //设置选项卡和隐藏状态
    if([viewController isKindOfClass:[SeaViewController class]])
    {
        SeaViewController *tmp = [self.viewControllers lastObject];
        if([tmp isKindOfClass:[SeaViewController class]])
        {
            SeaViewController *vc = (SeaViewController*)viewController;
            vc.Sea_TabBarController = tmp.Sea_TabBarController;
        }
    }
    
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    
    __weak SeaNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
        self.delegate = weakSelf;
    }
    
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return  [super popToRootViewControllerAnimated:animated];
    
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToViewController:viewController animated:animated];
    
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers firstObject] )
        {
            return NO;
        }
        else
        {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
        }
    }
    
    return YES;
}


- (void)setTargetStatusBarStyle:(UIStatusBarStyle)targetStatusBarStyle
{
    _targetStatusBarStyle = targetStatusBarStyle;
    self.modalPresentationCapturesStatusBarAppearance = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.targetStatusBarStyle;
}


- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    SeaViewController *vc = [self.viewControllers lastObject];
    
    UIViewController *viewController = viewControllerToPresent;
    
    if([viewController isKindOfClass:[UINavigationController class]])
    {
        viewController = [[(UINavigationController*)viewControllerToPresent viewControllers] lastObject];
    }
    
    if([vc isKindOfClass:[SeaViewController class]] && [viewController isKindOfClass:[SeaViewController class]])
    {
        SeaViewController *tmp = (SeaViewController*)viewController;
        tmp.Sea_TabBarController = vc.Sea_TabBarController;
    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
