//
//  SeaViewController.h

//
//

#import <UIKit/UIKit.h>

@class SeaContainer;

/**
 控制视图的基类
 @warning 如果你需要使用 xib，请继承 UIViewController
 */
@interface SeaViewController : UIViewController

///固定在顶部的视图
@property(nonatomic, strong) UIView *topView;

///固定在底部的视图
@property(nonatomic, strong) UIView *bottomView;

///内容视图
@property(nonatomic, strong) UIView *contentView;

///视图容器 self.view
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

- (void)viewDidLayoutSubviews NS_REQUIRES_SUPER;

@end
