//
//  SeaSkeletonLayer.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/4.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaSkeletonSubLayer;

///骨架图层
@interface SeaSkeletonLayer : CALayer

///骨架背景
@property(nonatomic, strong) UIColor *skeletonBackgroundColor;

///设置骨架子图层
@property(nonatomic, copy) NSArray<SeaSkeletonSubLayer*> *skeletonSubLayers;

@end
