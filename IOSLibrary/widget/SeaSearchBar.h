//
//  SeaSearchBar.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/22.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 搜索栏图标位置
 */
typedef NS_ENUM(NSUInteger, SeaSearchBarIconPosition){
    
    ///居中
    SeaSearchBarIconPositionCenter = 0,
    
    ///左边
    SeaSearchBarIconPositionLeft = 1,
};

@class SeaSearchBar;

/**
 搜索栏
 */
@protocol SeaSearchBarDelegate<NSObject>

@optional

/**
 是否可以成为第一响应者
 */
- (BOOL)searchBarShouldBeginEditing:(SeaSearchBar*)searchBar;

/**
 搜索栏成为第一响应者
 */
- (void)searchBarDidBeginEditing:(SeaSearchBar*)searchBar;

/**
 搜索栏取消第一响应者
 */
- (void)searchBarDidEndEditing:(SeaSearchBar*)searchBar;

/**
 输入内容改变
 */
- (void)searchBar:(SeaSearchBar*)searchBar textDidChange:(NSString*)searchText;

/**
 输入内容是否可以改变
 */
- (BOOL)searchBar:(SeaSearchBar*)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text;

/**
 点击键盘上的搜索按钮
 */
- (void)searchBarSearchButtonClicked:(SeaSearchBar*)searchBar;

/**
 搜索取消
 */
- (void)searchBarSearchDidCancel:(SeaSearchBar*) searchBar;

@end

/**
 搜索栏
 */
@interface SeaSearchBar : UIView

/**
 字体 default is '15'
 */
@property(nonatomic, strong) UIFont *font;

/**
 字体颜色 default is 'black'
 */
@property(nonatomic, strong) UIColor *textColor;

/**
 placeholder 类似 UITextField
 */
@property(nonatomic, copy) NSString *placeholder;

/**
 搜索内容
 */
@property(nonatomic, copy) NSString *text;

/**
 placeholder 的颜色
 */
@property(nonatomic, strong) UIColor *placeholderTextColor;

/**
 图标 类似 UISearchBar的搜索图标
 */
@property(nonatomic, strong) UIImage *icon;

/**
 图标和placeholder没输入时的位置
 */
@property(nonatomic, assign) SeaSearchBarIconPosition iconPosition;

/**
 内容边距
 */
@property(nonatomic, assign) UIEdgeInsets contentInsets;

/**
 白色背景内容视图
 */
@property(nonatomic, readonly) UIView *contentView;

/**
 UITextField inputAccessoryView
 */
@property(nonatomic, strong) UIView *textFieldAccessoryView;

/**
 文本删除按钮 default is 'UITextFieldViewModeWhileEditing'
 */
@property(nonatomic, assign) UITextFieldViewMode clearButtonMode;

/**
 是否显示取消按钮 default is 'NO'
 */
@property(nonatomic, assign) BOOL showsCancelButton;

/**
 设置 像 UIBarPositionTopAttached default is 'NO'，父视图clipsToBounds = NO，否则将不生效，如在UITableView.tableViewHeader
 顶部约束必须 为 topLayoutGuide.bottom ios11以下，safeAreaLayoutGuide ios11
 或者 当父视图为UIScrollView 时，可设置 automaticallyAdjustsScrollViewInsets = YES ios11以下， UIScrollViewContentInsetAdjustmentAutomatic ios11，
 clipsToBounds = YES 时无效
 */
@property(nonatomic, assign) BOOL showsAttachedContent;

/**
 代理
 */
@property(nonatomic, weak) id<SeaSearchBarDelegate> delegate;

/**
 成为第一响应者
 */
- (void)becomeFirstResponder;

/**
 取消第一响应者
 */
- (BOOL)resignFirstResponder;

/**
 取消搜索
 */
- (void)cancel;

/**
 动画显示取消按钮
 */
- (void)setShowsCancelButton:(BOOL) show animated:(BOOL) animated;

/**
 动画设置 UIBarPositionTopAttached
 */
- (void)setShowsAttachedContent:(BOOL) show animated:(BOOL) animated;



@end
