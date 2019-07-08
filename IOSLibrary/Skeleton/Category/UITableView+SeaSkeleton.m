//
//  UITableView+SeaSkeleton.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/4.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "UITableView+SeaSkeleton.h"
#import <NSObject+Utils.h>
#import "UIView+SeaSkeleton.h"
#import <objc/runtime.h>
#import "SeaSkeletonHelper.h"

static char SeaSkeletonHideAnimateKey;

@implementation UITableView (SeaSkeleton)

+ (void)load
{
    [self sea_exchangeImplementations:@selector(setDelegate:) prefix:@"sea_skeleton_"];
    [self sea_exchangeImplementations:@selector(setDataSource:) prefix:@"sea_skeleton_"];
}

- (void)sea_skeleton_setDelegate:(id<UITableViewDelegate>)delegate
{
    if(delegate){
        [SeaSkeletonHelper replaceImplementations:@selector(tableView:didSelectRowAtIndexPath:) owner:delegate implementer:self];
        [SeaSkeletonHelper replaceImplementations:@selector(tableView:viewForHeaderInSection:) owner:delegate implementer:self];
        [SeaSkeletonHelper replaceImplementations:@selector(tableView:viewForFooterInSection:) owner:delegate implementer:self];
        [SeaSkeletonHelper replaceImplementations:@selector(tableView:shouldHighlightRowAtIndexPath:) owner:delegate implementer:self];
    }
    
    [self sea_skeleton_setDelegate:delegate];
}

- (void)sea_skeleton_setDataSource:(id<UITableViewDataSource>)dataSource
{
    if(dataSource){
        [SeaSkeletonHelper replaceImplementations:@selector(tableView:cellForRowAtIndexPath:) owner:dataSource implementer:self];
    }
    
    [self sea_skeleton_setDataSource:dataSource];
}

- (void)sea_showSkeletonWithDuration:(NSTimeInterval)duration completion:(SeaShowSkeletonCompletionHandler)completion
{
    if(self.sea_skeletonStatus == SeaSkeletonStatusNone){
        self.sea_skeletonStatus = SeaSkeletonStatusShowing;
        [self reloadData];
        
        if(duration > 0 && completion){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                completion();
            });
        }
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

//MARK: UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.sea_skeletonStatus == SeaSkeletonStatusNone;
}

- (BOOL)sea_skeleton_tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.sea_skeletonStatus != SeaSkeletonStatusNone){
        return NO;
    }
    
    return [self sea_skeleton_tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
}

- (UIView*)sea_skeleton_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [self sea_skeleton_tableView:tableView viewForFooterInSection:section];
    
    SeaSkeletonStatus status = tableView.sea_skeletonStatus;
    switch (status) {
        case SeaSkeletonStatusShowing : {
            
            [view sea_showSkeleton];
        }
            break;
        case SeaSkeletonStatusWillHide: {
            
            __weak UITableView *weakSelf = tableView;
            [view sea_hideSkeletonWithAnimate:tableView.sea_skeletonHideAnimate completion:^(BOOL finished) {
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

- (UIView*)sea_skeleton_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [self sea_skeleton_tableView:tableView viewForHeaderInSection:section];
    
    SeaSkeletonStatus status = tableView.sea_skeletonStatus;
    switch (status) {
        case SeaSkeletonStatusShowing : {
            
            [view sea_showSkeleton];
        }
            break;
        case SeaSkeletonStatusWillHide: {
            
            __weak UITableView *weakSelf = tableView;
            [view sea_hideSkeletonWithAnimate:tableView.sea_skeletonHideAnimate completion:^(BOOL finished) {
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

- (UITableViewCell*)sea_skeleton_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self sea_skeleton_tableView:tableView cellForRowAtIndexPath:indexPath];
    
    SeaSkeletonStatus status = tableView.sea_skeletonStatus;
    switch (status) {
        case SeaSkeletonStatusShowing : {
            
            [cell.contentView sea_showSkeleton];
        }
            break;
        case SeaSkeletonStatusWillHide: {
            
            __weak UITableView *weakSelf = tableView;
            [cell.contentView sea_hideSkeletonWithAnimate:tableView.sea_skeletonHideAnimate completion:^(BOOL finished) {
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

- (void)sea_skeleton_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.sea_skeletonStatus != SeaSkeletonStatusNone){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    [self sea_skeleton_tableView:tableView didSelectRowAtIndexPath:indexPath];
}


@end
