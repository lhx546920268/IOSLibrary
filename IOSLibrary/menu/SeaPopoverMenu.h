//
//  SeaPopoverMenu.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/30.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaPopover.h"

/**
 弹窗菜单按钮信息
 */
@interface SeaPopoverMenuItemInfo : NSObject

/**
 标题
 */
@property(nonatomic,copy) NSString *title;

/**
 按钮图标
 */
@property(nonatomic,strong) UIImage *icon;

/**
 通过 标题和 图标构造
 */
+ (id)infoWithTitle:(NSString*) title icon:(UIImage*) icon;

@end

/**
 弹窗按钮cell
 */
@interface SeaPopoverMenuCell : UITableViewCell

/**
 按钮
 */
@property(nonatomic, readonly) UIButton *button;

/**
 分割线
 */
@property(nonatomic, readonly) UIView *divider;

@end

@class SeaPopoverMenu;

/**
 弹窗菜单代理
 */
@protocol SeaPopoverMenuDelegate<SeaPopoverDelegate>

/**
 选择某一个
 */
- (void)popoverMenu:(SeaPopoverMenu*) popoverMenu didSelectAtIndex:(NSUInteger) index;

@end

/**
 弹窗菜单 contentInsets 将设成 0
 */
@interface SeaPopoverMenu : SeaPopover

/**
 字体颜色 default is 'blackColor'
 */
@property(nonatomic, strong) UIColor *textColor;

/**
 字体 default is '13'
 */
@property(nonatomic, strong) UIFont *font;

/**
 选中背景颜色 default is '[UIColor colorWithWhite:0.95 alpha:1.0]'
 */
@property(nonatomic, strong) UIColor *selectedBackgroundColor;

/**
 图标和按钮的间隔 default is '0.0'
 */
@property(nonatomic, assign) CGFloat iconTitleInterval;

/**
 菜单行高 default is '30.0'
 */
@property(nonatomic, assign) CGFloat rowHeight;

/**
 菜单宽度 default is '0'，会根据按钮标题宽度，按钮图标和 内容边距获取宽度
 */
@property(nonatomic, assign) CGFloat menuWidth;

/**
 cell 内容边距 default is '(0, 15.0, 0, 15.0)' ，只有left和right生效
 */
@property(nonatomic, assign) UIEdgeInsets cellContentInsets;

/**
 分割线颜色 default is 'SeaSeparatorColor'
 */
@property(nonatomic, strong) UIColor *separatorColor;

/**
 cell 分割线间距 default is '(0, 0, 0, 0)' ，只有left和right生效
 */
@property(nonatomic, assign) UIEdgeInsets separatorInsets;

/**
 按钮信息
 */
@property(nonatomic, strong) NSArray<SeaPopoverMenuItemInfo*> *menuItemInfos;

/**
 标题
 */
@property(nonatomic, copy) NSArray<NSString*> *titles;

/**
 点击某个按钮回调
 */
@property(nonatomic, copy) void(^selectHandler)(NSInteger index);

/**
 代理
 */
@property(nonatomic, weak) id<SeaPopoverMenuDelegate> delegate;

@end
