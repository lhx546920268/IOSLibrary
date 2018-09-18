//
//  SeaPresentTransitionDelegate.h
//  IOSLibrary
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///动画样式
typedef NS_ENUM(NSInteger, SeaPresentTransitionStyle)
{
    ///水平覆盖
    SeaPresentTransitionStyleCoverHorizontal = 0,
    
    ///垂直覆盖
    SeaPresentTransitionStyleCoverVertical,
};

/**自定义Present类型的过度动画代理 效果类似UINavigationController push 通过init初始化，设置UIViewController 的 sea_transitionDelegate来使用 
 *@warning UIViewController中的 transitioningDelegate 是 weak引用
 */
@interface SeaPresentTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

///当活动的视图的占整体的百分比达到此值时，停止手势时，将自动完成后面的动画 范围 0.1 ~ 1.0，default is '0.5'
@property(nonatomic,assign) float completePercent;

///动画样式 default is 'SeaPresentTransitionStyleCoverHorizontal'
@property(nonatomic,assign) SeaPresentTransitionStyle transitionStyle;

///动画时间 default is '0.25'
@property(nonatomic,assign) NSTimeInterval duration;

/**添加手势交互的过渡
 *@warning 如果两个viewController 的切换，会有两种状态栏样式切换，会导致 当 InteractiveTransition 取消时，动画回调completion不调动，导致整个交互动画没完成，从而影响下一次过度动画无法执行
 *@solution 要在第一个 viewController 的 viewDidDisappear中 把状态栏的样式设置成和第二个viewController 的状态栏样式一致，然后在 viewDidAppear 中把 状态栏的样式设置成原来的
 */
- (void)addInteractiveTransitionToViewController:(UIViewController*) viewController;

/**快捷的方法使用 SeaPresentTransitionDelegate 
 *@param vc 被push的
 *@param flag 是否使用导航栏
 *@param parentedViewConttroller push的
 */
+ (UINavigationController*)pushViewController:(UIViewController*) vc useNavigationBar:(BOOL) flag parentedViewConttroller:(UIViewController*) parentedViewConttroller;

@end
