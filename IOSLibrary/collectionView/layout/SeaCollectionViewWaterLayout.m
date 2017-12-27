//
//  SeaCollectionViewWaterLayout.m
//  Sea
//
//  Created by 罗海雄 on 16/1/19.
//  Copyright (c) 2016年 罗海雄. All rights reserved.
//

#import "SeaCollectionViewWaterLayout.h"

///列信息
@interface SeaCollectionColumnInfo : NSObject

///列宽度
@property(nonatomic,assign) CGFloat width;

///列高度
@property(nonatomic,assign) CGFloat height;

///x轴位置
@property(nonatomic,assign) CGFloat xAxis;

@end

@implementation SeaCollectionColumnInfo


@end

///布局信息
@interface SeaCollectionViewLayoutAttributes : NSObject

///头部布局信息
@property(nonatomic,strong) UICollectionViewLayoutAttributes *headerLayoutAttributes;

///底部布局信息
@property(nonatomic,strong) UICollectionViewLayoutAttributes *footerLayoutAttributes;

///item布局信息， 数组元素是 UICollectionViewLayoutAttributes
@property(nonatomic,strong) NSMutableArray *itemAttributes;

///列信息，数组元素是 SeaCollectionColumnInfo
@property(nonatomic,strong) NSMutableArray *columnInfos;

///section起点
@property(nonatomic,readonly) CGFloat sectionBeginning;

///section终点
@property(nonatomic,readonly) CGFloat sectionEnd;

///是否存在元素
@property(nonatomic,readonly) BOOL existElement;

///获取最低的列
@property(nonatomic,readonly) SeaCollectionColumnInfo *shortestColumnInfo;

///获取最高的列
@property(nonatomic,readonly) SeaCollectionColumnInfo *highestColumnInfo;

@end

@implementation SeaCollectionViewLayoutAttributes

///section起点
- (CGFloat)sectionBeginning
{
    if(self.headerLayoutAttributes)
    {
        return self.headerLayoutAttributes.frame.origin.y;
    }
    
    if(self.itemAttributes.count > 0)
    {
        UICollectionViewLayoutAttributes *attributes = [self.itemAttributes firstObject];
        return attributes.frame.origin.y;
    }
    else
    {
        return self.footerLayoutAttributes.frame.origin.y;
    }
}

///section终点
- (CGFloat)sectionEnd
{
    if(self.footerLayoutAttributes)
    {
        return self.footerLayoutAttributes.frame.origin.y + self.footerLayoutAttributes.frame.size.height;
    }
    
    if(self.itemAttributes.count > 0)
    {
        return self.highestColumnInfo.height + self.sectionBeginning;
    }
    else
    {
        return self.headerLayoutAttributes.frame.origin.y + self.headerLayoutAttributes.frame.size.height;
    }
}

///是否存在元素
- (BOOL)existElement
{
    return self.headerLayoutAttributes != nil || self.itemAttributes.count > 0 || self.footerLayoutAttributes != nil;
}

///获取最低的列
- (SeaCollectionColumnInfo*)shortestColumnInfo
{
    SeaCollectionColumnInfo *result = [self.columnInfos firstObject];
    
    for(NSInteger i = 1;i < self.columnInfos.count;i ++)
    {
        SeaCollectionColumnInfo *info = [self.columnInfos objectAtIndex:i];
        if(info.height < result.height)
        {
            result = info;
        }
    }
    
    return result;
}

///获取最高的列
- (SeaCollectionColumnInfo*)highestColumnInfo
{
    SeaCollectionColumnInfo *result = [self.columnInfos firstObject];
    
    for(NSInteger i = 1;i < self.columnInfos.count;i ++)
    {
        SeaCollectionColumnInfo *info = [self.columnInfos objectAtIndex:i];
        if(info.height > result.height)
        {
            result = info;
        }
    }
    
    return result;
}

@end

@interface SeaCollectionViewWaterLayout ()

/**
 *  collectonView 代理
 */
@property(nonatomic,readonly) id<SeaCollectionViewDelegateWaterLayout> delegate;

/**
 *  内容大小
 */
@property(nonatomic,assign) CGSize contentSize;

/**
 *  旧的区域
 */
@property(nonatomic,assign) CGRect oldBounds;

/**
 *  布局属性，数组元素是 SeaCollectionViewLayoutAttributes
 */
@property(nonatomic,strong) NSMutableArray *attributes;

@end

@implementation SeaCollectionViewWaterLayout

/**
 *  初始化
 *
 *  @return 一个实例
 */
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initialization];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialization];
    }
    
    return self;
}

///初始化
- (void)initialization
{
    _numberOfColumn = 0;
    _minimumInteritemSpacing = 5.0;
    _minimumLineSpacing = 5.0;
    _sectionHeaderHeight = 0;
    _sectionFooterHeight = 0;
    _sectionInset = UIEdgeInsetsZero;
    self.attributes = [NSMutableArray array];
}

#pragma mark- property

- (void)setNumberOfColumn:(NSInteger)numberOfColumn
{
    if(_numberOfColumn != numberOfColumn)
    {
        _numberOfColumn = numberOfColumn;
        if(![self.delegate respondsToSelector:@selector(collectionView:layout:numberOfColumnInSection:)])
        {
            [self invalidateLayout];
        }
    }
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    if(_minimumInteritemSpacing != minimumInteritemSpacing)
    {
        _minimumInteritemSpacing = minimumInteritemSpacing;
        if(![self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
        {
            [self invalidateLayout];
        }
    }
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
{
    if(_minimumLineSpacing != minimumLineSpacing)
    {
        _minimumLineSpacing = minimumLineSpacing;
        if(![self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
        {
            [self invalidateLayout];
        }
    }
}

- (void)setSectionHeaderHeight:(CGFloat)sectionHeaderHeight
{
    if(_sectionFooterHeight != sectionHeaderHeight)
    {
        _sectionFooterHeight = sectionHeaderHeight;
        if(![self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)])
        {
            [self invalidateLayout];
        }
    }
}

- (void)setSectionFooterHeight:(CGFloat)sectionFooterHeight
{
    if(_sectionFooterHeight != sectionFooterHeight)
    {
        _sectionFooterHeight = sectionFooterHeight;
        if(![self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)])
        {
            [self invalidateLayout];
        }
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if(UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset))
    {
        _sectionInset = sectionInset;
        if(![self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
        {
            [self invalidateLayout];
        }
    }
}

/**
 *  collectonView 代理
 */
- (id<SeaCollectionViewDelegateWaterLayout>)delegate
{
    return (id<SeaCollectionViewDelegateWaterLayout>)self.collectionView.delegate;
}

- (void)prepareLayout
{
    [self caculateContentSize];
}

#pragma mark- 内容大小

/**
 *  父抽象方法
 *
 *  @return 滚动范围
 */
- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

/**
 *  计算内容大小
 */
- (void)caculateContentSize
{
    [self.attributes removeAllObjects];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    //原始属性，如果不实现代理，则使用这些值
    CGFloat sectionHeaderHeight = self.sectionHeaderHeight;
    CGFloat sectionFooterHeight = self.sectionFooterHeight;
    UIEdgeInsets sectionInset = self.sectionInset;
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    CGFloat minimumLineSpacing = self.minimumLineSpacing;
    NSInteger numberOfColumn = self.numberOfColumn;
    
    //判断是否已实现了代理
    BOOL sectionHeaderHeightDelegate = [self.delegate respondsToSelector:@selector(collectionView:layout:heightForHeaderInSection:)];
    BOOL sectionFooterHeightDelegate = [self.delegate respondsToSelector:@selector(collectionView:layout:heightForFooterInSection:)];
    BOOL sectionInsetDelegate = [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)];
    BOOL minimumInteritemSpacingDelegate = [self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)];
    BOOL minimumLineSpacingDelegate = [self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)];
    BOOL numberOfColumnDelegate = [self.delegate respondsToSelector:@selector(collectionView:layout:numberOfColumnInSection:)];
    BOOL widthForItemDelegate = [self.delegate respondsToSelector:@selector(collectionView:layout:widthForItemInColumn:inSection:)];

    CGFloat width = self.collectionView.bounds.size.width;
    //计算内容高度
    CGFloat height = 0;

    for(NSInteger section = 0;section < numberOfSections;section ++)
    {
        SeaCollectionViewLayoutAttributes *layoutAttributes = [[SeaCollectionViewLayoutAttributes alloc] init];
        [self.attributes addObject:layoutAttributes];
        
        //获取区域偏移量
        if(sectionInsetDelegate)
        {
            sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
        height += sectionInset.top;
        
        //获取头部高度
        if(sectionHeaderHeightDelegate)
        {
            //实现了代理
            sectionHeaderHeight = [self.delegate collectionView:self.collectionView layout:self heightForHeaderInSection:section];
        }
        
        ///只有当section头部大于0时才显示
        if(sectionHeaderHeight > 0)
        {
            //header布局
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(0, height, width, sectionHeaderHeight);
            layoutAttributes.headerLayoutAttributes = attributes;
        }
        
        height += sectionHeaderHeight;
        
        //左右间距
        if(minimumInteritemSpacingDelegate)
        {
            minimumInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
        }
        
        //上下间距
        if(minimumLineSpacingDelegate)
        {
            minimumLineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
        }
        
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        
        //列数
        if(numberOfColumnDelegate)
        {
            numberOfColumn = [self.delegate collectionView:self.collectionView layout:self numberOfColumnInSection:section];
        }
        
        //item宽度
        CGFloat itemWidth = (width - sectionInset.left - sectionInset.right - (numberOfColumn - 1) * minimumInteritemSpacing) / numberOfColumn;
        
        ///添加每列的信息
        layoutAttributes.columnInfos = [NSMutableArray arrayWithCapacity:numberOfColumn];
        CGFloat xAxis = sectionInset.left; ///每列的x起点
        for(NSInteger column = 0;column < numberOfColumn;column ++)
        {
            ///创建每列的信息
            SeaCollectionColumnInfo *info = [[SeaCollectionColumnInfo alloc] init];
            info.height = 0;
            info.width = widthForItemDelegate ? [self.delegate collectionView:self.collectionView layout:self widthForItemInColumn:column inSection:section] : itemWidth;
            info.xAxis = xAxis;
            [layoutAttributes.columnInfos addObject:info];
            xAxis += info.width + minimumInteritemSpacing;
        }
        
        layoutAttributes.itemAttributes = [NSMutableArray arrayWithCapacity:numberOfItems];
        
        //计算item 大小位置
        for(NSInteger item = 0;item < numberOfItems;item ++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGFloat itemHeight = [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];

            //获取最矮的列
            SeaCollectionColumnInfo *columnInfo = layoutAttributes.shortestColumnInfo;
            
            //item布局
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(columnInfo.xAxis, height + columnInfo.height + minimumLineSpacing, columnInfo.width, itemHeight);
            [layoutAttributes.itemAttributes addObject:attributes];
            
            ///改变列高
            columnInfo.height += itemHeight + minimumLineSpacing;
        }
        
        //添加item的最高列
        height += layoutAttributes.highestColumnInfo.height;

        //获取底部高度
        if(sectionFooterHeightDelegate)
        {
            //实现了代理
            sectionFooterHeight = [self.delegate collectionView:self.collectionView layout:self heightForFooterInSection:section];
        }
        
        //只有当section底部大于0时才显示
        if(sectionFooterHeight > 0)
        {
            //section的item不为空，底部存在，要添加底部与item的间距
            if(numberOfItems > 0)
            {
                height += minimumLineSpacing;
            }
            
            //footer布局
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(0, height, width, sectionFooterHeight);
            layoutAttributes.footerLayoutAttributes = attributes;
        }
        
        height += sectionFooterHeight;
        
        height += sectionInset.bottom;
    }

    self.contentSize = CGSizeMake(self.collectionView.bounds.size.width, height);
    self.oldBounds = self.collectionView.bounds;
}

#pragma mark- 布局属性 layout

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    CGFloat top = rect.origin.y;
    CGFloat bottom = top + rect.size.height;
    
    for(SeaCollectionViewLayoutAttributes *attribute in self.attributes)
    {
        ///该区域没有元素
        if(!attribute.existElement)
        {
            continue;
        }
        
        ///section的头部超过rect的底部，该section以后的元素都不存在于该区域
        if(attribute.sectionBeginning > bottom)
        {
            break;
        }
        
        ///section的底部小于rect的头部，改section的元素不存在该区域，继续查询下一个section
        if(attribute.sectionEnd < top)
        {
            continue;
        }
        
        if(attribute.headerLayoutAttributes)
        {
            [attributes addObject:attribute.headerLayoutAttributes];
        }
        
        for(UICollectionViewLayoutAttributes *layoutAttributes in attribute.itemAttributes)
        {
            if(CGRectIntersectsRect(rect, layoutAttributes.frame))
            {
                [attributes addObject:layoutAttributes];
            }
        }
        
        if(attribute.footerLayoutAttributes)
        {
            if(CGRectIntersectsRect(rect, attribute.footerLayoutAttributes.frame))
            {
                [attributes addObject:attribute.footerLayoutAttributes];
            }
            else
            {
                ///已超过范围
                break;
            }
        }
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaCollectionViewLayoutAttributes *attributes = [self.attributes objectAtIndex:indexPath.section];
    
    return [attributes.itemAttributes objectAtIndex:indexPath.item];
}


- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    SeaCollectionViewLayoutAttributes *attributes = [self.attributes objectAtIndex:indexPath.section];
    if([elementKind isEqualToString:UICollectionElementKindSectionFooter])
    {
        return attributes.footerLayoutAttributes;
    }
    else if ([elementKind isEqualToString:UICollectionElementKindSectionHeader])
    {
        return attributes.headerLayoutAttributes;
    }
    
    return nil;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

#pragma mark- 更新 update

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    
}

- (void)finalizeCollectionViewUpdates
{
    
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    return nil;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return nil;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    return nil;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return nil;
}


@end
