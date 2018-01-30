//
//  SeaTabBarViewController.h

//

#import "SeaViewController.h"

@class SeaTabBarItem;

/**选项卡按钮信息
 */
@interface SeaTabBarItemInfo : NSObject

/**
 按钮标题
 */
@property(nonatomic,strong) NSString *title;

/**
 按钮未选中图标 当selectedImage 为nil时，使用 UIImageRenderingModeAlwaysTemplate
 */
@property(nonatomic,strong) UIImage *normalImage;

/**
 按钮选中图标
 */
@property(nonatomic,strong) UIImage *selectedImage;

/**
 关联的控制器
 */
@property(nonatomic,strong) UIViewController *viewController;

/**
 便利构造方法
 *@return 一个实例
 */
+ (instancetype)infoWithTitle:(NSString*) title normalImage:(UIImage*) normalImage viewController:(UIViewController*) viewControllr;

/**
 便利构造方法
 *@return 一个实例
 */
+ (instancetype)infoWithTitle:(NSString*) title normalImage:(UIImage*) normalImage selectedImage:(UIImage*) selectedImage viewController:(UIViewController*) viewControllr;

@end

@class SeaTabBar, SeaTabBarController;

///选项卡控制器代理
@protocol SeaTabBarControllerDelegate <NSObject>

@optional

/**
 是否可以选择某个按钮 default is 'YES'
 */
- (BOOL)sea_tabBarController:(SeaTabBarController*) tabBarController shouldSelectAtIndex:(NSInteger) index;

@end

/**
 选项卡控制器
 */
@interface SeaTabBarController : SeaViewController

/**
 正常颜色 defaut is '[UIColor grayColor]'
 */
@property(nonatomic, strong) UIColor *normalColor;

/**
 选中颜色 default is 'SeaAppMainColor'
 */
@property(nonatomic, strong) UIColor *selectedColor;

/**
 字体 default is '11'
 */
@property(nonatomic, strong) UIFont *font;

/**
 选中的视图 default is '0'
 */
@property(nonatomic,assign) NSUInteger selectedIndex;

/**
 当前显示的 viewController
 */
@property(nonatomic,readonly) UIViewController *selectedViewController;

/**
 选项卡按钮
 */
@property(nonatomic,readonly,copy) NSArray<SeaTabBarItem*> *tabBarItems;

/**
 选项卡按钮信息
 */
@property(nonatomic,readonly,copy) NSArray<SeaTabBarItemInfo*> *itemInfos;

/**
 选项卡
 */
@property(nonatomic,readonly) SeaTabBar *tabBar;

/**
 代理
 */
@property(nonatomic,weak) id<SeaTabBarControllerDelegate> delegate;

/**
 构造方法
 *@param itemInfos 选项卡按钮
 *@return 一个实例
 */
- (id)initWithItemInfos:(NSArray<SeaTabBarItemInfo*>*) itemInfos;

/**
 设置选项卡边缘值
 *@param badgeValue 边缘值 @"" 为红点，要隐藏使用 nil
 *@param index 下标
 */
- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSInteger) index;

/**
 获取指定的viewController
 *@param index 下标
 */
- (UIViewController*)viewControllerForIndex:(NSUInteger) index;

@end
