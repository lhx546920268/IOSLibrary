//
//  UBMenuBar.h

//

#import <UIKit/UIKit.h>



//默认高度
#define _SeaMenuBarHeight_ 40.0

//SeaMenuBar 样式
typedef NS_ENUM(NSInteger, SeaMenuBarStyle)
{
    ///按钮和下划线的宽度和标题宽度对应
    SeaMenuBarStyleItemWithRelateTitle = 0,
    
    ///下划线的宽度和标题宽度对应, 按钮宽度和标题数量对应，菜单按钮占满菜单栏
    SeaMenuBarStyleItemWithRelateTitleInFullScreen = 1,
};

@class SeaMenuBar,SeaMenuBarItem;

/**条形菜单代理
 */
@protocol SeaMenuBarDelegate <NSObject>

///点击某个item
- (void)menuBar:(SeaMenuBar*) menu didSelectItemAtIndex:(NSInteger) index;

@optional

///点击高亮的按钮
- (void)menuBar:(SeaMenuBar*) menu didSelectHighlightedItemAtIndex:(NSInteger) index;

///是否可以点击某个按钮 default is 'YES'
- (BOOL)menuBar:(SeaMenuBar*) menu shouldSelectItemAtIndex:(NSInteger) index;

@end

/**条形菜单 当菜单按钮数量过多时，可滑动查看更多的按钮
 */
@interface SeaMenuBar : UIView

/**菜单按钮字体颜色 default is '[UIColor blackColor]'
 */
@property(nonatomic,strong) UIColor *titleColor;

/**菜单字体
 */
@property(nonatomic,strong) UIFont *titleFont;

/**菜单按钮 选中颜色 default is '_appMainColor_'，设置也会改变 lineView 颜色
 */
@property(nonatomic,strong) UIColor *selectedColor;

/**当前选中的菜单按钮下标 default is '0'
 */
@property(nonatomic,assign) NSInteger selectedIndex;

/**设置 selectedIndex 是否调用代理 default is 'YES'
 */
@property(nonatomic,assign) BOOL callDelegateWhenSetSelectedIndex;

/**内容间距 SeaMenuBarStyleItemWithRelateTitle default is 'UIEdgeInsetsMake(0, 5.0, 0, 5.0)' SeaMenuBarStyleItemWithRelateTitleInFullScreen default is 'UIEdgeInsetZero'
 */
@property(nonatomic,assign) UIEdgeInsets contentInset;

/**底部分割线
 */
@property(nonatomic,readonly) UIView *separatorLine;

///选中的下划线
@property(nonatomic,readonly) UIView *lineView;


/**顶部分割线
 */
@property(nonatomic,readonly) UIView *topSeparatorLine;

/**按钮间隔 SeaMenuBarStyleItemWithRelateTitle default is '5.0' SeaMenuBarStyleItemWithRelateTitleInFullScreen default is '0'
 */
@property(nonatomic,assign) CGFloat buttonInterval;

/**按钮宽度延伸 defautl is '10.0'
 */
@property(nonatomic,assign) CGFloat buttonWidthExtension;

/**是否显示分隔符 SeaMenuBarStyleItemWithRelateTitle default is 'NO', SeaMenuBarStyleItemWithRelateTitleInFullScreen default is 'NO'
 */
@property(nonatomic,assign) BOOL showSeparator;

/**样式 default is 'SeaMenuBarStyleDefault'
 */
@property(nonatomic,assign) SeaMenuBarStyle style;

/**菜单按钮标题，数组元素是 NSString，设置此值会导致菜单重新加载数据
 */
@property(nonatomic,copy) NSArray *titles;

/**按钮信息 数组元素是 SeaMenuBarItemInfo，设置此值会导致菜单重新加载数据
 */
@property(nonatomic,copy) NSArray *itmeInfos;

@property(nonatomic,weak) id<SeaMenuBarDelegate> delegate;

/**构造方法
 *@param frame 位置大小
 *@param titles 菜单按钮标题，数组元素是 NSString
 *@param style 样式
 *@return 已初始化的 UBMenuBar
 */
- (id)initWithFrame:(CGRect)frame titles:(NSArray*) titles style:(SeaMenuBarStyle) style;

/**构造方法
 *@param frame 位置大小
 *@param itmeInfos 按钮信息 数组元素是 SeaMenuBarItemInfo，设置此值会导致菜单重新加载数据
 *@param style 样式
 *@return 已初始化的 UBMenuBar
 */
- (id)initWithFrame:(CGRect)frame itemInfos:(NSArray*) itmeInfos style:(SeaMenuBarStyle) style;

/**设置选中的菜单按钮
 *@param selectedIndex 菜单按钮下标
 *@param flag 是否动画
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL) flag;

/**设置按钮边缘数字
 *@param badgeValue 边缘数字，大于99会显示99+，小于等于0则隐藏
 *@param index 按钮下标
 */
- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSInteger) index;

/**改变按钮图标
 *@param icon 按钮图标
 *@param index 按钮下标
 */
- (void)setIcon:(UIImage*) icon forIndex:(NSInteger) index;

///初始化
- (void)initialization;

@end
