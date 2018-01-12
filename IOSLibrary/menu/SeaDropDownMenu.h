//
//  SeaDropDownMenu.h
//  Sea
//
//  Created by 罗海雄 on 15/9/16.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import <UIKit/UIKit.h>

//下拉菜单高度
static const CGFloat SeaDropDownMenuHeight = 40.0;

///下拉菜单按钮图标位置
typedef NS_ENUM(NSInteger, SeaDropDownMenuIconPosition){
    
    ///右边
    SeaDropDownMenuIconPositionRight = 0,
    
    ///左边
    SeaDropDownMenuIconPositionLeft = 1,
};

/**
 下拉菜单按钮信息
 *@warning 下拉列表的的数量以titleLists为准
 */
@interface SeaDropDownMenuItem : NSObject

/**
 一级菜单下标
 */
@property(nonatomic,assign) NSInteger itemIndex;

/**
 按钮标题，如果为空，将使用 [titleLists firstObject]
 */
@property(nonatomic,copy) NSString *title;

/**
 下拉的列表标题信息，数组元素是NSString，如果不为nil则显示指示器 三角图标
 */
@property(nonatomic,strong) NSArray *titleLists;

/**
 下拉的列表图标信息，数组元素是 UIImage
 */
@property(nonatomic,strong) NSArray *iconLists;

/**
 选中的列表标题
 */
@property(nonatomic,assign) NSInteger selectedIndex;

/**
 高亮背景颜色
 */
@property(nonatomic,strong) UIColor *highlightedBackgroundColor;

///一下图片为空时，使用默认图标

/**
 正常的图片
 */
@property(nonatomic,strong) UIImage *normalImage;

/**
 高亮的图片1
 */
@property(nonatomic,strong) UIImage *highlightedImage1;

/**
 高亮的图片2 如果不为nil，点击的时候与 highlightedImage1 来回切换
 */
@property(nonatomic,strong) UIImage *highlightedImage2;

/**
 图标位置 default is 'SeaButtonImagePositionRight'
 */
@property(nonatomic, assign) SeaDropDownMenuIconPosition iconPosition;

/**
 图标和标题的间隔 default is '5.0'
 */
@property(nonatomic,assign) CGFloat iconPadding;

/**
 获取显示的图标
 
 @param tick 是否选中
 */
- (UIImage*)displayIconWithTick:(BOOL) tick;

@end


/**
 下拉菜单按钮
 */
@interface SeaDropDownMenuCell : UICollectionViewCell

/**
 标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**
 图标
 */
@property(nonatomic,readonly) UIImageView *imageView;

/**
 分割线
 */
@property(nonatomic,readonly) UIView *separator;

/**
 图标位置
 */
@property(nonatomic,assign) SeaDropDownMenuIconPosition iconPosition;

/**
 图标和标题的间隔 default is '5.0'
 */
@property(nonatomic,assign) CGFloat iconPadding;

/**
 内容视图
 */
@property(nonatomic,readonly) UIView *ctView;

@end

@class SeaDropDownMenu;

/**下拉菜单代理
 */
@protocol SeaDropDownMenuDelegate <NSObject>

@optional

/**是否可以选中某个一级菜单
 */
- (BOOL)dropDownMenu:(SeaDropDownMenu*) menu shouldSelectItem:(SeaDropDownMenuItem*) item;

/**选中某个一级菜单
 */
- (void)dropDownMenu:(SeaDropDownMenu*) menu didSelectItem:(SeaDropDownMenuItem*) item;

/**选中某个二级菜单
 */
- (void)dropDownMenu:(SeaDropDownMenu *)menu didSelectItemWithSecondMenu:(SeaDropDownMenuItem *)item;

/**取消选中第一级菜单
 */
- (void)dropDownMenu:(SeaDropDownMenu *)menu didDeselectItem:(SeaDropDownMenuItem *)item;

/**选中一级菜单的时候是否需要显示下拉列表 default is 'NO'，只有当选中的一级菜单是高亮状态的时候才显示下拉
 */
- (BOOL)dropDownMenu:(SeaDropDownMenu*) menu shouldShowListInItem:(SeaDropDownMenuItem*) item;

/**是否保持选中
 */
- (BOOL)dropDownMenu:(SeaDropDownMenu *)menu shouldKeepHighlightWhenDismissListInItem:(SeaDropDownMenuItem *)item;

/**获取列表y轴的位置
 */
- (CGFloat)YAsixAtListInDropDwonMenu:(SeaDropDownMenu*) menu;

@end

/**
 下拉菜单，如果下拉列表的数量为0，将不显示三角箭头
 */
@interface SeaDropDownMenu : UIView

/**
 按钮信息
 */
@property(nonatomic,readonly) NSArray<SeaDropDownMenuItem*> *items;

/**
 下拉列表
 */
@property(nonatomic,readonly) UITableView *tableView;

/**
 按钮字体
 */
@property(nonatomic,strong) UIFont *buttonTitleFont;

/**
 按钮字体颜色
 */
@property(nonatomic,strong) UIColor *buttonNormalTitleColor;

/**
 按钮字体高亮颜色
 */
@property(nonatomic,strong) UIColor *buttonHighlightTitleColor;

/**
 下拉列表字体
 */
@property(nonatomic,strong) UIFont *listTitleFont;

/**
 下拉列表字体颜色
 */
@property(nonatomic,strong) UIColor *listNormalTitleColor;

/**
 下拉列表字体高亮颜色
 */
@property(nonatomic,strong) UIColor *listHighLightColor;

/**
 下拉列表选中标识 default is 'nil'
 */
@property(nonatomic,strong) UIImage *listIndicatorImage;

/**
 选中的按钮 default is 'NSNotFound'
 */
@property(nonatomic,assign) NSUInteger selectedIndex;

/**
 当下拉列表消失时是否需要保持选中状态 default is 'YES'
 */
@property(nonatomic,assign) BOOL keepHighlightWhenDismissList;

/**
 阴影颜色
 */
@property(nonatomic,strong) UIColor *shadowColor;

/**
 高亮下划线 当 shouldShowUnderline = NO时为nil
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
 下拉列表的最大高度，default is 列表父视图的高度
 */
@property(nonatomic,assign) CGFloat listMaxHeight;

/**
 是否需要高亮 default is 'YES'
 */
@property(nonatomic,assign) BOOL shouldHighlighted;

/**
 是否需要显示高亮下划线 default is 'NO'
 */
@property(nonatomic,assign) BOOL shouldShowIndicator;

/**
 列表是否正在显示
 */
@property(nonatomic, readonly) BOOL listShowing;

/**
 代理
 */
@property(nonatomic,weak) id<SeaDropDownMenuDelegate> delegate;

/**
 下拉列表的父视图，如果不设置，将视图菜单的俯视图
 @warning 如果是把菜单放在导航栏上，最好设置该值，可设置当前viewController.view 作为下拉列表的俯视图
 */
@property(nonatomic,weak) UIView *listSuperview;

/**
 [self initWithFrame:CGRectZero items:items]
 */
- (instancetype)initWithItems:(NSArray<SeaDropDownMenuItem*> *) items;

/**
 构造方法
 @param items 按钮信息
 @return 一个实例
 */
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<SeaDropDownMenuItem*> *) items;

/**
 关闭下拉列表
 */
- (void)closeList;

/**
 通过下标获取按钮
 */
- (SeaDropDownMenuCell*)cellForIndex:(NSUInteger) index;

/**
 设置标题
 */
- (void)setTitle:(NSString*) title forIndex:(NSUInteger) index;

/**
 刷新item
 */
- (void)reloadItemAtIndex:(NSUInteger) index;

/**
 取消选中
 */
- (void)deselectItem;

@end
