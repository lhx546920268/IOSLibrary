//
//  SeaEmptyView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaEmptyView;

///空视图代理
@protocol SeaEmptyViewDelegate <NSObject>

@optional

///空视图图标
- (void)emptyViewWillAppear:(SeaEmptyView*) view;

@end

///数据为空的视图
@interface SeaEmptyView : UIView

///图标
@property(nonatomic,readonly) UIImageView *iconImageView;

///文字信息
@property(nonatomic,readonly) UILabel *textLabel;

///自定义视图 如果设置将忽略以上两个，并且会重新设置customView的约束，高度约束和frame.size.height一样
@property(nonatomic,strong) UIView *customView;

@end


///用于scrollView 的空视图
@interface UIScrollView (emptyView)

///空视图
@property(nonatomic,readonly) SeaEmptyView *sea_emptyView;

///是否显示空视图 default is 'NO'， 当为YES时，如果是UITableView 或者 UIScrollView，还需要没有数据时才显示
@property(nonatomic,assign) BOOL sea_shouldShowEmptyView;

///空视图偏移量 default is UIEdgeInsetZero
@property(nonatomic,assign) UIEdgeInsets sea_emptyViewInsets;

///空视图代理
@property(nonatomic,weak) id<SeaEmptyViewDelegate> sea_emptyViewDelegate;

///调整emptyView
- (void)layoutEmtpyView;

///当前是空数据 UIScrollView 一定是空的，其他的不一定
- (BOOL)isEmptyData;

@end

///用于tableView 的空视图
@interface UITableView (tableViewEmptyView)

///存在 tableHeaderView 时，是否显示空视图 default is 'YES'
@property(nonatomic,assign) BOOL sea_shouldShowEmptyViewWhenExistTableHeaderView;

///存在 tableFooterView 时，是否显示空视图 default is 'YES'
@property(nonatomic,assign) BOOL sea_shouldShowEmptyViewWhenExistTableFooterView;

///存在 sectionHeader 时，是否显示空视图 default is 'NO'
@property(nonatomic,assign) BOOL sea_shouldShowEmptyViewWhenExistSectionHeaderView;

///存在 sectionFooter 时，是否显示空视图 default is 'NO'
@property(nonatomic,assign) BOOL sea_shouldShowEmptyViewWhenExistSectionFooterView;

@end

///用于collectionView 的空视图
@interface UICollectionView (collectionViewEmptyView)

///存在 sectionHeader 时，是否显示空视图 default is 'NO'
@property(nonatomic,assign) BOOL sea_shouldShowEmptyViewWhenExistSectionHeaderView;

///存在 sectionFooter 时，是否显示空视图 default is 'NO'
@property(nonatomic,assign) BOOL sea_shouldShowEmptyViewWhenExistSectionFooterView;

@end

