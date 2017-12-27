//
//  SeaPartialPresentTransitionDelegate.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/11.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import "SeaPresentTransitionDelegate.h"

///使用方法

/*
 UIViewController *viewController = [[UIViewController alloc] init];
 UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];

 viewController.view.backgroundColor = [UIColor whiteColor];

 nav.view.frame = CGRectMake(0, 0, SeaScreenWidth, SeaScreenHeight - 200.0);
 self.p_delegate = [[SeaPartialPresentTransitionDelegate alloc] init]; ///delegate要保存起来
 nav.transitioningDelegate = self.p_delegate;

 [self.navigationController presentViewController:nav animated:YES completion:nil];
 */

/**可部分地显示present出来UIViewController，通过init初始化，设置UIViewController 的 sea_transitionDelegate来使用
 *@warning UIViewController中的 transitioningDelegate 是 weak引用
 */
@interface SeaPartialPresentTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

///背景颜色
@property(nonatomic,strong) UIColor *backgroundColor;

///后面的viewController 动画效果
@property(nonatomic,assign) CGAffineTransform backTransform;

///点击背景是否会关闭当前显示的viewController，default is 'YES'
@property(nonatomic,assign) BOOL dismissWhenTapBackground;

///动画时间 default is '0.35'
@property(nonatomic,assign) NSTimeInterval duration;

///动画样式 default is 'SeaPresentTransitionStyleCoverVertical'
@property(nonatomic,assign) SeaPresentTransitionStyle transitionStyle;

//消失时的回调
@property(nonatomic,copy) void(^dismissHandler)(void);

@end
