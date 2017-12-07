//
//  SeaDialogViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/16.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

@class SeaDialogViewController;

///弹窗动画类型
typedef NS_ENUM(NSInteger, SeaDialogAnimate)
{
    ///无动画
    SeaDialogAnimateNone = 0,
    
    ///缩放
    SeaDialogAnimateScale = 1,
    
    ///上下
    SeaDialogAnimateUpDown = 2,
};

/**弹窗
 */
@interface SeaDialog : UIView

///视图控制器
@property(nonatomic,weak) SeaDialogViewController *dialogViewController;

///出现动画 default is 'SeaDialogAnimateNone'
@property(nonatomic,assign) SeaDialogAnimate showAnimate;

///消失动画 default is 'SeaDialogAnimateNone'
@property(nonatomic,assign) SeaDialogAnimate dismissAnimate;

//内容目标frame 用于 SeaDialogAnimateUpDown 动画，如果不设置，将使用默认的
@property(nonatomic,assign) CGRect targetFrame;

///显示动画完成回调
@property(nonatomic,copy) void(^showCompletionHandler)(void);

///消失动画完成回调 不要在回调中调用 dialogViewController dismiss
@property(nonatomic,copy) void(^dismissCompletionHandler)(void);

/**显示 如果 dialogViewController == nil,会调用 showWithDialogViewController
 */
- (void)show;

/**显示 自动创建 视图控制器 SeaDialogViewController
 */
- (void)showWithDialogViewController;

/**关闭
 */
- (void)dismiss;

@end

/**弹窗视图控制器
 */
@interface SeaDialogViewController : SeaViewController

/**弹窗 SeaDialog 或其子类 设置后在viewDidLoad中自动添加到self.view
 */
@property(nonatomic,strong) SeaDialog *dialog;

///显示动画完成回调
@property(nonatomic,copy) void(^showCompletionHandler)(void);

///消失动画完成回调 
@property(nonatomic,copy) void(^dismissCompletionHandler)(void);


/**显示 在 window.rootViewController 
 */
- (void)show;

/**显示在指定viewController
 */
- (void)showInViewController:(UIViewController*) viewController;

/**隐藏
 */
- (void)dismiss;

@end
