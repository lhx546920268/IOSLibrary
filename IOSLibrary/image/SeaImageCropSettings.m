//
//  SeaImageCropSettings.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/1.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaImageCropSettings.h"

@implementation SeaImageCropSettings

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.useFullScreenCropFrame = YES;
        self.limitRatio = 2.5;
    }
    
    return self;
}

@end
