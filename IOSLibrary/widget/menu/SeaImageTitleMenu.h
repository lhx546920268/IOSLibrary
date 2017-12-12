//
//  SeaImageTitleMenu.h

//

#import <UIKit/UIKit.h>

@class SeaImageTitleMenu;
@class SeaImageTitleMenuItem;

/**图片和文字组成的菜单代理
 */
@protocol SeaImageTitleMenuDelegate <NSObject>

/**选中某个菜单
 */
- (void)imageTitleMenu:(SeaImageTitleMenu*) menu didSelectItemAtIndex:(NSInteger) index;


@end

/**图片和文字组成的菜单，图片在上，文字在下
 */
@interface SeaImageTitleMenu : UIView

@property(nonatomic,weak) id<SeaImageTitleMenuDelegate> delegate;

/**图标 数组元素是UIImage
 */
@property(nonatomic,strong) NSArray *images;

/**标题 数组元素是NSString
 */
@property(nonatomic,strong) NSArray *titles;

/**菜单按钮高度 default is '80.0'
 */
@property(nonatomic,assign) CGFloat itemHeight;

/**每行多少个菜单按钮 default is '4'
 */
@property(nonatomic,assign) NSInteger numberOfColumns;

/**菜单按钮字体颜色 default is '[UIColor blackColor]'
 */
@property(nonatomic,strong) UIColor *titleColor;

/**菜单字体
 */
@property(nonatomic,strong) UIFont *titleFont;

/**边距 defult is 'UIEdgeInsetsMake(8.0, 0, 0, 0)'
 */
@property(nonatomic,assign) UIEdgeInsets insets;

/**构造方法 图标的数量要和标题的数量一致
 *@param images 图标 数组元素是UIImage
 *@param titles 标题 数组元素是NSString
 *@return 一个初始化的 SeaImageTitleMenu
 */
- (id)initWithFrame:(CGRect)frame images:(NSArray*) images titles:(NSArray*) titles;

/**重新加载数据
 */
- (void)reloadData;

/**获取按钮
 */
- (SeaImageTitleMenuItem*)menuItemForIndex:(NSInteger) index;

@end
