//
//  SeaCollectionViewFlowFillLayout.h
//  ThreadDemo
//
//  Created by 罗海雄 on 16/6/6.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaCollectionViewFlowFillLayout;

///改进系统的流布局，每一行尽量填充满 代理
@protocol SeaCollectionViewFlowFillLayoutDelegate <UICollectionViewDelegate>

///获取每个item的大小
- (CGSize)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout*) layout itemSizeForIndexPath:(NSIndexPath*) indexPath;

@optional

///获取每个sectionHeader的高度，宽度使用section的宽度
- (CGFloat)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout headerHeightAtSection:(NSInteger) section;

///头部是否需要悬浮 default is 'NO'
- (BOOL)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout shouldStickHeaderAtSection:(NSInteger) section;

///获取每个sectionFooter的高度，宽度使用section的宽度
- (CGFloat)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout footerHeightAtSection:(NSInteger) section;

///对应的区域偏移量
- (UIEdgeInsets)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout insetForSectionAtIndex:(NSInteger)section;

///对应的item上下间距
- (CGFloat)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout minimumLineSpacingForSection:(NSInteger)section;

///对应的item左右间距
- (CGFloat)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout minimumInteritemSpacingForSection:(NSInteger)section;

///区域头部视图和item之间的间距
- (CGFloat)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout headerItemSpaceAtSection:(NSInteger) section;

///区域底部视图和item之间的间距
- (CGFloat)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout footerItemSpaceAtSection:(NSInteger)section;

@end

///改进系统的流布局，每一行尽量填充满
@interface SeaCollectionViewFlowFillLayout : UICollectionViewLayout

///item上下间距，default is '5.0'，如果实现相应的代理，则忽略此值
@property (nonatomic,assign) CGFloat minimumLineSpacing;

///item左右间距，default is '5.0'，如果实现相应的代理，则忽略此值
@property (nonatomic,assign) CGFloat minimumInteritemSpacing;

///区域头部视图，default is '0'，如果实现相应的代理，则忽略此值
@property (nonatomic,assign) CGFloat sectionHeaderHeight;

///区域底部视图，default is '0'，如果实现相应的代理，则忽略此值
@property (nonatomic,assign) CGFloat sectionFooterHeight;

///区域头部视图和item之间的间距 default is '5.0'，只有当item时，此值才有效，如果实现相应的代理，则忽略此值
@property (nonatomic,assign) CGFloat sectionHeaderItemSpace;

///区域底部视图和item之间的间距 default is '5.0'，只有当item时，此值才有效，如果实现相应的代理，则忽略此值
@property (nonatomic,assign) CGFloat sectionFooterItemSpace;

///section 偏移量，default is 'UIEdgeInsetZero'，如果实现相应的代理，则忽略此值
@property (nonatomic,assign) UIEdgeInsets sectionInset;

@end
