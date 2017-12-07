//
//  SeaPresentTransitionDelegate.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaPresentTransitionDelegate.h"
#import "UIViewController+Utils.h"


@class SeaPresentTransitionDelegate;

///自定义Present类型的过度动画实现 通过init初始化
@interface SeaPresentTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

///关联的 SeaPresentTransitionDelegate
@property(nonatomic,weak) SeaPresentTransitionDelegate *delegate;

@end

///自定义Present类型的过度动画，用于用户滑动屏幕触发的过度动画
@interface SeaPresentInteractiveTransition : UIPercentDrivenInteractiveTransition

///关联的 SeaPresentTransitionDelegate
@property(nonatomic,weak) SeaPresentTransitionDelegate *delegate;

@end

@interface SeaPresentTransitionDelegate ()
{
    ///平移手势
    UIScreenEdgePanGestureRecognizer *_panGestureRecognizer;
}

///屏幕边缘平滑手势
@property(nonatomic,strong) UIScreenEdgePanGestureRecognizer *panGestureRecognizer;

///关联的viewController
@property(nonatomic,weak) UIViewController *viewController;

///是否是直接dismiss
@property(nonatomic,assign) BOOL dismissDirectly;

@end

@implementation SeaPresentTransitionDelegate

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.duration = 0.35;
        self.completePercent = 0.5;
        self.transitionStyle = SeaPresentTransitionStyleCoverHorizontal;
    }

    return self;
}

- (void)setCompletePercent:(float)completePercent
{
    if(_completePercent != completePercent)
    {
        if(completePercent > 1.0)
            completePercent = 1.0;
        else if(completePercent < 0.1)
            completePercent = 0.1;

        _completePercent = completePercent;
    }
}

///添加手势交互的过渡
- (void)addInteractiveTransitionToViewController:(UIViewController*) viewController
{
    if(self.viewController == viewController)
        return;
    self.panGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGestureRecognizer.edges = UIRectEdgeLeft;
    self.viewController = viewController;
    [viewController.view addGestureRecognizer:self.panGestureRecognizer];
}

///平移手势
- (void)handlePan:(UIScreenEdgePanGestureRecognizer*) pan
{
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        ///回收键盘
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        self.dismissDirectly = NO;
        
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark- UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.dismissDirectly = YES;
    SeaPresentTransitionAnimator *animator = [[SeaPresentTransitionAnimator alloc] init];
    animator.delegate = self;

    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    SeaPresentTransitionAnimator *animator = [[SeaPresentTransitionAnimator alloc] init];
    animator.delegate = self;

    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if(self.viewController && !self.dismissDirectly)
    {
        self.dismissDirectly = YES;
        SeaPresentInteractiveTransition *interactive = [[SeaPresentInteractiveTransition alloc] init];
        interactive.delegate = self;
        
        return interactive;
    }
    else
    {
        return nil;
    }
}

#pragma mark- Class method

/**快捷的方法使用 SeaPresentTransitionDelegate
 *@param vc 被push的
 *@param flag 是否使用导航栏
 *@param parentedViewConttroller push的
 */
+ (UINavigationController*)pushViewController:(UIViewController*) vc useNavigationBar:(BOOL) flag parentedViewConttroller:(UIViewController*) parentedViewConttroller
{
    SeaPresentTransitionDelegate *delegate = [[SeaPresentTransitionDelegate alloc] init];
    if(flag)
    {
        UINavigationController *nav = [vc createdInNavigationController];
        nav.sea_transitioningDelegate = delegate;
        [parentedViewConttroller presentViewController:nav animated:YES completion:^(void){
            
            if(vc.navigationController)
            {
                [delegate addInteractiveTransitionToViewController:vc];
            }
        }];
    }
    else
    {
        vc.sea_transitioningDelegate = delegate;
        [parentedViewConttroller presentViewController:vc animated:YES completion:^(void){
            
            [delegate addInteractiveTransitionToViewController:vc];
        }];
    }
    
    return vc.navigationController;
}


@end

@implementation SeaPresentTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.delegate.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = transitionContext.containerView;

    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *fromView;
    UIView *toView;

    ///ios 8 才有的api
    if ([transitionContext respondsToSelector:@selector(viewForKey:)])
    {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else
    {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }

    BOOL isPresenting = toViewController.presentingViewController == fromViewController;

    CGRect fromFrame;
    CGRect toFrame;

    switch (self.delegate.transitionStyle)
    {
        case SeaPresentTransitionStyleCoverVertical :
        {
            fromFrame = fromView.frame;
            toFrame = toView.frame;
            if (isPresenting)
            {
                fromView.frame = fromFrame;
                toView.frame = CGRectOffset(toFrame, 0, toFrame.size.height);
            }
            else
            {
                fromView.frame = fromFrame;
                toView.frame = toFrame;
            }
        }
            break;
        case SeaPresentTransitionStyleCoverHorizontal :
        {
            fromFrame = [transitionContext initialFrameForViewController:fromViewController];
            toFrame = [transitionContext finalFrameForViewController:toViewController];
            if (isPresenting)
            {
                fromView.frame = fromFrame;
                toView.frame = CGRectOffset(toFrame, toFrame.size.width,0);
            }
            else
            {
                fromView.frame = fromFrame;
                toView.frame = CGRectOffset(toFrame, -toFrame.size.width * 0.5, 0);
            }
        }
            break;
    }


    if (isPresenting)
    {
        [containerView addSubview:toView];
        toView.layer.shadowColor = [UIColor grayColor].CGColor;
        toView.layer.shadowOpacity = 0.5;
        toView.layer.shadowOffset = CGSizeMake(-1, 0);
    }
    else
    {
        [containerView insertSubview:toView belowSubview:fromView];
        fromView.layer.shadowColor = [UIColor grayColor].CGColor;
        fromView.layer.shadowOpacity = 0.5;
        fromView.layer.shadowOffset = CGSizeMake(-1, 0);
    }

    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    
    ///视图动画
    [UIView animateWithDuration:transitionDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        switch (self.delegate.transitionStyle)
        {
            case SeaPresentTransitionStyleCoverVertical :
            {
                if (isPresenting)
                {
                    toView.frame = toFrame;
                    fromView.frame = fromFrame;
                }
                else
                {
                    fromView.frame = CGRectOffset(fromFrame, 0, fromFrame.size.height);
                    toView.frame = toFrame;
                }
            }
                break;
            case SeaPresentTransitionStyleCoverHorizontal :
            {
                if (isPresenting)
                {
                    toView.frame = toFrame;
                    fromView.frame = CGRectOffset(fromFrame, - fromFrame.size.width * 0.5, 0);
                }
                else
                {
                    fromView.frame = CGRectOffset(fromFrame, fromFrame.size.width,0);
                    toView.frame = toFrame;
                }
            }
                break;
        }

    } completion:^(BOOL finished) {

        ///如果过度动画取消，需要移除 toView
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        
        if (wasCancelled)
        {
            [containerView addSubview:fromViewController.view];
            [toView removeFromSuperview];
        }
        else
        {
            fromView.layer.shadowOpacity = 0;
        }
        toView.layer.shadowOpacity = 0;

        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end

@interface SeaPresentInteractiveTransition()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation SeaPresentInteractiveTransition



- (void)setDelegate:(SeaPresentTransitionDelegate *)delegate
{
    if(_delegate != delegate)
    {
        _delegate = delegate;

        ///添加手势监听
        [_delegate.panGestureRecognizer addTarget:self action:@selector(handlePan:)];
    }
}

- (void)dealloc
{
    ///移除手势
    [self.delegate.panGestureRecognizer removeTarget:self action:@selector(handlePan:)];
}

#pragma mark- super method

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    [super startInteractiveTransition:transitionContext];
}

- (CGFloat)percentForGesture:(UIScreenEdgePanGestureRecognizer *)gesture
{
    UIView *containerView = self.transitionContext.containerView;

    CGPoint point = [gesture locationInView:containerView];

    CGFloat width = CGRectGetWidth(containerView.bounds);

    CGFloat percent = gesture.edges == UIRectEdgeLeft ? point.x / width : (width - point.x) / width;
    
    return percent;
}

///平移手势
- (void)handlePan:(UIScreenEdgePanGestureRecognizer*) pan
{
    switch (pan.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:[self percentForGesture:pan]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if ([self percentForGesture:pan] >= self.delegate.completePercent)
            {
                [self finishInteractiveTransition];
            }
            else
            {
                [self cancelInteractiveTransition];
            }
        }
            break;
        default:
        {
            [self cancelInteractiveTransition];
        }
            break;
    }
}

@end
