//
//  UIView+SeaSkeleton.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/4.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "UIView+SeaSkeleton.h"
#import <objc/runtime.h>
#import <NSObject+Utils.h>
#import "SeaSkeletonHelper.h"
#import "SeaSkeletonLayer.h"
#import "SeaSkeletonAnimationHelper.h"

static char SeaShouldBecomeSkeletonKey;
static char SeaSkeletonLayerKey;
static char SeaSkeletonStatusKey;
static char SeaSkeletonAnimationHelperKey;

@implementation UIView (SeaSkeleton)

+ (void)load
{
    [self sea_exchangeImplementations:@selector(layoutSubviews) prefix:@"sea_skeleton_"];
}

- (void)sea_skeleton_layoutSubviews
{
    [self sea_skeleton_layoutSubviews];
    
    if([self shouldAddSkeletonLayer] && self.sea_skeletonStatus == SeaSkeletonStatusWillShow){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sea_skeletonStatus = SeaSkeletonStatusShowing;
            
            SeaSkeletonLayer *layer = [SeaSkeletonLayer layer];
            NSMutableArray *layers = [NSMutableArray array];
            [SeaSkeletonHelper createLayers:layers fromView:self rootView:self];
            layer.skeletonSubLayers = layers;
            
            [self.layer addSublayer:layer];
            self.sea_skeletonLayer = layer;
        });
    }
}

- (void)setSea_shouldBecomeSkeleton:(BOOL)sea_shouldBecomeSkeleton
{
    objc_setAssociatedObject(self, &SeaShouldBecomeSkeletonKey, @(SeaShouldBecomeSkeletonKey), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)sea_shouldBecomeSkeleton
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldBecomeSkeletonKey);
    if(number){
        return number.boolValue;
    }else{
        return [SeaSkeletonHelper shouldBecomeSkeleton:self];
    }
}

- (SeaSkeletonStatus)sea_skeletonStatus
{
    return [objc_getAssociatedObject(self, &SeaSkeletonStatusKey) integerValue];
}

- (void)setSea_skeletonStatus:(SeaSkeletonStatus)sea_skeletonStatus
{
    objc_setAssociatedObject(self, &SeaSkeletonStatusKey, @(sea_skeletonStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSea_skeletonLayer:(SeaSkeletonLayer *)sea_skeletonLayer
{
    SeaSkeletonLayer *layer = self.sea_skeletonLayer;
    if(layer){
        [layer removeFromSuperlayer];
    }
    if(!sea_skeletonLayer){
        self.userInteractionEnabled = YES;
        self.sea_skeletonStatus = SeaSkeletonStatusNone;
        [self setSea_skeletonAnimationHelper:nil];
    }
    objc_setAssociatedObject(self, &SeaSkeletonLayerKey, sea_skeletonLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SeaSkeletonLayer *)sea_skeletonLayer
{
    return objc_getAssociatedObject(self, &SeaSkeletonLayerKey);
}

- (void)sea_showSkeleton
{
    [self sea_showSkeletonWithDuration:0 completion:nil];
}

- (void)sea_showSkeletonWithCompletion:(SeaShowSkeletonCompletionHandler) completion
{
    [self sea_showSkeletonWithDuration:0.5 completion:completion];
}

- (void)sea_showSkeletonWithDuration:(NSTimeInterval) duration completion:(SeaShowSkeletonCompletionHandler) completion
{
    if(self.sea_skeletonStatus == SeaSkeletonStatusNone){
        self.sea_skeletonStatus = SeaSkeletonStatusWillShow;
        if([self shouldAddSkeletonLayer]){
            self.userInteractionEnabled = NO;
            [self setNeedsLayout];
        }
        
        if(duration > 0 && completion){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                completion();
            });
        }
    }
}

- (void)sea_hideSkeletonWithAnimate:(BOOL)animate
{
    [self sea_hideSkeletonWithAnimate:animate completion:nil];
}

- (void)sea_hideSkeletonWithAnimate:(BOOL) animate completion:(void(^)(BOOL finished)) completion
{
    SeaSkeletonStatus status = self.sea_skeletonStatus;
    if(status == SeaSkeletonStatusShowing || status == SeaSkeletonStatusWillShow){
        self.sea_skeletonStatus = SeaSkeletonStatusWillHide;
        
        if(animate){
            
            __weak UIView *weakSelf = self;
            [self.sea_skeletonAnimationHelper executeOpacityAnimationForLayer:self.sea_skeletonLayer completion:^(BOOL finished) {
                weakSelf.sea_skeletonLayer = nil;
                !completion ?: completion(finished);
            }];
            
        }else{
            self.sea_skeletonLayer = nil;
            !completion ?: completion(YES);
        }
    }
}

- (SeaSkeletonAnimationHelper*)sea_skeletonAnimationHelper
{
    SeaSkeletonAnimationHelper *helper = objc_getAssociatedObject(self, &SeaSkeletonAnimationHelperKey);
    if(!helper){
        helper = [SeaSkeletonAnimationHelper new];
        [self setSea_skeletonAnimationHelper:helper];
    }
    
    return helper;
}

- (void)setSea_skeletonAnimationHelper:(SeaSkeletonAnimationHelper*) helper
{
    objc_setAssociatedObject(self, &SeaSkeletonAnimationHelperKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldAddSkeletonLayer
{
    //列表 和 集合视图 使用他们的cell header footer 来生成
    if([self isKindOfClass:UITableView.class] || [self isKindOfClass:UICollectionView.class])
        return NO;
    
    return YES;
}

@end
