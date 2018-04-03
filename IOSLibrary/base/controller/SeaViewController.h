//
//  SeaViewController.h

//
//

#import <UIKit/UIKit.h>

@class SeaContainer, SeaHttpTask;

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

///视图容器 self.view xib 不要用
@property(nonatomic, readonly) SeaContainer *container;

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

- (void)viewDidLayoutSubviews NS_REQUIRES_SUPER;

@end
