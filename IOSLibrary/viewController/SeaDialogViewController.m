//
//  SeaDialogViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/16.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "SeaDialogViewController.h"
#import "UIView+Utilities.h"
#import "SeaBasic.h"
#import "UIViewController+Utilities.h"

@interface SeaDialog ()

/**键盘是否隐藏
 */
@property(nonatomic,readonly) BOOL keyboardHidden;

/**键盘大小
 */
@property(nonatomic,readonly) CGRect keyboardFrame;


@end

@implementation SeaDialog

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initlization];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initlization];
    }
    return self;
}

///初始化
- (void)initlization
{
    self.alpha = 0.0;
    self.showAnimate = SeaDialogAnimateNone;
    self.dismissAnimate = SeaDialogAnimateNone;
}

- (void)dealloc
{
    [self removeKeyboardNotification];
}

/**显示
 */
- (void)show;
{
   if(self.dialogViewController)
   {
       switch (self.showAnimate)
       {
           case SeaDialogAnimateNone :
           {
               self.alpha = 1.0;
               [self showDidFinish];
           }
               break;
           case SeaDialogAnimateScale :
           {
               [UIView animateWithDuration:0.25 animations:^(void){
                   
                   self.alpha = 1.0;
                   
                   CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                   animation.fromValue = [NSNumber numberWithFloat:1.3];
                   animation.toValue = [NSNumber numberWithFloat:1.0];
                   animation.duration = 0.25;
                   [self.layer addAnimation:animation forKey:@"scale"];
                   
               }completion:^(BOOL finish){
                   
                   [self showDidFinish];
               }];
           }
               break;
           case SeaDialogAnimateUpDown :
           {
               self.alpha = 1.0;
               self.top = -self.height;
               
               [UIView animateWithDuration:0.25 animations:^(void){
                   
                   if(CGRectEqualToRect(CGRectZero, self.targetFrame))
                   {
                       self.top = (self.dialogViewController.view.height - self.height) / 2.0;
                   }
                   else
                   {
                       self.frame = self.targetFrame;
                   }
               }completion:^(BOOL finish){
                   
                   [self showDidFinish];
               }];
           }
               break;
       }
    }
    else
    {
        [self showWithDialogViewController];
    }
}

/**显示 自动创建 视图控制器 SeaDialogViewController
 */
- (void)showWithDialogViewController
{
#if SeaDebug
    NSAssert(self.dialogViewController == nil, @"dialog 弹窗已经显示");
#endif
    
    ///创建视图控制器，并显示
    SeaDialogViewController *dialogViewController = [[SeaDialogViewController alloc] init];
    self.dialogViewController = dialogViewController;
    dialogViewController.dialog = self;
    [dialogViewController show];
}

///显示动画完成
- (void)showDidFinish
{
    self.targetFrame = self.frame;
    [self addKeyboardNotification];
    !self.showCompletionHandler ?: self.showCompletionHandler();
    self.showCompletionHandler = nil;
}

/**关闭
 */
- (void)dismiss
{
    [self removeKeyboardNotification];
    
    switch (self.dismissAnimate)
    {
        case SeaDialogAnimateNone :
        {
            [self dismissDidFinish];
        }
            break;
        case SeaDialogAnimateScale :
        {
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.alpha = 0;
                
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation.fromValue = [NSNumber numberWithFloat:1.0];
                animation.toValue = [NSNumber numberWithFloat:1.3];
                animation.duration = 0.25;
                [self.layer addAnimation:animation forKey:@"scale"];
                
            }completion:^(BOOL finish){
                
                [self dismissDidFinish];
            }];
        }
            break;
        case SeaDialogAnimateUpDown :
        {

            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.top = - self.height;
            }completion:^(BOOL finish){
                
                [self dismissDidFinish];
            }];
        }
            break;
    }
}

///消失动画完成
- (void)dismissDidFinish
{
    !self.dismissCompletionHandler ?: self.dismissCompletionHandler();
    self.dismissCompletionHandler = nil;
    [self.dialogViewController dismiss];
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
    if(self.keyboardHidden)
    {
        y = self.targetFrame.origin.y;
    }
    else
    {
        _keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        y = MIN(self.targetFrame.origin.y, _height_ - _keyboardFrame.size.height - self.targetFrame.size.height - 20.0);
    }
    
    [UIView animateWithDuration:0.25 animations:^(void){
        
        self.top = y;
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

@interface SeaDialogViewController ()

/**以前的ViewController
 */
@property(nonatomic,weak) UIViewController *previousPresentViewController;

/**以前的弹出样式
 */
@property(nonatomic,assign) UIModalPresentationStyle previousPresentationStyle;

@end

@implementation SeaDialogViewController

#pragma mark- 视图消失出现

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    SeaNavigationController *nav = (SeaNavigationController*)self.navigationController;
    nav.targetStatusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    SeaNavigationController *nav = (SeaNavigationController*)self.navigationController;
    nav.targetStatusBarStyle = WMStatusBarStyle;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    if(self.dialog)
    {
        [self.view addSubview:self.dialog];
        [self.dialog show];
    }
}

- (void)setDialog:(SeaDialog *)dialog
{
    if(_dialog != dialog)
    {
        [_dialog removeFromSuperview];
        _dialog = dialog;
    }
}

#pragma mark- public method

/**显示 在 window.rootViewController
 */
- (void)show
{
    [self showInViewController:[[UIApplication sharedApplication].keyWindow.rootViewController topestPresentedViewController]];
}

- (void)showInViewController:(UIViewController *)viewController
{
    UINavigationController *nav = [self createdInNavigationController];
    
    ///设置使背景透明
    if(_ios8_0_)
    {
        nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    else
    {
        self.previousPresentViewController = viewController;
        self.previousPresentationStyle = self.previousPresentViewController.modalPresentationStyle;
        self.previousPresentViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [viewController presentViewController:nav animated:NO completion:self.showCompletionHandler];
}

/**隐藏
 */
- (void)dismiss
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.previousPresentViewController.modalPresentationStyle = self.previousPresentationStyle;
    [self dismissViewControllerAnimated:NO completion:self.dismissCompletionHandler];
}

@end
