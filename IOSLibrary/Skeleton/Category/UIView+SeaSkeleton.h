//
//  UIView+SeaSkeleton.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/4.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaSkeletonLayer;

//显示骨架延迟回调
typedef void(^SeaShowSkeletonCompletionHandler)(void);

//骨架状态
typedef NS_ENUM(NSInteger, SeaSkeletonStatus){
    
    ///什么都没
    SeaSkeletonStatusNone,
    
    ///准备要显示了
    SeaSkeletonStatusWillShow,
    
    ///正在显示
    SeaSkeletonStatusShowing,
    
    ///将要隐藏了
    SeaSkeletonStatusWillHide,
};

///为视图创建骨架扩展
@interface UIView (SeaSkeleton)

///是否需要添加为骨架图层 子视图用的
@property(nonatomic, assign) BOOL sea_shouldBecomeSkeleton;

///骨架显示状态 根视图用 内部使用 不要直接设置这个值
@property(nonatomic, assign) SeaSkeletonStatus sea_skeletonStatus;

///骨架图层
@property(nonatomic, strong) SeaSkeletonLayer *sea_skeletonLayer;

///显示骨架
- (void)sea_showSkeleton;

///显示骨架 0.3s 延迟
- (void)sea_showSkeletonWithCompletion:(SeaShowSkeletonCompletionHandler) completion;

///显示骨架
- (void)sea_showSkeletonWithDuration:(NSTimeInterval) duration completion:(SeaShowSkeletonCompletionHandler) completion;

///隐藏骨架
- (void)sea_hideSkeletonWithAnimate:(BOOL) animate completion:(void(^)(BOOL finished)) completion;

///是否需要添加骨架图层 某些视图会自己处理 默认YES
- (BOOL)shouldAddSkeletonLayer;

@end
