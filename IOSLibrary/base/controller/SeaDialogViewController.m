//
//  SeaDialogViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/16.
//  Copyright (c) 2015年 罗海雄. All rights reserved.
//

#import "SeaDialogViewController.h"
#import "UIView+Utils.h"
#import "SeaBasic.h"
#import "UIViewController+Utils.h"
#import "SeaNavigationController.h"
#import "UIView+SeaAutoLayout.h"

@interface SeaDialogViewController ()

///是否要动画
@property(nonatomic, assign) BOOL shouldAnimate;

///状态栏样式
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end

@implementation SeaDialogViewController

- (instancetype)initWithDialog:(UIView*) dialog
{
    self = [super init];
    if(self){
        
        self.dialog = dialog;
    }
    
    return self;
}

#pragma mark- 视图消失出现

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _keyboardHidden = YES;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    _backgroundView = [UIView new];
    _backgroundView.alpha = 0;
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:_backgroundView];
    
    [_backgroundView sea_insetsInSuperview:UIEdgeInsetsZero];
    
    self.shouldAnimate = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLayoutSubviews
{
    //出场动画
    if(self.dialog && self.shouldAnimate){
        self.shouldAnimate = NO;
        
        switch (self.showAnimate) {
            case SeaDialogAnimateNone : {
                self.backgroundView.alpha = 1.0;
            }
                break;
            case SeaDialogAnimateScale : {
                
                self.dialog.alpha = 0;
                [UIView animateWithDuration:0.25 animations:^(void){
                    
                    self.backgroundView.alpha = 1.0;
                    self.dialog.alpha = 1.0;
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                    animation.fromValue = @(1.3);
                    animation.toValue = @(1.0);
                    animation.duration = 0.25;
                    [self.dialog.layer addAnimation:animation forKey:@"scale"];
                    
                }];
            }
                break;
            case SeaDialogAnimateUpDown : {
                self.backgroundView.alpha = 1.0;
                
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
                animation.fromValue = @(-self.dialog.height / 2.0);
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                animation.toValue = @(self.dialog.layer.position.y);
                animation.duration = 0.25;
                [self.dialog.layer addAnimation:animation forKey:@"position"];
            }
                break;
            case SeaDialogAnimateCustom : {

                [self didExecuteShowCustomAnimate:^(BOOL finish){
                    
                }];
            }
                break;
        }
    }
}

#pragma mark- public method

- (void)show
{
    [self showInViewController:[[UIApplication sharedApplication].keyWindow.rootViewController sea_topestPresentedViewController]];
}

- (void)showInViewController:(UIViewController *)viewController
{
    ///设置使背景透明
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [viewController presentViewController:self animated:NO completion:self.showCompletionHandler];
}

- (void)dismiss
{
    self.statusBarStyle = UIStatusBarStyleDefault;
    switch (self.dismissAnimate) {
        case SeaDialogAnimateNone : {
            [self dismissDidFinish];
        }
            break;
        case SeaDialogAnimateScale : {
            
            [UIView animateWithDuration:0.25 animations:^(void){
                
                [self setNeedsStatusBarAppearanceUpdate];
                self.backgroundView.alpha = 0;
                self.dialog.alpha = 0;
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation.fromValue = @(1.0);
                animation.toValue = @(1.3);
                animation.duration = 0.25;
                [self.dialog.layer addAnimation:animation forKey:@"scale"];
                
            }completion:^(BOOL finish){
                [self dismissDidFinish];
            }];
        }
            break;
        case SeaDialogAnimateUpDown : {
            self.backgroundView.alpha = 1.0;
            
            [UIView animateWithDuration:0.25 animations:^(void){
                
                [self setNeedsStatusBarAppearanceUpdate];
                self.backgroundView.alpha = 0;
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
                animation.fromValue = @(self.dialog.layer.position.y);
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                animation.toValue = @(- self.dialog.height / 2.0);
                animation.duration = 0.25;
                animation.fillMode = kCAFillModeForwards;
                animation.removedOnCompletion = NO;
                [self.dialog.layer addAnimation:animation forKey:@"position"];
                
            }completion:^(BOOL finish){
                [self dismissDidFinish];
            }];
        }
            break;
        case SeaDialogAnimateCustom : {
            
            WeakSelf(self);
            [self didExecuteDismissCustomAnimate:^(BOOL finish){
               
                [weakSelf dismissDidFinish];
            }];
        }
            break;
    }
}

///消失动画完成
- (void)dismissDidFinish
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self dismissViewControllerAnimated:NO completion:self.dismissCompletionHandler];
}

- (void)didExecuteShowCustomAnimate:(void(^)(BOOL finish)) completion
{
    !completion ?: completion(YES);
}

- (void)didExecuteDismissCustomAnimate:(void(^)(BOOL finish)) completion
{
    !completion ?: completion(YES);
}

#pragma mark- CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self dismissDidFinish];
}

#pragma mark- 键盘

/**添加键盘监听
 */
- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

/**移除键盘监听
 */
- (void)removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

/**键盘高度改变
 */
- (void)keyboardWillChangeFrame:(NSNotification*) notification
{
    CGFloat y = 0;
    if(self.keyboardHidden){
        y = self.view.height / 2.0;
        _keyboardFrame = CGRectZero;
    }else{
        _keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        y = MIN(self.view.height / 2.0, self.view.height - _keyboardFrame.size.height - self.dialog.height / 2.0 - 10.0);
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

//键盘隐藏
- (void)keyboardWillHide:(NSNotification*) notification
{
    _keyboardHidden = YES;
    
    [self keyboardWillChangeFrame:notification];
}

//键盘显示
- (void)keyboardWillShow:(NSNotification*) notification
{
    _keyboardHidden = NO;
    [self keyboardWillChangeFrame:notification];
}

@end
