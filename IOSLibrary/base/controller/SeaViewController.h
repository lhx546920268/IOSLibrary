//
//  SeaViewController.h

//
//

#import <UIKit/UIKit.h>

@class SeaContainer, SeaHttpTask, SeaMultiTasks;

/**
 控制视图的基类
 */
@interface SeaViewController : UIViewController

///固定在顶部的视图 xib不要用
@property(nonatomic, strong) UIView *topView;

///固定在底部的视图 xib不要用
@property(nonatomic, strong) UIView *bottomView;

///内容视图 xib 不要用
@property(nonatomic, strong) UIView *contentView;

///视图容器 self.view xib 不要用，如果 showAsDialog = YES，self.view将不再是 container 且 要自己设置container的约束
@property(nonatomic, readonly) SeaContainer *container;

///是否已计算出frame，使用约束时用到
@property(nonatomic, readonly) BOOL isViewDidLayoutSubviews;

/**
 设置顶部视图
 
 @param topView 顶部视图
 @param height 视图高度，SeaWrapContent 为自适应
 */
- (void)setTopView:(UIView *)topView height:(CGFloat) height;

/**
 设置底部视图
 
 @param bottomView 底部视图
 @param height 视图高度，SeaWrapContent 为自适应
 */
- (void)setBottomView:(UIView *)bottomView height:(CGFloat) height;

/**
 添加需要取消的请求 在dealloc

 @param task 请求
 */
- (void)addCanceledTask:(SeaHttpTask*) task;

/**
 添加需要取消的请求队列 在 dealloc
 
 @param tasks 请求
 */
- (void)addCanceledTasks:(SeaMultiTasks*) tasks;

/**
 主要是用于要子类调用 super
 */
- (void)viewDidLayoutSubviews NS_REQUIRES_SUPER;

@end
