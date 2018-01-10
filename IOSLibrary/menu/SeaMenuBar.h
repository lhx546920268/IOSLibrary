//
//  UBMenuBar.h

//

#import <UIKit/UIKit.h>
#import "UIButton+Utils.h"

/**
 菜单按钮信息
 */
@interface SeaMenuItemInfo : NSObject

/**
 标题
 */
@property(nonatomic,copy) NSString *title;

/**
 按钮图标
 */
@property(nonatomic,strong) UIImage *icon;

/**
 图标和标题的间隔
 */
@property(nonatomic,assign) CGFloat iconPadding;

/**
 图标位置 default is 'SeaButtonImagePositionLeft'
 */
@property(nonatomic,assign) SeaButtonImagePosition iconPosition;

/**
 按钮背景图片
 */
@property(nonatomic,strong) UIImage *backgroundImage;

/**
 按钮边缘数据
 */
@property(nonatomic,copy) NSString *badgeNumber;

/**
 按钮宽度
 */
@property(nonatomic,assign) CGFloat itemWidth;

/**
 构造方法
 *@param title 标题
 *@return 已初始化的 SeaMenuItemInfo
 */
+ (id)infoWithTitle:(NSString*) title;

@end

///默认高度
static CGFloat SeaMenuBarHeight = 40.0;

///SeaMenuBar 样式
typedef NS_ENUM(NSInteger, SeaMenuBarStyle)
{
    ///按钮的宽度和标题宽度对应，多余的可滑动
    SeaMenuBarStyleFit = 0,
    
    ///按钮的宽度根据按钮数量和菜单宽度等分，不可滑动
    SeaMenuBarStyleFill = 1,
};

@class SeaMenuBar,SeaMenuBarItem;

/**条形菜单代理
 */
@protocol SeaMenuBarDelegate <NSObject>

///点击某个item
- (void)menuBar:(SeaMenuBar*) menu didSelectItemAtIndex:(NSUInteger) index;

@optional

///点击高亮的按钮
- (void)menuBar:(SeaMenuBar*) menu didSelectHighlightedItemAtIndex:(NSUInteger) index;

///是否可以点击某个按钮 default is 'YES'
- (BOOL)menuBar:(SeaMenuBar*) menu shouldSelectItemAtIndex:(NSUInteger) index;

@end

/**
 条形菜单 当菜单按钮数量过多时，可滑动查看更多的按钮
 */
@interface SeaMenuBar : UIView

/**
 菜单按钮字体颜色 default is '[UIColor darkGrayColor]'
 */
@property(nonatomic,strong) UIColor *normalTextColor;

/**
 菜单按钮字体
 */
@property(nonatomic,strong) UIFont *normalFont;

/**
 菜单按钮 选中颜色 default is 'SeaAppMainColor'
 */
@property(nonatomic,strong) UIColor *selectedTextColor;

/**
 菜单按钮 选中字体
 */
@property(nonatomic,strong) UIFont *selectedFont;

/**
 当前选中的菜单按钮下标 default is '0'
 */
@property(nonatomic,assign) NSUInteger selectedIndex;

/**
 设置 selectedIndex 是否调用代理 default is 'NO'
 */
@property(nonatomic,assign) BOOL callDelegateWhenSetSelectedIndex;

/**
 内容间距 default is 'UIEdgeInsetZero'
 */
@property(nonatomic,assign) UIEdgeInsets contentInset;

/**
 菜单底部分割线
 */
@property(nonatomic,readonly) UIView *bottomSeparator;

/**
 按钮选中下划线
 */
@property(nonatomic,readonly) UIView *indicator;

/**
 按钮选中下划线高度 default is '2.0'
 */
@property(nonatomic,assign) CGFloat indicatorHeight;

/**
 按钮选中下划线颜色 default is 'SeaAppMainColor'
 */
@property(nonatomic,strong) UIColor *indicatorColor;

/**
 菜单顶部分割线
 */
@property(nonatomic,readonly) UIView *topSeparator;

/**
 按钮间 只有 SeaMenuBarStyleFit 生效 default is '5.0'
 */
@property(nonatomic,assign) CGFloat itemInterval;

/**
 按钮宽度延伸 left + right defautl is '10.0'
 */
@property(nonatomic,assign) CGFloat itemPadding;

/**
 是否显示分隔符 只有 SeaMenuBarStyleFit 生效 default is 'YES'
 */
@property(nonatomic,assign) BOOL showSeparator;

/**
 样式 默认自动检测
 */
@property(nonatomic,readonly) SeaMenuBarStyle style;

/**
 菜单按钮标题 设置此值会导致菜单重新加载数据
 */
@property(nonatomic,copy) NSArray<NSString*> *titles;

/**
 按钮信息 设置此值会导致菜单重新加载数据
 */
@property(nonatomic,copy) NSArray<SeaMenuItemInfo*> *itemInfos;

/**
 代理回调
 */
@property(nonatomic,weak) id<SeaMenuBarDelegate> delegate;

/**
 构造方法
 *@param titles 菜单按钮标题
 *@return 一个实例
 */
- (instancetype)initWithTitles:(NSArray<NSString*> *) titles;

/**
 构造方法
 *@param itemInfos 按钮信息
 *@return 一个实例
 */
- (instancetype)initWithItemInfos:(NSArray<SeaMenuItemInfo*> *) itemInfos;

/**
 构造方法
 *@param frame 位置大小
 *@param titles 菜单按钮标题
 *@return 一个实例
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*> *) titles;

/**
 构造方法
 *@param frame 位置大小
 *@param itemInfos 按钮信息
 *@return 一个实例
 */
- (instancetype)initWithFrame:(CGRect)frame itemInfos:(NSArray<SeaMenuItemInfo*> *) itemInfos;

/**设置选中的菜单按钮
 *@param selectedIndex 菜单按钮下标
 *@param flag 是否动画
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL) flag;

/**设置按钮边缘数字
 *@param badgeValue 边缘数字，大于99会显示99+，小于等于0则隐藏
 *@param index 按钮下标
 */
- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSUInteger) index;

/**改变按钮图标
 *@param icon 按钮图标
 *@param index 按钮下标
 */
- (void)setIcon:(UIImage*) icon forIndex:(NSUInteger) index;

@end
