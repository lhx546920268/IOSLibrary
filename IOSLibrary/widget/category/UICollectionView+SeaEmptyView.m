//
//  UICollectionView+SeaEmptyView.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/12.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UICollectionView+SeaEmptyView.h"
#import "UIScrollView+SeaEmptyView.h"
#import "SeaEmptyView.h"
#import "UIView+SeaEmptyView.h"
#import "UIView+Utils.h"
#import <objc/runtime.h>

static char SeaShouldShowEmptyViewWhenExistSectionHeaderViewKey;
static char SeaShouldShowEmptyViewWhenExistSectionFooterViewKey;

@implementation UICollectionView (SeaEmptyView)

#pragma mark- super method

- (BOOL)isEmptyData
{
    BOOL empty = YES;
    
    if(empty && self.dataSource)
    {
        NSInteger section = 1;
        if([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
        {
            section = [self.dataSource numberOfSectionsInCollectionView:self];
        }
        
        if([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)])
        {
            for(NSInteger i = 0;i < section;i ++)
            {
                NSInteger items = [self.dataSource collectionView:self numberOfItemsInSection:i];
                if(items > 0)
                {
                    empty = NO;
                    break;
                }
            }
        }
        
        ///item为0，section 大于0时，可能存在sectionHeader
        if(empty && section > 0)
        {
            if(!self.sea_shouldShowEmptyViewWhenExistSectionHeaderView && [self.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
            {
                for(NSInteger i = 0; i < section;i ++)
                {
                    UIView *view = [self.dataSource collectionView:self viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                    if(view)
                    {
                        empty = NO;
                        break;
                    }
                }
            }
            
            if(empty && !self.sea_shouldShowEmptyViewWhenExistSectionFooterView && [self.delegate respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
            {
                for(NSInteger i = 0; i < section;i ++)
                {
                    UIView *view = [self.dataSource collectionView:self viewForSupplementaryElementOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                    if(view)
                    {
                        empty = NO;
                        break;
                    }
                }
            }
        }
    }
    
    return empty;
}

#pragma mark- property

- (void)setSea_shouldShowEmptyViewWhenExistSectionHeaderView:(BOOL)sea_shouldShowEmptyViewWhenExistSectionHeaderView
{
    objc_setAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionHeaderViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyViewWhenExistSectionHeaderView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_shouldShowEmptyViewWhenExistSectionHeaderView
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionHeaderViewKey);
    if(number)
    {
        return [number boolValue];
    }
    
    return NO;
}


- (void)setSea_shouldShowEmptyViewWhenExistSectionFooterView:(BOOL)sea_shouldShowEmptyViewWhenExistSectionFooterView
{
    objc_setAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionFooterViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyViewWhenExistSectionFooterView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_shouldShowEmptyViewWhenExistSectionFooterView
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionFooterViewKey);
    if(number)
    {
        return [number boolValue];
    }
    
    return NO;
}

#pragma mark- swizzle

+ (void)load
{
    SEL selectors[] = {
        
        @selector(reloadData),
        @selector(reloadSections:),
        @selector(insertItemsAtIndexPaths:),
        @selector(insertSections:),
        @selector(deleteItemsAtIndexPaths:),
        @selector(deleteSections:),
    };
    
    int count = sizeof(selectors) / sizeof(SEL);
    for(NSInteger i = 0;i < count;i ++)
    {
        SEL selector1 = selectors[i];
        SEL selector2 = NSSelectorFromString([NSString stringWithFormat:@"sea_empty_%@", NSStringFromSelector(selector1)]);
        
        Method method1 = class_getInstanceMethod(self, selector1);
        Method method2 = class_getInstanceMethod(self, selector2);
        
        method_exchangeImplementations(method1, method2);
    }
}

- (void)sea_empty_reloadData
{
    [self layoutEmtpyView];
    [self sea_empty_reloadData];
}

- (void)sea_empty_reloadSections:(NSIndexSet *)sections
{
    [self layoutEmtpyView];
    [self sea_empty_reloadSections:sections];
}

- (void)sea_empty_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self layoutEmtpyView];
    [self sea_empty_insertItemsAtIndexPaths:indexPaths];
}

- (void)sea_empty_insertSections:(NSIndexSet *)sections
{
    [self layoutEmtpyView];
    [self sea_empty_insertSections:sections];
}

- (void)sea_empty_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self layoutEmtpyView];
    [self sea_empty_deleteItemsAtIndexPaths:indexPaths];
}

- (void)sea_empty_deleteSections:(NSIndexSet *)sections
{
    [self layoutEmtpyView];
    [self sea_empty_deleteSections:sections];
}

@end
