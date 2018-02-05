//
//  SeaCollectionViewAlignFlowLayout.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/6/17.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import "SeaCollectionViewFlowLayout.h"

@interface SeaCollectionViewFlowLayout()

/**
 是否已实现悬浮头部代理
 */
@property(nonatomic,assign) BOOL shouldStickHeaderDelegate;

@end

@implementation SeaCollectionViewFlowLayout

- (void)prepareLayout
{
    self.shouldStickHeaderDelegate = [self.s_delegate respondsToSelector:@selector(collectionViewFlowLayout:shouldStickHeaderAtSection:)];
    [super prepareLayout];
}

- (id<SeaCollectionViewFlowLayoutDelegate>)s_delegate
{
    return (id<SeaCollectionViewFlowLayoutDelegate>)self.collectionView.delegate;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    if(self.itemAlignment == SeaCollectionViewItemAlignmentDefault || !self.shouldStickHeaderDelegate)
        return attributes;

    UICollectionViewLayoutAttributes *prevousAttr = nil;

    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    UIEdgeInsets insets = self.sectionInset;
    NSInteger section = NSNotFound;

    ///可见的section，如果该section没有cell，则不需要悬浮，所以这里不包含header
    NSMutableArray *visibleSections = nil;

    if(self.shouldStickHeaderDelegate){
        visibleSections = [NSMutableArray array];
        for(UICollectionViewLayoutAttributes *attr in attributes){
            if(![attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]){
                NSNumber *number = [NSNumber numberWithInteger:attr.indexPath.section];
                if(![visibleSections containsObject:number]){
                    [visibleSections addObject:number];
                }
            }
        }
        
        ///由于系统会把header移除，所以要重新加入
        for(NSNumber *number in visibleSections){
            BOOL should = [self.s_delegate collectionViewFlowLayout:self shouldStickHeaderAtSection:number.integerValue];;
            
            if(should){
                UICollectionViewLayoutAttributes *attr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:number.integerValue]];
                
                if(attr.frame.size.width > 0 && attr.frame.size.height > 0){
                    [attributes addObject:attr];
                }
            }
        }
    }
    
    
    for(UICollectionViewLayoutAttributes *attr in attributes){
        if(attr.representedElementCategory == UICollectionElementCategoryCell && self.itemAlignment != SeaCollectionViewItemAlignmentDefault){

            if(section != attr.indexPath.section){
                if([self.s_delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]){
                    minimumInteritemSpacing = [self.s_delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:attr.indexPath.section];
                }

                if([self.s_delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]){
                    insets = [self.s_delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:attr.indexPath.section];
                    section = attr.indexPath.section;
                }

                section = attr.indexPath.section;
            }

            if(prevousAttr){
                if(attr.frame.origin.y == prevousAttr.frame.origin.y){
                    CGRect frame = attr.frame;
                    frame.origin.x = prevousAttr.frame.origin.x + prevousAttr.frame.size.width + minimumInteritemSpacing;
                    attr.frame = frame;
                }else{
                    ///另起一行了
                    CGRect frame = attr.frame;
                    frame.origin.x = insets.left;
                    attr.frame = frame;
                }
            }else{
                CGRect frame = attr.frame;
                frame.origin.x = insets.left;
                attr.frame = frame;
            }

            prevousAttr = attr;
        }else if (self.shouldStickHeaderDelegate && [attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]){
            BOOL should = [self.s_delegate collectionViewFlowLayout:self shouldStickHeaderAtSection:attr.indexPath.section];;

            if(should){
                CGPoint contentOffset = self.collectionView.contentOffset;
                CGPoint originInCollectionView = CGPointMake(attr.frame.origin.x - contentOffset.x, attr.frame.origin.y - contentOffset.y);
                originInCollectionView.y -= self.collectionView.contentInset.top;
                
                CGRect frame = attr.frame;
                
                if (originInCollectionView.y < 0){
                    frame.origin.y += (originInCollectionView.y * -1);
                }
                
                NSInteger numberOfSections = 1;
                if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]){
                    numberOfSections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
                }
                
                if (numberOfSections > attr.indexPath.section + 1){
                    UICollectionViewLayoutAttributes *nextHeaderAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:attr.indexPath.section + 1]];
                    CGFloat maxY = nextHeaderAttr.frame.origin.y;
                    if(CGRectGetMaxY(frame) >= maxY){
                        frame.origin.y = maxY - frame.size.height;
                    }
                }
                attr.frame = frame;
            }
            
            ///防止后面的cell覆盖header
            attr.zIndex = NSNotFound;
        }
    }

    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if(self.shouldStickHeaderDelegate){
        return YES;
    }
    
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

@end
