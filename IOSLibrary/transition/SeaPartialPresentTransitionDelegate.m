//
//  SeaPartialPresentTransitionDelegate.m
//  IOSLibrary
//
//  Created by 罗海雄 on 16/7/11.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import "SeaPartialPresentTransitionDelegate.h"
#import "UIView+Utils.h"
#import "UIImage+Utils.h"
#import "SeaBasic.h"
#import "UIViewController+Utils.h"

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

@interface SeaPartialPresentTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

///关联的 SeaPartialPresentTransitionAnimator
@property(nonatomic,weak) SeaPartialPresentTransitionDelegate *delegate;

@end

@interface SeaPartialPresentTransitionDelegate()

///动画
@property(nonatomic,strong) SeaPartialPresentTransitionAnimator *animator;

@end

@implementation SeaPartialPresentTransitionDelegate

- (instancetype)init
{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.duration = 0.35;
        self.dismissWhenTapBackground = YES;
        self.backTransform = CGAffineTransformMakeScale(0.95, 0.95);
        self.transitionStyle = SeaPresentTransitionStyleCoverVertical;
    }

    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.animator = [[SeaPartialPresentTransitionAnimator alloc] init];
    self.animator.delegate = self;

    return self.animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if(!self.animator){
        self.animator = [[SeaPartialPresentTransitionAnimator alloc] init];
        self.animator.delegate = self;
    }
    return self.animator;
}

+ (void)pushViewController:(UIViewController *)child inViewController:(UIViewController *)parant
{
    SeaPartialPresentTransitionDelegate *delegate = [[SeaPartialPresentTransitionDelegate alloc] init];
    delegate.transitionStyle = SeaPresentTransitionStyleCoverHorizontal;
    child.sea_transitioningDelegate = delegate;
    [parant presentViewController:child animated:YES completion:nil];
}

+ (void)presentViewController:(UIViewController *)child inViewController:(UIViewController *)parant
{
    SeaPartialPresentTransitionDelegate *delegate = [[SeaPartialPresentTransitionDelegate alloc] init];
    delegate.transitionStyle = SeaPresentTransitionStyleCoverVertical;
    child.sea_transitioningDelegate = delegate;
    [parant presentViewController:child animated:YES completion:nil];
}

@end

@interface SeaPartialPresentTransitionAnimator ()<UIGestureRecognizerDelegate>

///弹出来的视图
@property(nonatomic,weak) UIViewController *presentedViewController;

///背景视图
@property(nonatomic,strong) UIView *backgroundView;

///背后的ViewController视图，由于present动画完成后，背后的viewController会被移除，所以要生成一张图片，放在后面
@property(nonatomic,strong) UIImageView *backgroundImageView;

@end

@implementation SeaPartialPresentTransitionAnimator


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.delegate.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = transitionContext.containerView;
    UIView *fromView;
    UIView *toView;

    ///ios 8 才有的api
    if([transitionContext respondsToSelector:@selector(viewForKey:)]){
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }else{
        fromView = fromViewController.view;
        toView = toViewController.view;
    }

    ///是否是弹出
    BOOL isPresenting = toViewController.presentingViewController == fromViewController;

    ///背景视图
    if(isPresenting){
        self.backgroundView = [[UIView alloc] initWithFrame:containerView.bounds];
        self.backgroundView.backgroundColor = self.delegate.backgroundColor;
        if(self.delegate.dismissWhenTapBackground){
            ///防止手势冲突
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            tap.delegate = self;
            self.presentedViewController = toViewController;
            [self.backgroundView addGestureRecognizer:tap];
            self.backgroundView.userInteractionEnabled = YES;
        }else{
            self.backgroundView.userInteractionEnabled = NO;
        }
        self.backgroundView.alpha = 0;

        UIImage *image = [UIImage sea_imageFromView:fromView];
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:fromView.frame];
        self.backgroundImageView.image = image;
    }

    CGRect fromFrame = fromView.frame;
    CGRect toFrame = toView.frame;

    if(isPresenting){
        fromView.frame = fromFrame;
        fromView.hidden = YES;

        switch (self.delegate.transitionStyle){
            case SeaPresentTransitionStyleCoverVertical : {
                toFrame.origin.y = containerView.height - toFrame.size.height;
                toFrame.origin.x = (containerView.width - toFrame.size.width) / 2.0;
                toView.frame = CGRectOffset(toFrame, 0, toFrame.size.height);
            }
                break;
            case SeaPresentTransitionStyleCoverHorizontal : {
                toFrame.origin.y = (containerView.height - toFrame.size.height) / 2.0;
                toFrame.origin.x = containerView.width - toFrame.size.width;
                toView.frame = CGRectOffset(toFrame, toFrame.size.width, 0);
            }
                break;
        }

        [containerView addSubview:toView];
        [containerView insertSubview:self.backgroundView belowSubview:toView];
        [containerView insertSubview:self.backgroundImageView atIndex:0];
    }else{
        
        fromView.frame = fromFrame;
        //当 fromViewController.modalPresentationStyle = UIModalPresentationCustom 时， toView 为nil
        if(toView){
            toView.hidden = YES;
            toView.frame = toFrame;
            [containerView insertSubview:toView belowSubview:fromView];
        }else{
            toFrame = CGRectMake(0, 0, SeaScreenWidth, SeaScreenHeight);
        }
    }

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^(void){

        if(isPresenting){
            toView.frame = toFrame;
            self.backgroundImageView.transform = self.delegate.backTransform;
            self.backgroundView.alpha = 1.0;
        }else{
            switch (self.delegate.transitionStyle){
                case SeaPresentTransitionStyleCoverHorizontal : {
                    fromView.frame = CGRectOffset(fromFrame, toFrame.size.width, 0);
                }
                    break;
                case SeaPresentTransitionStyleCoverVertical : {
                    fromView.frame = CGRectOffset(fromFrame, 0, toFrame.size.height);
                }
                    break;
                default:
                    break;
            }
            self.backgroundImageView.transform = CGAffineTransformIdentity;
            self.backgroundView.alpha = 0;
        }
    }completion:^(BOOL finish){

        [transitionContext completeTransition:YES];

        ///移除背景视图
        if(!isPresenting){
            [self.backgroundView removeFromSuperview];
            [self.backgroundImageView removeFromSuperview];
            toView.hidden = NO;
        }
    }];

}

///点击背景视图
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    WeakSelf(self);
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        !weakSelf.delegate.dismissHandler ?: weakSelf.delegate.dismissHandler();
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];

    if(CGRectContainsPoint(self.presentedViewController.view.frame, point)){
        return NO;
    }

    return YES;
}

@end
