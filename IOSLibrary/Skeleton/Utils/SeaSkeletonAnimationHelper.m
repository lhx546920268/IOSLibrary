//
//  SeaSkeletonAnimationHelper.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/4.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaSkeletonAnimationHelper.h"

@implementation SeaSkeletonAnimationHelper

- (void)executeOpacityAnimationForLayer:(CALayer*) layer completion:(SeaSkeletonAnimationCompletion) completion
{
    self.completion = completion;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(1.0);
    animation.toValue = @(0);
    animation.duration = 0.25;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = (id<CAAnimationDelegate>)self;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:@"opacity"];
}

//MARK: CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    !self.completion ?: self.completion(flag);
    self.completion = nil;
}

@end
