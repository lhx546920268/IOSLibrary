//
//  UITableView+SeaRowHeight.m
//  BeautifulLife
//
//  Created by 罗海雄 on 17/9/2.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import "UITableView+SeaRowHeight.h"
#import <objc/runtime.h>
#import "UIView+Utils.h"

///tableView section 缓存大小
@interface SeaTableViewSectionInfo : NSObject

///header 高度
@property(nonatomic, assign) CGFloat headerHeight;

///footer高度
@property(nonatomic, assign) CGFloat footerHeight;

///行高
@property(nonatomic, strong) NSMutableDictionary<NSNumber*, NSNumber*> *rowHeights;

@end

@implementation SeaTableViewSectionInfo

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.rowHeights = [NSMutableDictionary dictionary];
    }
    
    return self;
}

@end

@implementation UITableView (SeaRowHeight)

+ (void)load {
    SEL selectors[] = {
        
        @selector(reloadData),
        @selector(reloadSections:withRowAnimation:),
        @selector(deleteSections:withRowAnimation:),
        @selector(moveSection:toSection:),
        @selector(reloadRowsAtIndexPaths:withRowAnimation:),
        @selector(deleteRowsAtIndexPaths:withRowAnimation:),
        @selector(moveRowAtIndexPath:toIndexPath:),
        
        @selector(registerNib:forCellReuseIdentifier:),
        @selector(registerClass:forCellReuseIdentifier:),
        @selector(registerNib:forHeaderFooterViewReuseIdentifier:),
        @selector(registerClass:forHeaderFooterViewReuseIdentifier:)
    };
    
    
    for(NSInteger i = 0;i < sizeof(selectors) / sizeof(SEL);i ++)
    {
        SEL selector1 = selectors[i];
        SEL selector2 = NSSelectorFromString([NSString stringWithFormat:@"sea_rowHeight_%@", NSStringFromSelector(selector1)]);
        
        Method method1 = class_getInstanceMethod(self, selector1);
        Method method2 = class_getInstanceMethod(self, selector2);
        
        method_exchangeImplementations(method1, method2);
    }
}

#pragma mark - register cells

- (void)sea_rowHeight_registerClass:(Class) clazz forCellReuseIdentifier:(NSString *)identifier
{
    [self sea_rowHeight_registerClass:clazz forCellReuseIdentifier:identifier];
    
    [[self sea_cells] setObject:[[clazz alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] forKey:identifier];
}

- (void)sea_rowHeight_registerNib:(UINib *) nib forCellReuseIdentifier:(NSString *)identifier
{
    [self sea_rowHeight_registerNib:nib forCellReuseIdentifier:identifier];
    [[self sea_cells] setObject:[[nib instantiateWithOwner:nil options:nil] firstObject] forKey:identifier];
}

- (void)sea_rowHeight_registerClass:(Class) clazz forHeaderFooterViewReuseIdentifier:(NSString *)identifier
{
    [self sea_rowHeight_registerClass:clazz forHeaderFooterViewReuseIdentifier:identifier];
    if([clazz isSubclassOfClass:[UITableViewHeaderFooterView class]])
    {
        [[self sea_cells] setObject:[[clazz alloc] initWithReuseIdentifier:identifier] forKey:identifier];
    }
    else
    {
        [[self sea_cells] setObject:[[clazz alloc] initWithFrame:CGRectZero] forKey:identifier];
    }
}

- (void)sea_rowHeight_registerNib:(UINib *) nib forHeaderFooterViewReuseIdentifier:(NSString *)identifier
{
    [self sea_rowHeight_registerNib:nib forHeaderFooterViewReuseIdentifier:identifier];
    [[self sea_cells] setObject:[[nib instantiateWithOwner:nil options:nil] firstObject] forKey:identifier];
}

#pragma mark - data change

- (void)sea_rowHeight_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableDictionary *caches = [self sea_rowHeightCaches];
    if(caches.count > 0)
    {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            
            [caches removeObjectForKey:@(section)];
        }];
    }
    [self sea_rowHeight_reloadSections:sections withRowAnimation:animation];
}

- (void)sea_rowHeight_deleteSections:(NSIndexSet *) sections withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableDictionary *caches = [self sea_rowHeightCaches];
    if(caches.count > 0)
    {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            
            [caches removeObjectForKey:@(section)];
        }];
    }
    [self sea_rowHeight_deleteSections:sections withRowAnimation:animation];
}

- (void)sea_rowHeight_moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    NSMutableDictionary *caches = [self sea_rowHeightCaches];
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
    
    [self sea_rowHeight_moveSection:section toSection:newSection];
}

- (void)sea_rowHeight_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    NSMutableDictionary *caches = [self sea_rowHeightCaches];
    if(caches.count > 0)
    {
        NSNumber *number = [self sea_cachedCellHeightForIndexPath:indexPath];
        NSNumber *toNumber = [self sea_cachedCellHeightForIndexPath:newIndexPath];
        
        if(number != nil && toNumber != nil)
        {
            [self sea_setCellHeight:number forIndexPath:indexPath];
            [self sea_setCellHeight:toNumber forIndexPath:newIndexPath];
        }
        else if(number != nil)
        {
            [self sea_setCellHeight:number forIndexPath:indexPath];
        }
        else if (toNumber != nil)
        {
            [self sea_setCellHeight:toNumber forIndexPath:newIndexPath];
        }
    }
    
    [self sea_rowHeight_moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (void)sea_rowHeight_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableDictionary *caches = [self sea_rowHeightCaches];
    if(caches.count > 0)
    {
        for(NSIndexPath *indexPath in indexPaths)
        {
            [self sea_setCellHeight:nil forIndexPath:indexPath];
        }
    }
    
    [self sea_rowHeight_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)sea_rowHeight_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableDictionary *caches = [self sea_rowHeightCaches];
    if(caches.count > 0)
    {
        for(NSIndexPath *indexPath in indexPaths)
        {
            [self sea_setCellHeight:nil forIndexPath:indexPath];
        }
    }
    
    [self sea_rowHeight_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}


- (void)sea_rowHeight_reloadData
{
    [[self sea_rowHeightCaches] removeAllObjects];
    [self sea_rowHeight_reloadData];
}

#pragma mark- 计算

/**获取cell高度
 *@param identifier cell唯一标识
 *@param indexPath cell下标
 *@return cell 高度
 */
- (CGFloat)sea_rowHeightForIdentifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath configuration:(SeaTableCellConfiguration)configuration
{
    NSNumber *number = [self sea_cachedCellHeightForIndexPath:indexPath];
    if (number != nil && [number floatValue] != 0)
    {
        return [number floatValue];
    }
    
    //计算大小
    UITableViewCell *cell = [self sea_cellForIdentifier:identifier];
    CGFloat height = [self sea_rowHeightForCell:cell indexPath:indexPath configuration:configuration useCache:NO];
    
    return height;
}

/**获取cell高度 主要用于静态cell，不重用的cell
 *@param cell 要计算高度的cell
 *@param indexPath cell下标
 */
- (CGFloat)sea_rowHeightForCell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath
{
    return [self sea_rowHeightForCell:cell indexPath:indexPath configuration:nil];
}

/**获取cell高度 主要用于静态cell，不重用的cell
 *@param cell 要计算高度的cell
 *@param indexPath cell下标
 *@return cell 高度
 */
- (CGFloat)sea_rowHeightForCell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath configuration:(SeaTableCellConfiguration) configuration
{
    return [self sea_rowHeightForCell:cell indexPath:indexPath configuration:configuration useCache:YES];
}


/**获取cell高度 主要用于静态cell，不重用的cell
 *@param cell 要计算高度的cell
 *@param indexPath cell下标
 *@param useCache 是否使用缓存
 *@return cell 高度
 */
- (CGFloat)sea_rowHeightForCell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath configuration:(SeaTableCellConfiguration) configuration useCache:(BOOL) useCache
{
    if(useCache)
    {
        NSNumber *number = [self sea_cachedCellHeightForIndexPath:indexPath];
        if (number != nil && [number floatValue] != 0)
        {
            return [number floatValue];
        }
    }
    
    if(configuration != nil)
    {
        configuration(cell);
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    
    ///当使用系统的accessoryView时，content宽度会向右偏移
    if (cell.accessoryView)
    {
        width -= 16.0 + CGRectGetWidth(cell.accessoryView.frame);
    }
    else
    {
        switch (cell.accessoryType)
        {
            case UITableViewCellAccessoryDisclosureIndicator :
                //箭头
                width -= 34.0;
                break;
            case UITableViewCellAccessoryCheckmark :
                //勾
                width -= 40.0;
                break;
            case UITableViewCellAccessoryDetailButton :
                //详情
                width -= 48.0;
                break;
            case UITableViewCellAccessoryDetailDisclosureButton :
                //箭头+详情
                width -= 68.0;
                break;
            default:
                break;
        }
    }
    
    UIView *contentView = cell.contentView;
    
    CGFloat height = [contentView sea_sizeThatFits:CGSizeMake(width, 0) type:SeaAutoLayoutCalculateTypeHeight].height;
    
    ///如果有分割线 加上1px
    if(self.separatorStyle != UITableViewCellSeparatorStyleNone)
    {
        height += 1.0 / [UIScreen mainScreen].scale;
    }
    
    //缓存高度
    [self sea_setCellHeight:[NSNumber numberWithFloat:height] forIndexPath:indexPath];
    
    return height;
}

/**获取header高度
 *@param identifier header唯一标识
 *@param section header下标
 *@return header 高度
 */
- (CGFloat)sea_headerHeightForIdentifier:(NSString*) identifier section:(NSInteger) section configuration:(SeaTableHeaderFooterConfiguration) configuration
{
    CGFloat height = [self sea_cachedHeaderHeightForSection:section];
    if(height != 0)
        return height;
    
    return [self sea_heightForHeaderOrFooter:[self sea_cellForIdentifier:identifier] section:section isHeader:YES configuration:configuration useCache:NO];
}

/**获取header高度 主要用于静态 header，不重用的header
 *@warning 如果使用静态的header，刷新行时不要使用 reloadSections，使用reloadData
 *@param header 要计算高度的header
 *@param section header下标
 */
- (CGFloat)sea_heightForHeader:(UIView*) header section:(NSInteger) section
{
   return [self sea_heightForHeader:header section:section configuration:nil];
}

/**获取header高度 主要用于静态 header，不重用的header
 *@warning 如果使用静态的header，刷新行时不要使用 reloadSections，使用reloadData
 *@param header 要计算高度的header
 *@param section header下标
 */
- (CGFloat)sea_heightForHeader:(UIView*) header section:(NSInteger) section configuration:(SeaTableHeaderFooterConfiguration) configuration
{
    return [self sea_heightForHeaderOrFooter:header section:section isHeader:YES configuration:configuration useCache:YES];
}

/**获取footer高度
 *@param identifier footer唯一标识
 *@param section footer下标
 *@return header 高度
 */
- (CGFloat)sea_footerHeightForIdentifier:(NSString*) identifier section:(NSInteger) section configuration:(SeaTableHeaderFooterConfiguration) configuration
{
    CGFloat height = [self sea_cachedFooterHeightForSection:section];
    if(height != 0)
        return height;
    
    return [self sea_heightForHeaderOrFooter:[self sea_cellForIdentifier:identifier] section:section isHeader:NO configuration:configuration useCache:NO];
}

/**获取footer高度 主要用于静态 footer，不重用的footer
 *@warning 如果使用静态的footer，刷新行时不要使用 reloadSections，使用reloadData
 *@param footer 要计算高度的footer
 *@param section footer下标
 */
- (CGFloat)sea_heightForFooter:(UIView*) footer section:(NSInteger) section
{
    return [self sea_heightForFooter:footer section:section configuration:nil];
}

/**获取footer高度 主要用于静态 footer，不重用的footer
 *@warning 如果使用静态的footer，刷新行时不要使用 reloadSections，使用reloadData
 *@param footer 要计算高度的footer
 *@param section footer下标
 */
- (CGFloat)sea_heightForFooter:(UIView*) footer section:(NSInteger) section configuration:(SeaTableHeaderFooterConfiguration) configuration
{
     return [self sea_heightForHeaderOrFooter:footer section:section isHeader:NO configuration:configuration useCache:YES];
}

/**获取header or footer高度 主要用于静态 ，不重用的
 *@warning 如果使用静态的footer，刷新行时不要使用 reloadSections，使用reloadData
 *@param headerOrFooter 要计算高度的header or footer
 *@param isHeader 是否是 头部
 *@param section header or footer下标
 *@param useCache 是否使用缓存
 */
- (CGFloat)sea_heightForHeaderOrFooter:(UIView*) headerOrFooter section:(NSInteger) section isHeader:(BOOL) isHeader configuration:(SeaTableHeaderFooterConfiguration) configuration useCache:(BOOL) useCache
{
    if(useCache)
    {
        CGFloat height = isHeader ? [self sea_cachedHeaderHeightForSection:section] : [self sea_cachedFooterHeightForSection:section];
        if(height != 0)
            return height;
    }
    
    if(configuration != nil)
    {
        configuration(headerOrFooter);
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    
    UIView *contentView = headerOrFooter;
//    if([headerOrFooter isKindOfClass:[UITableViewHeaderFooterView class]])
//    {
//        contentView = [(UITableViewHeaderFooterView*)headerOrFooter contentView];
//        if(contentView == nil)
//            contentView = headerOrFooter;
//    }
    
    CGFloat height = [contentView sea_sizeThatFits:CGSizeMake(width, 0) type:SeaAutoLayoutCalculateTypeHeight].height;
    
    if(isHeader)
    {
        [self sea_setHeaderHeight:height forSection:section];
    }
    else
    {
        [self sea_setFooterHeight:height forSection:section];
    }
    
    return height;
}

#pragma mark - cell大小缓存

///缓存cell大小的数组
- (NSMutableDictionary<NSNumber*, SeaTableViewSectionInfo* >*)sea_rowHeightCaches
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
- (NSNumber*)sea_cachedCellHeightForIndexPath:(NSIndexPath*) indexPath
{
    SeaTableViewSectionInfo *info = [[self sea_rowHeightCaches] objectForKey:@(indexPath.section)];
    if(info.rowHeights == nil)
        return nil;
    return [info.rowHeights objectForKey:@(indexPath.row)];
}

- (CGFloat)sea_cachedHeaderHeightForSection:(NSInteger) section
{
    SeaTableViewSectionInfo *info = [[self sea_rowHeightCaches] objectForKey:@(section)];
    return info.headerHeight;
}

- (CGFloat)sea_cachedFooterHeightForSection:(NSInteger) section
{
    SeaTableViewSectionInfo *info = [[self sea_rowHeightCaches] objectForKey:@(section)];
    return info.footerHeight;
}

///设置缓存
- (SeaTableViewSectionInfo*)sea_sectionInfoForSection:(NSInteger) section
{
    NSMutableDictionary *caches = [self sea_rowHeightCaches];
    SeaTableViewSectionInfo *info = [caches objectForKey:@(section)];
    if(info == nil)
    {
        info = [SeaTableViewSectionInfo new];
        [caches setObject:info forKey:@(section)];
    }
    return info;
}

- (void)sea_setCellHeight:(NSNumber*) height forIndexPath:(NSIndexPath*) indexPath
{
    SeaTableViewSectionInfo *info = [self sea_sectionInfoForSection:indexPath.section];
    
    if(height != nil)
    {
        [info.rowHeights setObject:height forKey:@(indexPath.row)];
    }
    else
    {
        [info.rowHeights removeObjectForKey:@(indexPath.row)];
    }
}

- (void)sea_setHeaderHeight:(CGFloat) height forSection:(NSInteger) section
{
    SeaTableViewSectionInfo *info = [self sea_sectionInfoForSection:section];
    info.headerHeight = height;
}

- (void)sea_setFooterHeight:(CGFloat) height forSection:(NSInteger) section
{
    SeaTableViewSectionInfo *info = [self sea_sectionInfoForSection:section];
    info.footerHeight = height;
}

#pragma mark- 注册的 cells

///注册的cells header footer 用来计算
- (NSMutableDictionary *)sea_cells
{
    NSMutableDictionary<NSString*, UITableViewCell*> *cells = objc_getAssociatedObject(self, _cmd);
    if (cells == nil)
    {
        cells = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, cells, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cells;
}

- (UITableViewCell *)sea_cellForIdentifier:(NSString *)identifier
{
    return [[self sea_cells] objectForKey:identifier];
}



@end
