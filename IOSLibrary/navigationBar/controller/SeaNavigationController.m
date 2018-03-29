//
//  SeaNavigationController.m
//  Sea

//
//

#import "SeaNavigationController.h"
#import "UIViewController+Utils.h"
#import "SeaBasic.h"
#import "SeaViewController.h"

@interface SeaNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

/**原来的样式
 */
@property(nonatomic,assign) UIStatusBarStyle orgStyle;

@end

@implementation SeaNavigationController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        _targetStatusBarStyle = SeaStatusBarStyle;
        self.orgStyle = [UIApplication sharedApplication].statusBarStyle;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    
    __weak SeaNavigationController *weakSelf = self;
    
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (NSArray*)popToRootViewControllerAnimated:(BOOL)animated
{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray*)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer){
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers firstObject]){
            return NO;
        }else{
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
    UIViewController *viewController = viewControllerToPresent;
    
    if([viewController isKindOfClass:[UINavigationController class]]){
        viewController = [[(UINavigationController*)viewControllerToPresent viewControllers] lastObject];
    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
