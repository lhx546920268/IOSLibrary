//
//  SeaSlideViewController.h
//  Sea

//

#import <UIKit/UIKit.h>

/**侧滑菜单目前显示视图的位置
 */
typedef NS_ENUM(NSInteger, SeaSlideViewPosition)
{
    SeaSlideViewPositionMiddle = 0, //中间
    SeaSlideViewPositionLeft = 1, //左边
    SeaSlideViewPositionRight = 2, //右边
};

@class SeaSlideViewController;

@protocol SeaSlideViewControllerDelegate <NSObject>

/**视图位置将要改变
 */
- (void)slideViewController:(SeaSlideViewController*) slide willTransitionPosition:(SeaSlideViewPosition) fromPosition toPosition:(SeaSlideViewPosition) toPosition;

/**视图位置已经改变
 */
- (void)slideViewController:(SeaSlideViewController*) slide didTransitionPosition:(SeaSlideViewPosition) fromPosition toPosition:(SeaSlideViewPosition) toPosition;

@end

/**侧滑菜单
 */
@interface SeaSlideViewController : UIViewController<UIGestureRecognizerDelegate>

/**代理集合，数组元素是 id<SeaSlideViewControllerDelegate> delegate
 */
@property(nonatomic,strong) NSMutableArray *delegates;

/**中间视图 不能为空
 */
@property(nonatomic,strong) UIViewController *middleViewController;

/**左边视图
 */
@property(nonatomic,strong) UIViewController *leftViewController;

/**右边视图
 */
@property(nonatomic,strong) UIViewController *rightViewController;

/**添加滑动手势的 view , default is 'nil', 在 SeaSlideViewController.view 中添加
 */
@property(nonatomic,weak) UIView *panGestureRecognizerInView;

/**左边视图宽度 default is '260.0 / 320.0 * SeaScreenWidth'
 */
@property(nonatomic,assign) CGFloat leftViewWidth;

/**左边视图宽度 default is '260.0 / 320.0 * SeaScreenWidth'
 */
@property(nonatomic,assign) CGFloat rightViewWidth;

/**侧滑菜单目前显示视图的位置 default is 'SeaSlideViewPosition'
 */
@property(nonatomic,assign) SeaSlideViewPosition position;

/**视图是否被导航栏控制，default is 'NO'，如果 YES，将在视图出现时隐藏导航栏，视图消失时 显示导航栏
 */
@property(nonatomic,assign) BOOL controlByNavigationController;

/**构造方法
 *@param middleViewController 中间视图 不能为空
 *@param leftViewController 左边视图
 *@param rightViewController 右边视图
 *@return 一个实例
 */
- (id)initWithMiddleViewController:(UIViewController*) middleViewController
                leftViewController:(UIViewController*) leftViewController
                rightViewController:(UIViewController*) rightViewController;

/**动画设置当前显示的视图位置
 *@param position 新的位置
 *@param flag 是否动画
 */
- (void)setPosition:(SeaSlideViewPosition)position animate:(BOOL) flag;

@end

@interface UIViewController (SeaSlideViewControllerExtentions);

/**获取侧滑菜单控制视图
 */
- (SeaSlideViewController*)slideViewController;

@end
