//
//  SeaGridronMenu.h

//

#import <UIKit/UIKit.h>
#import "SeaMenuItemInfo.h"

@class SeaGridronMenu;


/**九宫格式的菜单代理
 */
@protocol SeaGridronMenuDelegate <NSObject>

/**选择菜单按钮
 */
- (void)gridronMenu:(SeaGridronMenu*) menu didSelectItemAtIndex:(NSInteger) index;

@end

/**九宫格式的菜单
 */
@interface SeaGridronMenu : UIView

/**是否显示方格，default is ’YES‘
 */
@property(nonatomic,assign) BOOL showGrid;

/**方格颜色线条颜色
 */
@property(nonatomic,strong) UIColor *gridLineColor;

/**方格线条宽度 default is '0.5'
 */
@property(nonatomic,assign) CGFloat gridLineWidth;

/**菜单按钮字体颜色 default is '[UIColor blackColor]'
 */
@property(nonatomic,strong) UIColor *titleColor;

/**菜单按钮字体高亮颜色 default is '[UIColor blueColor]'
 */
@property(nonatomic,strong) UIColor *titleHightlightColor;

/**菜单字体
 */
@property(nonatomic,strong) UIFont *titleFont;

/**每行菜单按钮数量 default is '4'
 */
@property(nonatomic,assign) NSInteger countPerRow;

/**菜单按钮高度 default is '35.0'
 */
@property(nonatomic,assign) CGFloat menuItemHeight;

@property(nonatomic,weak) id<SeaGridronMenuDelegate> delegate;

/**构造方法
 *@param frame 位置大小 高度会根据 标题数量调整
 *@param infos 按钮信息 数组元素是 SeaMenuItemInfo对象
 *@return 已初始化的 SeaGridronMenu
 */
- (id)initWithFrame:(CGRect)frame infos:(NSArray*) infos;

@end
