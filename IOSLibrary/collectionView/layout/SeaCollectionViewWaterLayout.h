//
//  SeaCollectionViewWaterLayout.h
//  Sea
//
//  Created by 罗海雄 on 16/1/19.
//  Copyright (c) 2016年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaCollectionViewWaterLayout;

/**
 *  瀑布流布局代理，delegate使用 collectionView.delegate
 */
@protocol SeaCollectionViewDelegateWaterLayout <UICollectionViewDelegate>

/**
 *  对应的item高度，宽度会根据列数计算
 */
- (CGFloat)collectionView:(UICollectionView*) collectionView layout:(SeaCollectionViewWaterLayout*) layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 *  对应的区域偏移量
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(SeaCollectionViewWaterLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

/**
 *  对应的item上下间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SeaCollectionViewWaterLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;

/**
 *  对应的item左右间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SeaCollectionViewWaterLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

/**
 *  对应的header 高度，宽度和collectionView的宽度一致
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SeaCollectionViewWaterLayout*)collectionViewLayout heightForHeaderInSection:(NSInteger)section;

/**
 *  对应的footer 高度，宽度和collectionView的宽度一致
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SeaCollectionViewWaterLayout*)collectionViewLayout heightForFooterInSection:(NSInteger)
section;

/**
 *  对应的section的列数
 */
- (NSInteger)collectionView:(UICollectionView*)collectionView layout:(SeaCollectionViewWaterLayout*)collectionViewLayout numberOfColumnInSection:(NSInteger) section;

/**
 *  item对应的列宽度，如果不实现此代理，则根据列数和item间距计算宽度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SeaCollectionViewWaterLayout *)collectionViewLayout widthForItemInColumn:(NSInteger) column inSection:(NSInteger) section;

@end

/**
 *  瀑布流布局
 */
@interface SeaCollectionViewWaterLayout : UICollectionViewLayout

/**
 *  item、header、footer 上下间距，default is '5.0'，如果实现相应的代理，则忽略此值
 */
@property (nonatomic,assign) CGFloat minimumLineSpacing;
/**
 *  item左右间距，default is '5.0'，如果实现相应的代理，则忽略此值
 */
@property (nonatomic,assign) CGFloat minimumInteritemSpacing;

/**
 *  区域头部视图，default is '0'，如果实现相应的代理，则忽略此值
 */
@property (nonatomic,assign) CGFloat sectionHeaderHeight;

/**
 *  区域底部视图，default is '0'，如果实现相应的代理，则忽略此值
 */
@property (nonatomic,assign) CGFloat sectionFooterHeight;

/**
 *  section 偏移量，default is 'UIEdgeInsetZero'，如果实现相应的代理，则忽略此值
 */
@property (nonatomic,assign) UIEdgeInsets sectionInset;

/**
 *  列数，default is '0'，如果实现相应的代理，则忽略此值
 */
@property (nonatomic,assign) NSInteger numberOfColumn;

@end
