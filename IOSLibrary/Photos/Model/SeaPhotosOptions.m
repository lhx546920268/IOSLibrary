//
//  SeaPhotosOptions.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/1.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosOptions.h"

@implementation SeaPhotosPickResult


@end

@implementation SeaPhotosOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxCount = 1;
        self.gridInterval = 3;
        self.numberOfItemsPerRow = 4;
        self.shouldDisplayAllPhotos = YES;
        self.displayFistCollection = YES;
        self.compressedImageSize = CGSizeMake(512, 512);
    }
    return self;
}

@end
