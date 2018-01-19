//
//  SeaTabBar.h

//

#import <UIKit/UIKit.h>

@class SeaTabBar, SeaTabBarItem;

/**
 选项卡代理
 */
@protocol SeaTabBarDelegate <NSObject>

/**
 选中第几个
 */
- (void)tabBar:(SeaTabBar*) tabBar didSelectItemAtIndex:(NSInteger) index;

@optional

/**
 是否可以下第几个 default is 'YES'
 */
- (BOOL)tabBar:(SeaTabBar*) tabBar shouldSelectItemAtIndex:(NSInteger) index;

@end

/**
 选项卡
 */
@interface SeaTabBar : UIView

/**
 选项卡按钮
 */
@property(nonatomic,readonly,copy) NSArray<SeaTabBarItem*> *items;

/**
 背景视图 default is 'nil' ,如果设置，大小会调节到选项卡的大小
 */
@property(nonatomic,strong) UIView *backgroundView;

/**
 设置选中 default is 'NSNotFound'
 */
@property(nonatomic,assign) NSUInteger selectedIndex;

/**
 选中按钮的背景颜色 default is 'nil'
 */
@property(nonatomic,strong) UIColor *selectedButtonBackgroundColor;

/**
 分割线
 */
@property(nonatomic,readonly) UIView *separator;

/**
 代理
 */
@property(nonatomic,weak) id<SeaTabBarDelegate> delegate;

/**
 通过tabBar按钮构建

 @param items 按钮信息
 @return 一个实例
 */
- (instancetype)initWithItems:(NSArray<SeaTabBarItem*>*) items;

/**
 设置选项卡边缘值
 
 @param badgeValue 边缘值
 @param index 下标
 */
- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSInteger) index;

@end
