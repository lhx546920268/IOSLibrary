//
//  UICollectionView+SeaSkeleton.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/8.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "UICollectionView+SeaSkeleton.h"
#import <NSObject+Utils.h>
#import "UIView+SeaSkeleton.h"
#import <objc/runtime.h>
#import "SeaSkeletonHelper.h"

static char SeaSkeletonHideAnimateKey;

@implementation UICollectionView (SeaSkeleton)

+ (void)load
{
    [self sea_exchangeImplementations:@selector(setDelegate:) prefix:@"sea_skeleton_"];
    [self sea_exchangeImplementations:@selector(setDataSource:) prefix:@"sea_skeleton_"];
}

- (void)sea_skeleton_setDelegate:(id<UICollectionViewDelegate>)delegate
{
    [self sea_skeleton_setDelegate:delegate];
    
    if(delegate){
        [SeaSkeletonHelper replaceImplementations:@selector(collectionView:didSelectItemAtIndexPath:) owner:delegate implementer:self];
        [SeaSkeletonHelper replaceImplementations:@selector(collectionView:shouldHighlightItemAtIndexPath:) owner:delegate implementer:self];
    }
}

- (void)sea_skeleton_setDataSource:(id<UICollectionViewDataSource>)dataSource
{
    [self sea_skeleton_setDataSource:dataSource];
    if(dataSource){
        [SeaSkeletonHelper replaceImplementations:@selector(collectionView:cellForItemAtIndexPath:) owner:dataSource implementer:self];
        [SeaSkeletonHelper replaceImplementations:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:) owner:dataSource implementer:self];
    }
}

- (void)sea_showSkeleton
{
    if(self.sea_skeletonStatus == SeaSkeletonStatusNone){
        self.sea_skeletonStatus = SeaSkeletonStatusShowing;
        [self reloadData];
    }
}

- (void)setSea_skeletonHideAnimate:(BOOL) animate
{
    objc_setAssociatedObject(self, &SeaSkeletonHideAnimateKey, @(animate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_skeletonHideAnimate
{
    return [objc_getAssociatedObject(self, &SeaSkeletonHideAnimateKey) boolValue];
}

- (void)sea_hideSkeletonWithAnimate:(BOOL)animate completion:(void (^)(BOOL))completion
{
    SeaSkeletonStatus status = self.sea_skeletonStatus;
    if(status == SeaSkeletonStatusShowing){
        self.sea_skeletonStatus = SeaSkeletonStatusWillHide;
        [self setSea_skeletonHideAnimate:animate];
        [self reloadData];
    }
}

//MARK: UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.sea_skeletonStatus == SeaSkeletonStatusNone;
}

- (BOOL)sea_skeleton_collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.sea_skeletonStatus != SeaSkeletonStatusNone){
        return NO;
    }
    return [self sea_skeleton_collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
}

- (UICollectionViewCell*)sea_skeleton_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self sea_skeleton_collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    SeaSkeletonStatus status = collectionView.sea_skeletonStatus;
    switch (status) {
        case SeaSkeletonStatusShowing : {
            
            [cell.contentView sea_showSkeleton];
        }
            break;
        case SeaSkeletonStatusWillHide: {
            
            __weak UICollectionView *weakSelf = collectionView;
            [cell.contentView sea_hideSkeletonWithAnimate:collectionView.sea_skeletonHideAnimate completion:^(BOOL finished) {
                if(weakSelf.sea_skeletonStatus == SeaSkeletonStatusWillHide){
                    weakSelf.sea_skeletonLayer = nil;
                }
            }];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (UICollectionReusableView *)sea_skeleton_collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [self sea_skeleton_collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    
    SeaSkeletonStatus status = collectionView.sea_skeletonStatus;
    switch (status) {
        case SeaSkeletonStatusShowing : {
            
            [view sea_showSkeleton];
        }
            break;
        case SeaSkeletonStatusWillHide: {
            
            __weak UICollectionView *weakSelf = collectionView;
            [view sea_hideSkeletonWithAnimate:collectionView.sea_skeletonHideAnimate completion:^(BOOL finished) {
                if(weakSelf.sea_skeletonStatus == SeaSkeletonStatusWillHide){
                    weakSelf.sea_skeletonLayer = nil;
                }
            }];
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (void)sea_skeleton_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.sea_skeletonStatus != SeaSkeletonStatusNone){
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        return;
    }
    
    [self sea_skeleton_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

@end
