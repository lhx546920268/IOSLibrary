//
//  SeaSkeletonSubLayer.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/4.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaSkeletonSubLayer.h"

@implementation SeaSkeletonSubLayer

- (void)copyPropertiesFromLayer:(CALayer *)layer
{
    self.cornerRadius = layer.cornerRadius;
    self.masksToBounds = layer.masksToBounds;
}

@end
