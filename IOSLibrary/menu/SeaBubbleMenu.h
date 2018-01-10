//
//  SeaBubbleMenu.h

//

#import <UIKit/UIKit.h>

/**菜单箭头方向
 */
typedef NS_ENUM(NSInteger, SeaBubbleMenuArrowDirection)
{
    SeaBubbleMenuArrowDirectionLeft = 0, //向左
    SeaBubbleMenuArrowDirectionRight = 1, ///向右
    SeaBubbleMenuArrowDirectionTop = 2, ///向上
    SeaBubbleMenuArrowDirectionBottom = 3 ///向下
};

/**无色透明视图 点击时回收菜单
 */
@interface SeaBubbleMenuOverlay : UIView

@end

/**气泡菜单按钮信息
 */
@interface SeaBubbleMenuItemInfo : NSObject

/**标题
 */
@property(nonatomic,copy) NSString *title;

/**按钮图标
 */
@property(nonatomic,strong) UIImage *icon;

/**构造方法
 *@param title 标题
 *@param icon 图标
 *@return 已初始化的 SeaBubbleMenuItemInfo
 */
+ (id)infoWithTitle:(NSString*) title icon:(UIImage*) icon;

@end

/**气泡按钮cell
 */
@interface SeaBubbleMenuCell : UITableViewCell

/**按钮
 */
@property(nonatomic, readonly) UIButton *button;

/**分割线
 */
@property(nonatomic, readonly) UIView *line;

/**按钮内容边距
 */
@property(nonatomic, assign) UIEdgeInsets contentInsets;

@end

@class SeaBubbleMenu;

/**气泡菜单代理
 */
@protocol SeaBubbleMenuDelegate <NSObject>

@optional

/**点击某个按钮
 */
- (void)bubbleMenu:(SeaBubbleMenu *) menu didSelectedAtIndex:(NSInteger) index;

/**菜单将要显示
 */
- (void)bubbleMenuWillShow:(SeaBubbleMenu *) menu;

/**菜单已经显示
 */
- (void)bubbleMenuDidShow:(SeaBubbleMenu *) menu;

/**菜单将要消失
 */
- (void)bubbleMenuWillDismiss:(SeaBubbleMenu *) menu;

/**菜单已经消失
 */
- (void)bubbleMenuDidDismissed:(SeaBubbleMenu *) menu;

@end

/**气泡菜单 通过init方法初始化就可以了
 */
@interface SeaBubbleMenu : UIView

/**气泡背景颜色，default is 'whiteColor'
 */
@property(nonatomic, strong) UIColor *fillColor;

/**气泡边框颜色，default is 'clearColor'
 */
@property(nonatomic, strong) UIColor *strokeColor;

/**气泡边框线条宽度 default is '0'，没有线条
 */
@property(nonatomic, assign) CGFloat strokenLineWidth;

/**字体颜色 default is 'blackColor'
 */
@property(nonatomic, strong) UIColor *textColor;

/**选中的字体颜色 default is 'redColor'
 */
@property(nonatomic, strong) UIColor *selectedTextColor;

/**字体
 */
@property(nonatomic, strong) UIFont *font;

/**选中背景颜色 default is '[UIColor colorWithWhite:0.95 alpha:1.0]'
 */
@property(nonatomic, strong) UIColor *selectedBackgroundColor;

/**选中的下标 default is 'NSNotFound'
 */
@property(nonatomic, assign) NSInteger selectedIndex;

/**菜单行高 default is '40.0'
 */
@property(nonatomic, assign) CGFloat rowHeight;

/**菜单宽度 default is '0'，会根据按钮标题宽度，按钮图标和 内容边距获取宽度
 */
@property(nonatomic, assign) CGFloat menuWidth;

/**按钮内容边距 default is '(0, 15.0, 0, 15.0)'
 */
@property(nonatomic, assign) UIEdgeInsets contentInsets;

/**分割线颜色 default is '[UIColor colorWithWhite:0.85 alpha:1.0]'
 */
@property(nonatomic, strong) UIColor *separatorColor;

/**按钮信息 数组元素是 SeaBubbleMenuItemInfo
 */
@property(nonatomic, strong) NSArray *menuItemInfos;

/**箭头方向
 */
@property(nonatomic, readonly) SeaBubbleMenuArrowDirection arrowDirection;

/**箭头尖角坐标
 */
@property(nonatomic, readonly) CGPoint arrowPoint;

/**尖角边长 defaut is '15.0'
 */
@property(nonatomic, assign) CGFloat arrowLength;

/**尖角角度 使用角度 default is '120'，范围 30 ~ 150
 */
@property(nonatomic, assign) CGFloat arrowAngle;

@property(nonatomic, weak) id<SeaBubbleMenuDelegate> delegate;


/**显示菜单
 *@param view 父视图
 *@param rect 触发菜单的按钮在 父视图中的位置大小，可用UIView 或 UIWindow 中的converRectTo 来转换
 *@param animated 是否动画
 *@param overlay 是否使用点击空白处关闭菜单
 */
- (void)showInView:(UIView*) view relatedRect:(CGRect) rect animated:(BOOL) animated overlay:(BOOL) overlay;

/**关闭菜单
 *@param animated 是否动画
 */
- (void)dismissMenuWithAnimated:(BOOL) animated;

/**重新加载按钮信息
 */
- (void)reloadData;

/**重新绘制
 */
- (void)redraw;

@end
