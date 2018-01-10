//
//  UITableView+SeaEmptyView.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/12.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UITableView+SeaEmptyView.h"
#import "UIScrollView+SeaEmptyView.h"
#import "SeaEmptyView.h"
#import "UIView+SeaEmptyView.h"
#import "UIView+Utils.h"
#import <objc/runtime.h>

static char SeaShouldShowEmptyViewWhenExistTableHeaderViewKey;
static char SeaShouldShowEmptyViewWhenExistTableFooterViewKey;
static char SeaShouldShowEmptyViewWhenExistSectionHeaderViewKey;
static char SeaShouldShowEmptyViewWhenExistSectionFooterViewKey;

@implementation UITableView (SeaEmptyView)

#pragma mark- super method

- (void)layoutEmtpyView
{
    [super layoutEmtpyView];
    
    SeaEmptyView *emptyView = self.sea_emptyView;
    if(emptyView && emptyView.superview && !emptyView.hidden)
    {
        CGRect frame = emptyView.frame;
        CGFloat y = frame.origin.y;
        
        [self.tableHeaderView layoutIfNeeded];
        [self.tableFooterView layoutIfNeeded];
        
        y += self.tableHeaderView.height;
        y += self.tableFooterView.height;
        
        frame.origin.y = y;
        frame.size.height = self.height - y;
        if(frame.size.height <= 0)
        {
            [emptyView removeFromSuperview];
        }
        else
        {
            emptyView.frame = frame;
        }
    }
}

- (BOOL)isEmptyData
{
    BOOL empty = YES;
    
    if(!self.sea_shouldShowEmptyViewWhenExistTableHeaderView && self.tableHeaderView)
    {
        empty = NO;
    }
    
    if(!self.sea_shouldShowEmptyViewWhenExistTableFooterView && self.tableFooterView)
    {
        empty = NO;
    }
    
    if(empty && self.dataSource)
    {
        NSInteger section = 1;
        if([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
        {
            section = [self.dataSource numberOfSectionsInTableView:self];
        }
        
        if([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
        {
            for(NSInteger i = 0;i < section;i ++)
            {
                NSInteger row = [self.dataSource tableView:self numberOfRowsInSection:i];
                if(row > 0)
                {
                    empty = NO;
                    break;
                }
            }
        }
        
        ///行数为0，section 大于0时，可能存在sectionHeader
        if(empty && section > 0 && self.delegate)
        {
            if(!self.sea_shouldShowEmptyViewWhenExistSectionHeaderView && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
            {
                for(NSInteger i = 0; i < section;i ++)
                {
                    UIView *view = [self.delegate tableView:self viewForHeaderInSection:i];
                    if(view)
                    {
                        empty = NO;
                        break;
                    }
                }
            }
            
            if(empty && !self.sea_shouldShowEmptyViewWhenExistSectionFooterView && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
            {
                for(NSInteger i = 0; i < section;i ++)
                {
                    UIView *view = [self.delegate tableView:self viewForFooterInSection:i];
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

- (void)setSea_shouldShowEmptyViewWhenExistTableHeaderView:(BOOL)sea_shouldShowEmptyViewWhenExistTableHeaderView
{
    objc_setAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistTableHeaderViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyViewWhenExistTableHeaderView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_shouldShowEmptyViewWhenExistTableHeaderView
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistTableHeaderViewKey);
    if(number)
    {
        return [number boolValue];
    }
    
    return YES;
}

- (void)setSea_shouldShowEmptyViewWhenExistTableFooterView:(BOOL)sea_shouldShowEmptyViewWhenExistTableFooterView
{
    objc_setAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistTableFooterViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyViewWhenExistTableFooterView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_shouldShowEmptyViewWhenExistTableFooterView
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistTableFooterViewKey);
    if(number)
    {
        return [number boolValue];
    }
    
    return YES;
}


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
        @selector(reloadSections:withRowAnimation:),
        @selector(insertRowsAtIndexPaths:withRowAnimation:),
        @selector(insertSections:withRowAnimation:),
        @selector(deleteRowsAtIndexPaths:withRowAnimation:),
        @selector(deleteSections:withRowAnimation:)
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

- (void)sea_empty_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self layoutEmtpyView];
    [self sea_empty_reloadSections:sections withRowAnimation:animation];
}

- (void)sea_empty_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self layoutEmtpyView];
    [self sea_empty_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)sea_empty_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self layoutEmtpyView];
    [self sea_empty_insertSections:sections withRowAnimation:animation];
}

- (void)sea_empty_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self layoutEmtpyView];
    [self sea_empty_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)sea_empty_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self layoutEmtpyView];
    [self sea_empty_deleteSections:sections withRowAnimation:animation];
}


@end
