//
//  SeaDialogViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/16.
//  Copyright (c) 2015年 罗海雄. All rights reserved.
//

#import "SeaViewController.h"

///弹窗动画类型
typedef NS_ENUM(NSInteger, SeaDialogAnimate)
{
    ///无动画
    SeaDialogAnimateNone = 0,
    
    ///缩放
    SeaDialogAnimateScale,
    
    ///上下
    SeaDialogAnimateUpDown,
    
    ///自定义
    SeaDialogAnimateCustom,
};

/**
 弹窗视图控制器
 */
@interface SeaDialogViewController : SeaViewController

/**
 弹窗 子类可在 viewDidLoad中设置，设置后会不会自动添加到view中，要自己设置对应的约束
 */
@property(nonatomic,strong) UIView *dialog;

/**
 是否要点击透明背景dismiss default is 'YES'
 */
@property(nonatomic,assign) BOOL shouldDismissOnTapTranslucent;

/**
 背景视图
 */
@property(nonatomic,readonly) UIView *backgroundView;

/**
 出现动画 default is 'SeaDialogAnimateNone'
 */
@property(nonatomic,assign) SeaDialogAnimate showAnimate;

/**
 消失动画 default is 'SeaDialogAnimateNone'
 */
@property(nonatomic,assign) SeaDialogAnimate dismissAnimate;

/**
 是否已显示
 */
@property(nonatomic,readonly) BOOL isShowing;

/**
 键盘是否隐藏
 */
@property(nonatomic,readonly) BOOL keyboardHidden;

/**
 键盘大小
 */
@property(nonatomic,readonly) CGRect keyboardFrame;

/**
 显示动画完成回调
 */
@property(nonatomic,copy) void(^showCompletionHandler)(void);

/**
 消失动画完成回调
 */
@property(nonatomic,copy) void(^dismissCompletionHandler)(void);

/**
 通过内容视图创建 如果内部的约束不能确定 dialog大小，要自己设置dialog的约束大小
 */
- (instancetype)initWithDialog:(UIView*) dialog;

/**
 显示 在 window.rootViewController
 */
- (void)show;

/**
 显示在指定viewController
 */
- (void)showInViewController:(UIViewController*) viewController;

/**
 隐藏
 */
- (void)dismiss;

/**
 执行自定义显示动画 子类重写
 */
- (void)didExecuteShowCustomAnimate:(void(^)(BOOL finish)) completion;

/**
 执行自定义消失动画 子类重写
 */
- (void)didExecuteDismissCustomAnimate:(void(^)(BOOL finish)) completion;

- (void)viewDidLayoutSubviews NS_REQUIRES_SUPER;

@end
