//
//  SeaSkeletonAnimationHelper.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/4.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///动画完成回调
typedef void(^SeaSkeletonAnimationCompletion)(BOOL finished);

///骨架动画帮助类
@interface SeaSkeletonAnimationHelper : NSObject<CAAnimationDelegate>

///动画完成回调
@property(nonatomic, copy) SeaSkeletonAnimationCompletion completion;

///执行透明度渐变动画
- (void)executeOpacityAnimationForLayer:(CALayer*) layer completion:(SeaSkeletonAnimationCompletion) completion;

@end

