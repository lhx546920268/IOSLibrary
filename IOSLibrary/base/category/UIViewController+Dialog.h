//
//  UIViewController+Dialog.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/4/28.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///弹窗动画类型
typedef NS_ENUM(NSInteger, SeaDialogAnimate)
{
    ///无动画
    SeaDialogAnimateNone = 0,
    
    ///缩放
    SeaDialogAnimateScale,
    
    ///从上进入
    SeaDialogAnimateFromTop,
    
    ///从下进入
    SeaDialogAnimateFromBottom,
    
    ///自定义
    SeaDialogAnimateCustom,
};

/**
 弹窗类目
 如果 UIViewController 是 SeaViewController 或者其子类，并且没有使用xib，dialog属性将自动设置为 SeaContainer
 此时 self.view 将不再是 SeaContainer
 */
@interface UIViewController (Dialog)

/**
 是否以弹窗的样式显示 default is 'NO'
 */
@property(nonatomic,readonly) BOOL isShowAsDialog;

/**
 弹窗 子类可在 viewDidLoad中设置，设置后会不会自动添加到view中，要自己设置对应的约束
 如果 UIViewController 是 SeaViewController 或者其子类，并且没有使用xib，dialog属性将自动设置为 SeaContainer
 */
@property(nonatomic,strong) UIView *dialog;

/**
 是否要点击透明背景dismiss default is 'YES'
 */
@property(nonatomic,assign) BOOL shouldDismissDialogOnTapTranslucent;

/**
 背景视图
 */
@property(nonatomic,readonly) UIView *dialogBackgroundView;

/**
 点击背景手势
 */
@property(nonatomic,readonly) UITapGestureRecognizer *tapDialogBackgroundGestureRecognizer;

/**
 出现动画 default is 'SeaDialogAnimateNone'
 */
@property(nonatomic,assign) SeaDialogAnimate dialogShowAnimate;

/**
 消失动画 default is 'SeaDialogAnimateNone'
 */
@property(nonatomic,assign) SeaDialogAnimate dialogDismissAnimate;

/**
 弹窗是否已显示
 */
@property(nonatomic,readonly) BOOL isDialogShowing;

/**
 显示动画完成回调
 */
@property(nonatomic,copy) void(^dialogShowCompletionHandler)(void);

/**
 消失动画完成回调
 */
@property(nonatomic,copy) void(^dialogDismissCompletionHandler)(void);

/**
 显示 在 window.rootViewController.topest
 */
- (void)showAsDialog;

/**
 显示在指定viewController
 */
- (void)showAsDialogInViewController:(UIViewController*) viewController;

/**
 隐藏
 */
- (void)dismissDialog;

/**
 执行自定义显示动画 子类重写
 */
- (void)didExecuteDialogShowCustomAnimate:(void(^)(BOOL finish)) completion;

/**
 执行自定义消失动画 子类重写
 */
- (void)didExecuteDialogDismissCustomAnimate:(void(^)(BOOL finish)) completion;

/**
 键盘弹出来，调整弹窗位置，子类可重写
 */
- (void)adjustDialogPosition;

@end
