//
//  UICollectionView+SeaCellSize.m
//  Sea
//
//  Created by 罗海雄 on 17/8/23.
//  Copyright © 2017年 lhx. All rights reserved.
//

#import "UICollectionView+SeaCellSize.h"
#import <objc/runtime.h>
#import "UIView+Utilities.h"

@implementation UICollectionView (SeaCellSize)

+ (void)load {
    SEL selectors[] = {
        
        @selector(reloadData),
        @selector(reloadSections:),
        @selector(deleteSections:),
        @selector(moveSection:toSection:),
        @selector(reloadItemsAtIndexPaths:),
        @selector(deleteItemsAtIndexPaths:),
        @selector(moveItemAtIndexPath:toIndexPath:),
        
        @selector(registerNib:forCellWithReuseIdentifier:),
        @selector(registerClass:forCellWithReuseIdentifier:),
        @selector(registerNib:forSupplementaryViewOfKind:withReuseIdentifier:),
        @selector(registerClass:forSupplementaryViewOfKind:withReuseIdentifier:),
    };
    
    

    for(NSInteger i = 0;i < sizeof(selectors) / sizeof(SEL);i ++)
    {
        
        SEL selector1 = selectors[i];
        SEL selector2 = NSSelectorFromString([NSString stringWithFormat:@"sea_cellSize_%@", NSStringFromSelector(selector1)]);
        
        Method method1 = class_getInstanceMethod(self, selector1);
        Method method2 = class_getInstanceMethod(self, selector2);
        
        method_exchangeImplementations(method1, method2);
    }
}

#pragma mark - register cells

- (void)sea_cellSize_registerClass:(Class) clazz forCellWithReuseIdentifier:(NSString *) identifier
{
    [self sea_cellSize_registerClass:clazz forCellWithReuseIdentifier:identifier];
    
    [[self sea_cells] setObject:[[clazz alloc] initWithFrame:CGRectZero] forKey:identifier];
}

- (void)sea_cellSize_registerNib:(UINib *) nib forCellWithReuseIdentifier:(NSString *) identifier
{
    [self sea_cellSize_registerNib:nib forCellWithReuseIdentifier:identifier];
    [[self sea_cells] setObject:[[nib instantiateWithOwner:nil options:nil] firstObject] forKey:identifier];
}

- (void)sea_cellSize_registerClass:(Class) clazz forSupplementaryViewOfKind:(NSString *) kind withReuseIdentifier:(NSString *)identifier
{
    [self sea_cellSize_registerClass:clazz forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
    [[self sea_cells] setObject:[[clazz alloc] initWithFrame:CGRectZero] forKey:identifier];
}

- (void)sea_cellSize_registerNib:(UINib *) nib forSupplementaryViewOfKind:(NSString *) kind withReuseIdentifier:(NSString *)identifier
{
    [self sea_cellSize_registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
    [[self sea_cells] setObject:[[nib instantiateWithOwner:nib options:nil] firstObject] forKey:identifier];
}

#pragma mark - data change

- (void)sea_cellSize_reloadSections:(NSIndexSet *) sections
{
    NSMutableDictionary *caches = [self sea_cellSizeCaches];
    if(caches.count > 0)
    {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            
            [caches removeObjectForKey:@(section)];
        }];
    }
    [self sea_cellSize_reloadSections:sections];
}

- (void)sea_cellSize_deleteSections:(NSIndexSet *) sections
{
    NSMutableDictionary *caches = [self sea_cellSizeCaches];
    if(caches.count > 0)
    {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            
            [caches removeObjectForKey:@(section)];
        }];
    }
    [self sea_cellSize_deleteSections:sections];
}

- (void)sea_cellSize_moveSection:(NSInteger) section toSection:(NSInteger) newSection
{
    NSMutableDictionary *caches = [self sea_cellSizeCaches];
    if(caches.count > 0)
    {
        NSMutableDictionary *dic = [caches objectForKey:@(section)];
        NSMutableDictionary *newDic = [caches objectForKey:@(newSection)];
        
        if(dic != nil && newDic != nil)
        {
            [caches setObject:dic forKey:@(newSection)];
            [caches setObject:newDic forKey:@(section)];
        }
        else if(dic != nil)
        {
            [caches setObject:dic forKey:@(newSection)];
        }
        else if (newDic != nil)
        {
            [caches setObject:newDic forKey:@(section)];
        }
    }
    
    [self sea_cellSize_moveSection:section toSection:newSection];
}

- (void)sea_cellSize_moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *) newIndexPath
{
    NSMutableDictionary *caches = [self sea_cellSizeCaches];
    if(caches.count > 0)
    {
        NSValue *value = [self sea_cachedSizeForIndexPath:indexPath];
        NSValue *toValue = [self sea_cachedSizeForIndexPath:newIndexPath];
        
        if(value != nil && toValue != nil)
        {
            [self sea_setCellSize:value forIndexPath:indexPath];
            [self sea_setCellSize:toValue forIndexPath:newIndexPath];
        }
        else if(value != nil)
        {
            [self sea_setCellSize:value forIndexPath:indexPath];
        }
        else if (toValue != nil)
        {
            [self sea_setCellSize:toValue forIndexPath:newIndexPath];
        }
    }

    [self sea_cellSize_moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (void)sea_cellSize_deleteItemsAtIndexPaths:(NSArray *)indexPaths
{
    NSMutableDictionary *caches = [self sea_cellSizeCaches];
    if(caches.count > 0)
    {
        for(NSIndexPath *indexPath in indexPaths)
        {
            [self sea_setCellSize:nil forIndexPath:indexPath];
        }
    }
    
    [self sea_cellSize_deleteItemsAtIndexPaths:indexPaths];
}

- (void)sea_cellSize_reloadItemsAtIndexPaths:(NSArray *)indexPaths
{
    NSMutableDictionary *caches = [self sea_cellSizeCaches];
    if(caches.count > 0)
    {
        for(NSIndexPath *indexPath in indexPaths)
        {
            [self sea_setCellSize:nil forIndexPath:indexPath];
        }
    }
    
    [self sea_cellSize_reloadItemsAtIndexPaths:indexPaths];
}



- (void)sea_cellSize_reloadData
{
    [[self sea_cellSizeCaches] removeAllObjects];
    [self sea_cellSize_reloadData];
}

#pragma mark- 计算

- (CGSize)sea_cellSizeForIdentifier:(NSString*) identifier indexPath:(NSIndexPath*) indexPath configuration:(SeaCellConfiguration) configuration
{
   return [self sea_cellSizeForIdentifier:identifier indexPath:indexPath constraintSize:CGSizeZero configuration:configuration];
}

- (CGSize)sea_cellSizeForIdentifier:(NSString*) identifier indexPath:(NSIndexPath*) indexPath constraintSize:(CGSize) constraintSize configuration:(SeaCellConfiguration) configuration
{
    return [self sea_cellSizeForIdentifier:identifier indexPath:indexPath constraintSize:constraintSize type:SeaAutoLayoutCalculateTypeSize configuration:configuration];
}

- (CGSize)sea_cellSizeForIdentifier:(NSString*) identifier indexPath:(NSIndexPath*) indexPath width:(CGFloat) width configuration:(SeaCellConfiguration) configuration
{
    return [self sea_cellSizeForIdentifier:identifier indexPath:indexPath constraintSize:CGSizeMake(width, 0) type:SeaAutoLayoutCalculateTypeHeight configuration:configuration];
}

- (CGSize)sea_cellSizeForIdentifier:(NSString*) identifier indexPath:(NSIndexPath*) indexPath height:(CGFloat) height configuration:(SeaCellConfiguration) configuration
{
    return [self sea_cellSizeForIdentifier:identifier indexPath:indexPath constraintSize:CGSizeMake(0, height) type:SeaAutoLayoutCalculateTypeWidth configuration:configuration];
}

- (CGSize)sea_cellSizeForIdentifier:(NSString*) identifier indexPath:(NSIndexPath*) indexPath constraintSize:(CGSize) constraintSize type:(SeaAutoLayoutCalculateType) type configuration:(SeaCellConfiguration) configuration
{
    NSValue *value = [self sea_cachedSizeForIndexPath:indexPath];
    if (value != nil && !CGSizeEqualToSize(CGSizeZero, [value CGSizeValue]))
    {
        return [value CGSizeValue];
    }
    
    //计算大小
    UICollectionReusableView *cell = [[self sea_cells] objectForKey:identifier];
    configuration(cell);
    
    UIView *contentView = cell;
    if([cell isKindOfClass:[UICollectionViewCell class]])
    {
        contentView = [(UICollectionViewCell*)cell contentView];
    }
    CGSize size = [contentView sea_sizeThatFits:constraintSize type:type];
    
    [self sea_setCellSize:[NSValue valueWithCGSize:size] forIndexPath:indexPath];
    
    return size;
}


#pragma mark - cell大小缓存

///缓存cell大小的数组
- (NSMutableDictionary<NSNumber*, NSMutableDictionary<NSNumber*, NSValue*>* >*)sea_cellSizeCaches
{
    NSMutableDictionary *caches = objc_getAssociatedObject(self, _cmd);
    if(caches == nil)
    {
        caches = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, caches, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return caches;
}

///判断是否已有缓存
- (NSValue*)sea_cachedSizeForIndexPath:(NSIndexPath*) indexPath
{
    NSMutableDictionary *dic = [[self sea_cellSizeCaches] objectForKey:@(indexPath.section)];
    if(dic == nil)
        return nil;
    return [dic objectForKey:@(indexPath.item)];
}

///设置缓存
- (void)sea_setCellSize:(NSValue*) size forIndexPath:(NSIndexPath*) indexPath
{
    NSMutableDictionary *caches = [self sea_cellSizeCaches];
    NSMutableDictionary *dic = [caches objectForKey:@(indexPath.section)];
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionary];
        [caches setObject:dic forKey:@(indexPath.section)];
    }
    
    if(size != nil)
    {
        [dic setObject:size forKey:@(indexPath.item)];
    }
    else
    {
        [dic removeObjectForKey:@(indexPath.item)];
    }
}

#pragma mark- 注册的 cells

///注册的cells header footer 用来计算
- (NSMutableDictionary *)sea_cells
{
    NSMutableDictionary<NSString*, UICollectionReusableView*> *cells = objc_getAssociatedObject(self, _cmd);
    if (cells == nil)
    {
        cells = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, cells, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cells;
}

- (__kindof UICollectionReusableView*)cellForIdentifier:(NSString *)identifier
{
    return [[self sea_cells] objectForKey:identifier];
}


///头部
- (NSIndexPath*)sea_headerIndexPathForSection:(NSInteger) section
{
    return [NSIndexPath indexPathForItem:-1 inSection:section];
}

///底部
- (NSIndexPath*)sea_footerIndexPathForSection:(NSInteger) section
{
    return [NSIndexPath indexPathForItem:-2 inSection:section];
}

@end
