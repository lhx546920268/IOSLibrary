//
//  UICollectionView+SeaEmptyView.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/12.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///用于collectionView 的空视图
@interface UICollectionView (SeaEmptyView)

///存在 sectionHeader 时，是否显示空视图 default is 'NO'
@property(nonatomic,assign) BOOL sea_shouldShowEmptyViewWhenExistSectionHeaderView;

///存在 sectionFooter 时，是否显示空视图 default is 'NO'
@property(nonatomic,assign) BOOL sea_shouldShowEmptyViewWhenExistSectionFooterView;

@end
