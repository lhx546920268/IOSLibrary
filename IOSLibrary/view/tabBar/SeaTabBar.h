//
//  SeaTabBar.h

//

#import <UIKit/UIKit.h>

#define _SeaTabBarHeight_ 48.0

@class SeaTabBar;

/**选项卡代理
 */
@protocol SeaTabBarDelegate <NSObject>

/**选中第几个
 */
- (void)tabBar:(SeaTabBar*) tabBar didSelectItemAtIndex:(NSInteger) index;

@optional

/**是否可以下第几个 default is 'YES'
 */
- (BOOL)tabBar:(SeaTabBar*) tabBar shouldSelectItemAtIndex:(NSInteger) index;

@end

/**选项卡
 */
@interface SeaTabBar : UIView

/**选项卡按钮 数值元素是 SeaTabBarItem
 */
@property(nonatomic,readonly,copy) NSArray *items;

/**背景视图 default is 'nil' ,如果设置，大小会调节到选项卡的大小
 */
@property(nonatomic,strong) UIView *backgroundView;

/**设置选中 default is 'NSNotFound'
 */
@property(nonatomic,assign) NSInteger selectedIndex;

/**选中按钮的背景颜色 default is 'nil'
 */
@property(nonatomic,strong) UIColor *selectedButtonBackgroundColor;

/**分割线
 */
@property(nonatomic,readonly) UIView *separatorLine;


@property(nonatomic,weak) id<SeaTabBarDelegate> delegate;

/**构造方法
 *@param frame 位置大小
 *@param items 选项卡按钮 数值元素是 SeaTabBarItem
 *@return 一个实例
 */
- (id)initWithFrame:(CGRect)frame items:(NSArray*) items;

/**设置选项卡边缘值
 *@param badgeValue 边缘值
 *@param index 下标
 */
- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSInteger) index;

@end
