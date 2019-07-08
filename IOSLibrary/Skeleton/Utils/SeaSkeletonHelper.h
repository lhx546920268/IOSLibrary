//
//  SeaSkeletonHelper.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/4.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIkit.h>

@class SeaSkeletonSubLayer;

///骨架帮助类
@interface SeaSkeletonHelper : NSObject

/**
 是否需要成为骨架视图

 @param view 视图
 @return 是否成为骨架图层
 */
+ (BOOL)shouldBecomeSkeleton:(UIView*) view;


/**
 创建骨架图层

 @param layers 骨架图层数组
 @param view 要成为骨架图层的视图
 @param rootView 根视图
 */
+ (void)createLayers:(NSMutableArray<SeaSkeletonSubLayer*>*) layers fromView:(UIView*) view rootView:(UIView*) rootView;

/**
 替换某个方法的实现 新增的方法要加一个前缀sea_skeleton_

 @param selector 要替换的方法
 @param owner 方法的拥有者
 @param implementer 新方法的实现者
 */
+ (void)replaceImplementations:(SEL) selector owner:(NSObject*) owner implementer:(NSObject*) implementer;

@end

