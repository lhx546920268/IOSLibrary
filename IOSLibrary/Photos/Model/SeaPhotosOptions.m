//
//  SeaPhotosOptions.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/1.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosOptions.h"

@implementation SeaPhotosOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxCount = 1;
        self.gridInterval = 3;
        self.numberOfItemsPerRow = 4;
    }
    return self;
}

@end
