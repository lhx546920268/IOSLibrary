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

- (void)layoutEmtpyView
{
    [super layoutEmtpyView];
    
    SeaEmptyView *emptyView = self.sea_emptyView;
    if(emptyView && emptyView.superview && !emptyView.hidden){
        CGRect frame = emptyView.frame;
        CGFloat y = frame.origin.y;
        
        ///获取sectionHeader 高度
        if(self.sea_shouldShowEmptyViewWhenExistSectionHeaderView && [self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]){
            UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
            id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.delegate;
            
            NSInteger section = self.numberOfSections;
            if([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]){
                for(NSInteger i = 0;i < section;i ++){
                    y += [delegate collectionView:self layout:layout referenceSizeForHeaderInSection:i].height;
                }
            }else{
                y += section * layout.headerReferenceSize.height;
            }
        }
        
        ///获取section footer 高度
        if(self.sea_shouldShowEmptyViewWhenExistSectionFooterView && [self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]){
                UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
                id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.delegate;
                
                NSInteger section = self.numberOfSections;
                if([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]){
                    for(NSInteger i = 0;i < section;i ++){
                        y += [delegate collectionView:self layout:layout referenceSizeForFooterInSection:i].height;
                    }
                }else{
                    y += section * layout.footerReferenceSize.height;
                }
        }
        
        frame.origin.y = y;
        frame.size.height = self.height - y;
        if(frame.size.height <= 0){
            [emptyView removeFromSuperview];
        }else{
            emptyView.frame = frame;
        }
    }
}

- (BOOL)isEmptyData
{
    BOOL empty = YES;
    
    if(empty && self.dataSource){
        NSInteger section = self.numberOfSections;
        
        if([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]){
            for(NSInteger i = 0;i < section;i ++){
                NSInteger items = [self.dataSource collectionView:self numberOfItemsInSection:i];
                if(items > 0){
                    empty = NO;
                    break;
                }
            }
        }
        
        ///item为0，section 大于0时，可能存在sectionHeader
        if(empty && section > 0){
            if(!self.sea_shouldShowEmptyViewWhenExistSectionHeaderView && [self.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]){
                for(NSInteger i = 0; i < section;i ++){
                    UIView *view = [self.dataSource collectionView:self viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                    if(view){
                        empty = NO;
                        break;
                    }
                }
            }
            
            if(empty && !self.sea_shouldShowEmptyViewWhenExistSectionFooterView && [self.delegate respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]){
                for(NSInteger i = 0; i < section;i ++){
                    UIView *view = [self.dataSource collectionView:self viewForSupplementaryElementOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                    if(view){
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
    if(number){
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
    if(number){
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
        @selector(layoutSubviews) //使用约束时 frame会在layoutSubviews得到
    };
    
    int count = sizeof(selectors) / sizeof(SEL);
    for(NSInteger i = 0;i < count;i ++){
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

///用于使用约束时没那么快得到 frame
- (void)sea_empty_layoutSubviews
{
    [self sea_empty_layoutSubviews];
    if(!CGSizeEqualToSize(self.sea_oldSize, self.frame.size)){
        self.sea_oldSize = self.frame.size;
        [self layoutEmtpyView];
    }
}

@end
