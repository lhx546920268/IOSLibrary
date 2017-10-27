//
//  SeaTabBarViewController.h

//

#import <UIKit/UIKit.h>

/**选项卡按钮信息
 */
@interface SeaTabBarItemInfo : NSObject

/**按钮标题
 */
@property(nonatomic,strong) NSString *title;

/**按钮未选中图标
 */
@property(nonatomic,strong) UIImage *normalImage;

/**按钮选中图标
 */
@property(nonatomic,strong) UIImage *selectedImage;

/**关联的控制器
 */
@property(nonatomic,strong) UIViewController *viewController;

/**便利构造方法
 *@return 一个实例
 */
+ (instancetype)infoWithTitle:(NSString*) title normalImage:(UIImage*) normalImage selectedImage:(UIImage*) selectedImage viewController:(UIViewController*) viewControllr;

/**便利构造方法
 *@return 一个实例
 */
+ (instancetype)infoWithTitle:(NSString*) title normalImage:(UIImage*) normalImage viewController:(UIViewController*) viewControllr;

@end

@class SeaTabBar, SeaTabBarController;

///选项卡控制器代理
@protocol SeaTabBarControllerDelegate <NSObject>

@optional

/**是否可以选择某个按钮 default is 'YES'
 */
- (BOOL)sea_tabBarController:(SeaTabBarController*) tabBarController shouldSelectAtIndex:(NSInteger) index;

@end

/**选项卡控制器
 */
@interface SeaTabBarController : UIViewController

/**选中的视图 default is '0'
 */
@property(nonatomic,assign) NSInteger selectedIndex;

/**当前显示的 viewController
 */
@property(nonatomic,readonly) UIViewController *selectedViewController;

/**选项卡按钮 数组元素是 SeaTabBarItem
 */
@property(nonatomic,readonly,copy) NSArray *tabBarItems;

/**选项卡按钮信息 数值元素是 SeaTabBarItemInfo
 */
@property(nonatomic,readonly,copy) NSArray *itemInfos;

/**选项卡
 */
@property(nonatomic,readonly) SeaTabBar *tabBar;

@property(nonatomic,weak) id<SeaTabBarControllerDelegate> delegate;

/**构造方法
 *@param itemInfos 选项卡按钮 数组元素是 SeaTabBarItemInfo
 *@return 一个实例
 */
- (id)initWithItemInfos:(NSArray*) itemInfos;

/**设置选项卡的状态
 *@param hidden 是否隐藏
 *@param animated 是否动画
 */
- (void)setTabBarHidden:(BOOL) hidden animated:(BOOL) animated;

/**设置选项卡边缘值
 *@param badgeValue 边缘值
 *@param index 下标
 */
- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSInteger) index;

#pragma mark- statusBar

/**设置状态栏的隐藏状态
 */
- (void)setStatusBarHidden:(BOOL)hidden;

/**设置状态栏样式
 */
- (void)setStatusBarStyle:(UIStatusBarStyle) style;

/**获取指定的viewController
 *@param index 下标
 */
- (UIViewController*)viewControllerForIndex:(NSInteger) index;

@end
