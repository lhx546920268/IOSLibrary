//
//  SeaViewController.h

//
//

#import <UIKit/UIKit.h>

@class SeaContainer;

/**控制视图的基类
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

@end
