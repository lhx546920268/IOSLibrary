//
//  UIViewController+Dialog.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/4/28.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UIViewController+Dialog.h"
#import "UIView+Utils.h"
#import "SeaBasic.h"
#import "UIViewController+Utils.h"
#import "SeaNavigationController.h"
#import "UIView+SeaAutoLayout.h"
#import <objc/runtime.h>
#import "NSObject+Utils.h"
#import "SeaViewController.h"
#import "SeaContainer.h"
#import "UIViewController+Keyboard.h"

static char SeaisShowAsDialogKey;
static char SeaDialogKey;
static char SeaShouldDismissDialogOnTapTranslucentKey;
static char SeaDialogBackgroundViewKey;
static char SeaDialogShowAnimateKey;
static char SeaDialogDismissAnimateKey;
static char SeaisDialogShowingKey;
static char SeaDialogShowCompletionHandlerKey;
static char SeaDialogDismissCompletionHandlerKey;
static char SeaDialogShouldAnimateKey;
static char SeaTapDialogBackgroundGestureRecognizerKey;
static char SeaIsDialogViewDidLayoutSubviewsKey;

@implementation UIViewController (Dialog)

+ (void)load
{
    SEL selectors[] = {
        @selector(viewWillAppear:),
        @selector(viewWillDisappear:),
        @selector(viewDidAppear:),
        @selector(viewDidLoad),
        @selector(viewDidLayoutSubviews)
    };
    
    int count = sizeof(selectors) / sizeof(SEL);
    for(int i = 0;i < count;i ++){
        [self sea_exchangeImplementations:selectors[i] prefix:@"sea_dialog_"];
    }
}

#pragma mark 视图消失出现

- (void)sea_dialog_viewWillAppear:(BOOL)animated
{
    [self sea_dialog_viewWillAppear:animated];
    if(self.isShowAsDialog){
        [self setIsDialogShowing:YES];
    }
}

- (void)sea_dialog_viewWillDisappear:(BOOL)animated
{
    [self sea_dialog_viewWillDisappear:animated];
    if(self.isShowAsDialog){
        [self setIsDialogShowing:NO];
    }
}

- (void)sea_dialog_viewDidAppear:(BOOL)animated
{
    [self sea_dialog_viewDidAppear:animated];
    if(self.isShowAsDialog){
        [self executeShowAnimate];
    }
}

#pragma mark view init

- (void)sea_dialog_viewDidLoad {
    [self sea_dialog_viewDidLoad];
    
    if(self.isShowAsDialog){
        UIView *backgroundView = [UIView new];
        backgroundView.alpha = 0;
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view insertSubview:backgroundView atIndex:0];
        
        [backgroundView sea_insetsInSuperview:UIEdgeInsetsZero];
        [self setDialogBackgroundView:backgroundView];
        
        self.dialogShowAnimate = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [UIColor clearColor];
        
        self.shouldDismissDialogOnTapTranslucent = YES;
    }
}

- (void)sea_dialog_viewDidLayoutSubviews
{
    [self sea_dialog_viewDidLayoutSubviews];
    [self setIsDialogViewDidLayoutSubviews:YES];
    if(self.isShowAsDialog){
        [self executeShowAnimate];
    }
}

#pragma mark property

- (void)setIsShowAsDialog:(BOOL)isShowAsDialog
{
    objc_setAssociatedObject(self, &SeaisShowAsDialogKey, @(isShowAsDialog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isShowAsDialog
{
    return [objc_getAssociatedObject(self, &SeaisShowAsDialogKey) boolValue];
}

- (void)setDialog:(UIView *)dialog
{
    if([self isKindOfClass:[SeaViewController class]]){
        SeaViewController *vc = (SeaViewController*)self;
        NSAssert(vc.container == nil, @"如果 UIViewController 是 SeaViewController 或者其子类，并且没有使用xib，dialog属性将自动设置为 SeaContainer");
    }
    objc_setAssociatedObject(self, &SeaDialogKey, dialog, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)dialog
{
    if([self isKindOfClass:[SeaViewController class]]){
        SeaViewController *vc = (SeaViewController*)self;
        if(vc.container != nil){
            return vc.container;
        }
    }
    
    return objc_getAssociatedObject(self, &SeaDialogKey);
}

- (void)setShouldDismissDialogOnTapTranslucent:(BOOL) flag
{
    if(self.shouldDismissDialogOnTapTranslucent != flag){
        if(!self.tapDialogBackgroundGestureRecognizer){
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDialog)];
            [self.dialogBackgroundView addGestureRecognizer:tap];
            [self setTapDialogBackgroundGestureRecognizer:tap];
        }
        
        objc_setAssociatedObject(self, &SeaShouldDismissDialogOnTapTranslucentKey, @(flag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.tapDialogBackgroundGestureRecognizer.enabled = flag;
    }
}

- (BOOL)shouldDismissDialogOnTapTranslucent
{
    return [objc_getAssociatedObject(self, &SeaShouldDismissDialogOnTapTranslucentKey) boolValue];
}

- (void)setTapDialogBackgroundGestureRecognizer:(UITapGestureRecognizer*) tap
{
    objc_setAssociatedObject(self, &SeaTapDialogBackgroundGestureRecognizerKey, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIGestureRecognizer*)tapDialogBackgroundGestureRecognizer
{
    return objc_getAssociatedObject(self, &SeaTapDialogBackgroundGestureRecognizerKey);
}

- (void)setDialogBackgroundView:(UIView *)dialogBackgroundView
{
    objc_setAssociatedObject(self, &SeaDialogBackgroundViewKey, dialogBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)dialogBackgroundView
{
    return objc_getAssociatedObject(self, &SeaDialogBackgroundViewKey);
}

- (void)setDialogShowAnimate:(SeaDialogAnimate)dialogShowAnimate
{
    objc_setAssociatedObject(self, &SeaDialogShowAnimateKey, @(dialogShowAnimate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SeaDialogAnimate)dialogShowAnimate
{
    return [objc_getAssociatedObject(self, &SeaDialogShowAnimateKey) integerValue];
}

- (void)setDialogDismissAnimate:(SeaDialogAnimate)dialogDismissAnimate
{
    objc_setAssociatedObject(self, &SeaDialogDismissAnimateKey, @(dialogDismissAnimate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SeaDialogAnimate)dialogDismissAnimate
{
    return [objc_getAssociatedObject(self, &SeaDialogDismissAnimateKey) integerValue];
}

- (void)setIsDialogShowing:(BOOL)isDialogShowing
{
    objc_setAssociatedObject(self, &SeaisDialogShowingKey, @(isDialogShowing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isDialogShowing
{
    return [objc_getAssociatedObject(self, &SeaisDialogShowingKey) boolValue];
}

- (void)setDialogShowCompletionHandler:(void (^)(void)) handler
{
    objc_setAssociatedObject(self, &SeaDialogShowCompletionHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(void))dialogShowCompletionHandler
{
    return objc_getAssociatedObject(self, &SeaDialogShowCompletionHandlerKey);
}

- (void)setDialogDismissCompletionHandler:(void (^)(void)) handler
{
    objc_setAssociatedObject(self, &SeaDialogDismissCompletionHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(void))dialogDismissCompletionHandler
{
    return objc_getAssociatedObject(self, &SeaDialogDismissCompletionHandlerKey);
}

- (void)setDialogShouldAnimate:(BOOL) dialogShouldAnimate
{
    objc_setAssociatedObject(self, &SeaDialogShouldAnimateKey, @(dialogShouldAnimate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)dialogShouldAnimate
{
    return [objc_getAssociatedObject(self, &SeaDialogShouldAnimateKey) boolValue];
}

- (void)setIsDialogViewDidLayoutSubviews:(BOOL) flag
{
    objc_setAssociatedObject(self, &SeaIsDialogViewDidLayoutSubviewsKey, @(flag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isDialogViewDidLayoutSubviews
{
    return [objc_getAssociatedObject(self, &SeaIsDialogViewDidLayoutSubviewsKey) boolValue];
}

#pragma mark- public method

- (void)showAsDialog
{
    [self showAsDialogInViewController:[[UIApplication sharedApplication].keyWindow.rootViewController sea_topestPresentedViewController]];
}

- (void)showAsDialogInViewController:(UIViewController *)viewController
{
    if(self.isDialogShowing){
        return;
    }
    
    [self setIsShowAsDialog:YES];
    ///设置使背景透明
    self.dialogShowAnimate = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [viewController presentViewController:self animated:NO completion:self.dialogShowCompletionHandler];
}

///执行出场动画
- (void)executeShowAnimate
{
    //出场动画
    if(self.dialog && self.dialogShowAnimate && self.isDialogViewDidLayoutSubviews){
        [self setDialogShouldAnimate:NO];
        
        switch (self.dialogShowAnimate) {
            case SeaDialogAnimateNone : {
                self.dialogBackgroundView.alpha = 1.0;
            }
                break;
            case SeaDialogAnimateScale : {
                
                self.dialog.alpha = 0;
                [UIView animateWithDuration:0.25 animations:^(void){
                    
                    self.dialogBackgroundView.alpha = 1.0;
                    self.dialog.alpha = 1.0;
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                    animation.fromValue = @(1.3);
                    animation.toValue = @(1.0);
                    animation.duration = 0.25;
                    [self.dialog.layer addAnimation:animation forKey:@"scale"];
                    
                }];
            }
                break;
            case SeaDialogAnimateFromTop : {
                [UIView animateWithDuration:0.25 animations:^(void){
                    
                    self.dialogBackgroundView.alpha = 1.0;
                    
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
                    animation.fromValue = @(-self.dialog.height / 2.0);
                    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                    animation.toValue = @(self.dialog.layer.position.y);
                    animation.duration = 0.25;
                    [self.dialog.layer addAnimation:animation forKey:@"position"];
                }];
            }
                break;
            case SeaDialogAnimateFromBottom : {
                
                [UIView animateWithDuration:0.25 animations:^(void){
                    
                    self.dialogBackgroundView.alpha = 1.0;
                    
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
                    animation.fromValue = @(self.view.height + self.dialog.height / 2);
                    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                    animation.toValue = @(self.dialog.layer.position.y);
                    animation.duration = 0.25;
                    [self.dialog.layer addAnimation:animation forKey:@"position"];
                }];
            }
                break;
            case SeaDialogAnimateCustom : {
                
                [self didExecuteDialogShowCustomAnimate:^(BOOL finish){
                    
                }];
            }
                break;
        }
    }
    
}

- (void)dismissDialog
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    switch (self.dialogDismissAnimate) {
        case SeaDialogAnimateNone : {
            [self onDialogDismiss];
        }
            break;
        case SeaDialogAnimateScale : {
            
            [UIView animateWithDuration:0.25 animations:^(void){
                
                [self setNeedsStatusBarAppearanceUpdate];
                self.dialogBackgroundView.alpha = 0;
                self.dialog.alpha = 0;
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation.fromValue = @(1.0);
                animation.toValue = @(1.3);
                animation.duration = 0.25;
                animation.fillMode = kCAFillModeForwards;
                animation.removedOnCompletion = NO;
                [self.dialog.layer addAnimation:animation forKey:@"scale"];
                
            }completion:^(BOOL finish){
                [self onDialogDismiss];
            }];
        }
            break;
        case SeaDialogAnimateFromTop : {
            
            [UIView animateWithDuration:0.25 animations:^(void){
                
                [self setNeedsStatusBarAppearanceUpdate];
                self.dialogBackgroundView.alpha = 0;
                
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
                animation.fromValue = @(self.dialog.layer.position.y);
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                animation.toValue = @(- self.dialog.height / 2.0);
                animation.duration = 0.25;
                animation.fillMode = kCAFillModeForwards;
                animation.removedOnCompletion = NO;
                [self.dialog.layer addAnimation:animation forKey:@"position"];
                
            }completion:^(BOOL finish){
                [self onDialogDismiss];
            }];
        }
            break;
        case SeaDialogAnimateFromBottom : {
            
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.dialogBackgroundView.alpha = 0;
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
                animation.fromValue = @(self.dialog.layer.position.y);
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                animation.toValue = @(self.view.height + self.dialog.height / 2);
                animation.duration = 0.25;
                animation.fillMode = kCAFillModeForwards;
                animation.removedOnCompletion = NO;
                [self.dialog.layer addAnimation:animation forKey:@"position"];
            }completion:^(BOOL finish){
                
                [self onDialogDismiss];
            }];
        }
            break;
        case SeaDialogAnimateCustom : {
            
            WeakSelf(self);
            [self didExecuteDialogDismissCustomAnimate:^(BOOL finish){
                
                [weakSelf onDialogDismiss];
            }];
        }
            break;
    }
}

///消失动画完成
- (void)onDialogDismiss
{
    [self dismissViewControllerAnimated:NO completion:self.dialogDismissCompletionHandler];
}

- (void)didExecuteDialogShowCustomAnimate:(void(^)(BOOL finish)) completion
{
    !completion ?: completion(YES);
}

- (void)didExecuteDialogDismissCustomAnimate:(void(^)(BOOL finish)) completion
{
    !completion ?: completion(YES);
}

- (void)adjustDialogPosition
{
    CGFloat y = 0;
    if(self.keyboardHidden){
        y = self.view.height / 2.0;
    }else{
        y = MIN(self.view.height / 2.0, self.view.height - self.keyboardFrame.size.height - self.dialog.height / 2.0 - 10.0);
    }
    
    NSLayoutConstraint *constraint = self.dialog.sea_centerYLayoutConstraint;
    [UIView animateWithDuration:0.25 animations:^(void){
        
        if(constraint){
            constraint.constant = y - self.view.height / 2.0;
            [self.view layoutIfNeeded];
        }else{
            self.dialog.centerY = y - self.view.height / 2.0;
        }
    }];
}

@end
