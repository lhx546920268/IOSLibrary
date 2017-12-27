//
//  SeaCollectionViewFlowFillLayout.m
//  ThreadDemo
//
//  Created by 罗海雄 on 16/6/6.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import "SeaCollectionViewFlowFillLayout.h"

///每个section的布局信息
@interface SeaCollectionViewFlowFillLayoutAttributes : NSObject

///头部布局信息
@property(nonatomic,strong) UICollectionViewLayoutAttributes *headerLayoutAttributes;

///底部布局信息
@property(nonatomic,strong) UICollectionViewLayoutAttributes *footerLayoutAttributes;

///item布局信息， 数组元素是 UICollectionViewLayoutAttributes
@property(nonatomic,strong) NSMutableArray *itemInfos;

///行信息，数组元素是 SeaCollectionFlowRowInfo
@property(nonatomic,strong) NSMutableArray *rowInfos;

///section起点
@property(nonatomic,readonly) CGFloat sectionBeginning;

///section终点
@property(nonatomic,readonly) CGFloat sectionEnd;

///是否存在元素
@property(nonatomic,readonly) BOOL existElement;

///item、header、footer 上下间距
@property (nonatomic,assign) CGFloat minimumLineSpacing;

///item左右间距
@property (nonatomic,assign) CGFloat minimumInteritemSpacing;

///section 偏移量
@property (nonatomic,assign) UIEdgeInsets sectionInset;

///关联的布局
@property (nonatomic,weak) SeaCollectionViewFlowFillLayout *layout;

@end

///布局行信息
@interface SeaCollectionFlowRowInfo : NSObject

///关联的section 布局信息
@property(nonatomic,weak) SeaCollectionViewFlowFillLayoutAttributes *layoutAttributes;

///行的最右边的item的 originX加载width
@property(nonatomic,assign) CGFloat rightmost;

///行y轴起点
@property(nonatomic,assign) CGFloat originY;

///最高item的frame
@property(nonatomic,assign) CGRect highestFrame;

///所拥有的item布局信息，数组元素是 UICollectionViewLayoutAttributes
@property(nonatomic,strong) NSMutableArray *itemInfos;

///最外一层的item，数组元素是 NSValue CGRectValue
@property(nonatomic,strong) NSMutableArray *outmostItemInfos;

///根据item大小获取下一个item的位置 如果point.x < 0 ，表示没有空余的位置放item了
- (CGPoint)itemOriginFromItemSize:(CGSize) size;

@end

@implementation SeaCollectionFlowRowInfo

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.outmostItemInfos = [NSMutableArray array];
        self.itemInfos = [NSMutableArray array];
    }

    return self;
}

- (CGPoint)itemOriginFromItemSize:(CGSize) size
{
    CGPoint point;

    ///该行没有其他item
    if(self.itemInfos.count == 0)
    {
        point.y = self.originY;
        point.x = self.layoutAttributes.sectionInset.left;
        self.rightmost = point.x + size.width;

        CGRect rect = CGRectMake(point.x, point.y, size.width, size.height);
        self.highestFrame = rect;

        [self.outmostItemInfos addObject:[NSValue valueWithCGRect:rect]];
        return point;
    }

    if(size.width + self.layoutAttributes.sectionInset.right + self.layoutAttributes.minimumInteritemSpacing + self.rightmost > self.layoutAttributes.layout.collectionView.frame.size.width)
    {
        ///这一行已经没有位置可以放item了
        if(self.outmostItemInfos.count < 2)
        {
            point.x = -1;
        }
        else
        {
            NSInteger index = [self traverseOutmostItemInfosWithItemSize:size];
            if(index >= self.outmostItemInfos.count)
            {
                point.x = -1;
            }
            else
            {
                CGRect frame = [[self.outmostItemInfos objectAtIndex:index] CGRectValue];
                point.x = frame.origin.x;
               
                point.y = frame.size.height + frame.origin.y + self.layoutAttributes.minimumLineSpacing;

                if(size.width < frame.size.width)
                {
                    ///只挡住上面的item的一部分
                    [self.outmostItemInfos replaceObjectAtIndex:index withObject:[NSValue valueWithCGRect:CGRectMake(point.x + size.width + self.layoutAttributes.minimumInteritemSpacing, frame.origin.y, frame.size.width - size.width - self.layoutAttributes.minimumInteritemSpacing, frame.size.height)]];
                    [self.outmostItemInfos insertObject:[NSValue valueWithCGRect:CGRectMake(point.x, point.y, size.width, size.height)] atIndex:index];
                }
                else
                {
                    ///已完全挡住上一个item
                    [self.outmostItemInfos replaceObjectAtIndex:index withObject:[NSValue valueWithCGRect:CGRectMake(point.x, point.y, size.width, size.height)]];
                }

                ///合并相同高度的item
                [self combineTheSameHeightItemForIndex:index];
            }
        }
    }
    else
    {
        ///右边还有位置可以放item
        point.x = self.rightmost + self.layoutAttributes.minimumInteritemSpacing;
        point.y = self.originY;
        self.rightmost = point.x + size.width;

        CGRect rect = CGRectMake(point.x, point.y, size.width, size.height);
        if(self.outmostItemInfos.count == 0)
        {
            [self.outmostItemInfos addObject:[NSValue valueWithCGRect:rect]];
        }
        else
        {
            CGRect lastRect = [[self.outmostItemInfos lastObject] CGRectValue];
            ///相邻的item等高，合并
            if(rect.size.height == lastRect.size.height)
            {
                lastRect.size.width += rect.size.width + self.layoutAttributes.minimumInteritemSpacing;
                [self.outmostItemInfos replaceObjectAtIndex:self.outmostItemInfos.count - 1 withObject:[NSValue valueWithCGRect:lastRect]];
            }
            else
            {
                [self.outmostItemInfos addObject:[NSValue valueWithCGRect:rect]];
            }
        }

        if(self.highestFrame.size.height < rect.size.height)
        {
            self.highestFrame = rect;
        }
    }

    return point;
}

/**便利最外围的item，获取最低的并且适合放size的 item
 *@param size 将要存放的item的大小
 *@return 适合存放item的位置，如果返回NSNotFound，标明没有适合的位置
 */
- (NSInteger)traverseOutmostItemInfosWithItemSize:(CGSize) size
{
    NSValue *value = [self.outmostItemInfos firstObject];
    CGRect frame = [value CGRectValue];

    NSInteger index = 0;
    for(NSInteger i = 1;i < self.outmostItemInfos.count;i ++)
    {
        value = [self.outmostItemInfos objectAtIndex:i];
        CGRect rect = [value CGRectValue];
        ///最低，并且可以放下item
        if(rect.origin.y + rect.size.height < frame.origin.y + frame.size.height && rect.size.width >= size.width)
        {
            frame = rect;
            index = i;
        }
    }

    if(size.width > frame.size.width || size.height + frame.origin.y > self.originY + self.highestFrame.size.height)
    {
        index = NSNotFound;
    }

    return index;
}

/**合并相邻的相同高度的item
 *@param index 要合并的位置
 */
- (void)combineTheSameHeightItemForIndex:(NSInteger) index
{
    CGRect frame = [[self.outmostItemInfos objectAtIndex:index] CGRectValue];
    CGFloat bottom = frame.size.height + frame.origin.y;
    
    if(index > 0)
    {
        ///前一个
        CGRect pframe = [[self.outmostItemInfos objectAtIndex:index - 1] CGRectValue];
        CGFloat pBottom = pframe.origin.y + pframe.size.height;
        if(fabs(bottom - pBottom) < 1.0)
        {
            pframe.origin.x = frame.origin.x;
            pframe.size.width += frame.size.width + self.layoutAttributes.minimumInteritemSpacing;
            
             ///防止出现白边
            if(self.layoutAttributes.minimumLineSpacing == 0)
            {
                if(pBottom > bottom)
                {
                    frame.size.height += pBottom - bottom;
                }
                else if (bottom > pBottom)
                {
                    pframe.size.height += bottom - pBottom;
                }
            }
            
            [self.outmostItemInfos replaceObjectAtIndex:index withObject:[NSValue valueWithCGRect:pframe]];

            frame = pframe;
            [self.outmostItemInfos removeObjectAtIndex:index - 1];
            index --;
        }
    }

    if(index + 1 < self.outmostItemInfos.count)
    {
        ///后一个
        CGRect pframe = [[self.outmostItemInfos objectAtIndex:index + 1] CGRectValue];
        CGFloat pBottom = pframe.origin.y + pframe.size.height;
        if(fabs(bottom - pBottom) < 1.0)
        {
            pframe.origin.x = frame.origin.x;
            pframe.size.width += frame.size.width + self.layoutAttributes.minimumInteritemSpacing;
            
            ///防止出现白边
            if(self.layoutAttributes.minimumLineSpacing == 0)
            {
                if(pBottom > bottom)
                {
                    frame.size.height += pBottom - bottom;
                }
                else if (bottom > pBottom)
                {
                    pframe.size.height += bottom - pBottom;
                }
            }
            
            [self.outmostItemInfos replaceObjectAtIndex:index withObject:[NSValue valueWithCGRect:pframe]];

            [self.outmostItemInfos removeObjectAtIndex:index + 1];
        }
    }
}

@end


@implementation SeaCollectionViewFlowFillLayoutAttributes

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.rowInfos = [NSMutableArray array];
    }

    return self;
}

///section起点
- (CGFloat)sectionBeginning
{
    if(self.headerLayoutAttributes)
    {
        return self.headerLayoutAttributes.frame.origin.y;
    }

    if(self.rowInfos.count > 0)
    {
        SeaCollectionFlowRowInfo *info = [self.rowInfos firstObject];
        return info.originY;
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

    if(self.rowInfos.count > 0)
    {
        SeaCollectionFlowRowInfo *info = [self.rowInfos lastObject];

        return info.originY + info.highestFrame.size.height;
    }
    else
    {
        return self.headerLayoutAttributes.frame.origin.y + self.headerLayoutAttributes.frame.size.height;
    }
}

///是否存在元素
- (BOOL)existElement
{
    return self.headerLayoutAttributes != nil || self.itemInfos.count > 0 || self.footerLayoutAttributes != nil;
}

@end

@interface SeaCollectionViewFlowFillLayout ()

/**
 *  collectonView 代理
 */
@property(nonatomic,readonly) id<SeaCollectionViewFlowFillLayoutDelegate> delegate;

/**
 *  内容大小
 */
@property(nonatomic,assign) CGSize contentSize;

/**
 *  布局属性，数组元素是 SeaCollectionViewFlowFillLayoutAttributes
 */
@property(nonatomic,strong) NSMutableArray *attributes;

@end

@implementation SeaCollectionViewFlowFillLayout

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
    _minimumInteritemSpacing = 5.0;
    _minimumLineSpacing = 5.0;
    _sectionHeaderHeight = 0;
    _sectionFooterHeight = 0;
    _sectionFooterItemSpace = 5.0;
    _sectionHeaderItemSpace = 5.0;
    _sectionInset = UIEdgeInsetsZero;
    self.attributes = [NSMutableArray array];
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
    CGFloat sectionFooterItemSpace = self.sectionFooterItemSpace;
    CGFloat sectionHeaderItemSpace = self.sectionHeaderItemSpace;

    //判断是否已实现了代理
    BOOL sectionHeaderHeightDelegate = [self.delegate respondsToSelector:@selector(collectionViewFlowFillLayout:sectionHeaderHeightAtSection:)];
    BOOL sectionFooterHeightDelegate = [self.delegate respondsToSelector:@selector(collectionViewFlowFillLayout:sectionFooterHeightAtSection:)];
    BOOL sectionInsetDelegate = [self.delegate respondsToSelector:@selector(collectionViewFlowFillLayout:insetForSectionAtIndex:)];
    BOOL minimumInteritemSpacingDelegate = [self.delegate respondsToSelector:@selector(collectionViewFlowFillLayout:minimumInteritemSpacingForSectionAtIndex:)];
    BOOL minimumLineSpacingDelegate = [self.delegate respondsToSelector:@selector(collectionViewFlowFillLayout:minimumLineSpacingForSectionAtIndex:)];
    
    BOOL sectionFooterItemSpaceDelegate = [self.delegate respondsToSelector:@selector(collectionViewFlowFillLayout:sectionFooterItemSpaceAtSection:)];
    BOOL sectionHeaderItemSpaceDelegate = [self.delegate respondsToSelector:@selector(collectionViewFlowFillLayout:sectionHeaderItemSpaceAtSection:)];

#if SeaDebug
    
    BOOL sizeForItemDelegate = [self.delegate respondsToSelector:@selector(collectionViewFlowFillLayout:itemSizeForIndexPath:)];
    NSAssert(sizeForItemDelegate, @"必须实现 collectionViewFlowFillLayout:itemSizeForIndexPath:");
#endif

    CGFloat width = self.collectionView.bounds.size.width;
    //计算内容高度
    CGFloat height = 0;

    for(NSInteger section = 0;section < numberOfSections;section ++)
    {
        SeaCollectionViewFlowFillLayoutAttributes *layoutAttributes = [[SeaCollectionViewFlowFillLayoutAttributes alloc] init];
        layoutAttributes.layout = self;

        [self.attributes addObject:layoutAttributes];

        //获取区域偏移量
        if(sectionInsetDelegate)
        {
            sectionInset = [self.delegate collectionViewFlowFillLayout:self insetForSectionAtIndex:section];
        }

        height += sectionInset.top;

        //获取头部高度
        if(sectionHeaderHeightDelegate)
        {
            //实现了代理
            sectionHeaderHeight = [self.delegate collectionViewFlowFillLayout:self sectionHeaderHeightAtSection:section];
        }

        ///item与header的间距
        if(sectionHeaderItemSpaceDelegate)
        {
            sectionHeaderItemSpace = [self.delegate collectionViewFlowFillLayout:self sectionHeaderItemSpaceAtSection:section];
        }

        //左右间距
        if(minimumInteritemSpacingDelegate)
        {
            minimumInteritemSpacing = [self.delegate collectionViewFlowFillLayout:self minimumInteritemSpacingForSectionAtIndex:section];
        }

        //上下间距
        if(minimumLineSpacingDelegate)
        {
            minimumLineSpacing = [self.delegate collectionViewFlowFillLayout:self minimumLineSpacingForSectionAtIndex:section];
        }

        ///item数量
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];

        ///只有当section头部大于0时才显示
        if(sectionHeaderHeight > 0)
        {
            //header布局
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(0, height, width, sectionHeaderHeight);
            layoutAttributes.headerLayoutAttributes = attributes;
            height += sectionHeaderHeight;

            if(numberOfItems > 0)
                height += sectionHeaderItemSpace;
        }

        ///设置布局属性
        layoutAttributes.itemInfos = [NSMutableArray arrayWithCapacity:numberOfItems];
        layoutAttributes.sectionInset = sectionInset;
        layoutAttributes.minimumLineSpacing = minimumLineSpacing;
        layoutAttributes.minimumInteritemSpacing = minimumInteritemSpacing;

        ///创建行信息
        SeaCollectionFlowRowInfo *rowInfo = [[SeaCollectionFlowRowInfo alloc] init];
        rowInfo.layoutAttributes = layoutAttributes;
        rowInfo.originY = height;;
        [layoutAttributes.rowInfos addObject:rowInfo];

        //计算item 大小位置
        for(NSInteger item = 0;item < numberOfItems;item ++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGSize itemSize = [self.delegate collectionViewFlowFillLayout:self itemSizeForIndexPath:indexPath];
            
            ///取1位小数 防止因为无穷小数导致 出现白边
//            if(minimumInteritemSpacing == 0)
//            {
                itemSize.width = ((int)(itemSize.width * 10.0)) / 10.0;
          //  }
            
            if(minimumLineSpacing == 0)
            {
                itemSize.height = ((int)(itemSize.height * 10.0)) / 10.0;
            }
            
            ///位置已超出上一行
            CGPoint point = [rowInfo itemOriginFromItemSize:itemSize];
            if(point.x < 0)
            {
                height += rowInfo.highestFrame.size.height + minimumLineSpacing;
                rowInfo = [[SeaCollectionFlowRowInfo alloc] init];
                rowInfo.layoutAttributes = layoutAttributes;
                rowInfo.originY = height;;

                point = [rowInfo itemOriginFromItemSize:itemSize];
                [layoutAttributes.rowInfos addObject:rowInfo];
            }
            
//            if(minimumInteritemSpacing == 0)
//            {
                ///右边填满 防止因为无穷小数导致 出现白边
                if(sectionInset.right == 0 && width - point.x - itemSize.width < 1.0)
                {
                    itemSize.width = width - point.x;
                }
           // }

            //item布局
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(point.x, point.y, itemSize.width, itemSize.height);
        
            
            [layoutAttributes.itemInfos addObject:attributes];
            [rowInfo.itemInfos addObject:attributes];
        }

        //添加item的最高列
        height += rowInfo.highestFrame.size.height;

        //获取底部高度
        if(sectionFooterHeightDelegate)
        {
            //实现了代理
            sectionFooterHeight = [self.delegate collectionViewFlowFillLayout:self sectionFooterHeightAtSection:section];
        }

        ///item与底部的间距
        if(sectionFooterItemSpaceDelegate)
        {
            sectionFooterItemSpace = [self.delegate collectionViewFlowFillLayout:self sectionFooterItemSpaceAtSection:section];
        }

        //只有当section底部大于0时才显示
        if(sectionFooterHeight > 0)
        {
            //section的item不为空，底部存在，要添加底部与item的间距
            if(numberOfItems > 0)
            {
                height += sectionFooterItemSpace;
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
}

- (void)prepareLayout
{
    [self caculateContentSize];
}

#pragma mark- property

- (id<SeaCollectionViewFlowFillLayoutDelegate>)delegate
{
    return (id<SeaCollectionViewFlowFillLayoutDelegate>)self.collectionView.delegate;
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

#pragma mark- 布局属性 layout

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    CGFloat top = rect.origin.y;
    CGFloat bottom = top + rect.size.height;

    for(SeaCollectionViewFlowFillLayoutAttributes *attribute in self.attributes)
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

        for(UICollectionViewLayoutAttributes *layoutAttributes in attribute.itemInfos)
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
    SeaCollectionViewFlowFillLayoutAttributes *attributes = [self.attributes objectAtIndex:indexPath.section];

    return [attributes.itemInfos objectAtIndex:indexPath.item];
}


- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    SeaCollectionViewFlowFillLayoutAttributes *attributes = [self.attributes objectAtIndex:indexPath.section];
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


@end
