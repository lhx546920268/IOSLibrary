//
//  SeaImageCacheOption.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaImageCacheOptions.h"

@implementation SeaImageCacheOptions

- (instancetype)init
{
    self = [super init];
    if(self){
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.originalContentMode = UIViewContentModeScaleToFill;
        self.placeholderContentMode = UIViewContentModeScaleAspectFit;
        self.shouldAspectRatioFit = YES;
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    SeaImageCacheOptions *option = [SeaImageCacheOptions allocWithZone:zone];
    option.placeholderColor = self.placeholderColor;
    option.placeholderImage = self.placeholderImage;
    option.originalContentMode = self.originalContentMode;
    option.placeholderContentMode = self.placeholderContentMode;
    option.shouldAspectRatioFit = self.shouldAspectRatioFit;
    option.activityIndicatorViewStyle = self.activityIndicatorViewStyle;
    option.shouldShowLoadingActivity = self.shouldShowLoadingActivity;
    
    return option;
}

@end

