//
//  SeaSkeletonLayer.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/4.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaSkeletonLayer.h"
#import "SeaSkeletonSubLayer.h"

@implementation SeaSkeletonLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.skeletonBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    return self;
}

- (void)setSkeletonSubLayers:(NSArray<SeaSkeletonSubLayer *> *)skeletonSubLayers
{
    if(_skeletonSubLayers != skeletonSubLayers){
        for(SeaSkeletonSubLayer *layer in _skeletonSubLayers){
            [layer removeFromSuperlayer];
        }
        _skeletonSubLayers = [skeletonSubLayers copy];
        
        for(SeaSkeletonSubLayer *layer in _skeletonSubLayers){
            layer.backgroundColor = self.skeletonBackgroundColor.CGColor;
            [self addSublayer:layer];
        }
    }
}

@end
