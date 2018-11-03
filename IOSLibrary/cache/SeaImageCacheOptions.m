//
//  SeaImageCacheOptions.m
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
        self.resetImage = YES;
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    SeaImageCacheOptions *options = [SeaImageCacheOptions allocWithZone:zone];
    [options copyOptions:self];
    
    return options;
}

- (void)copyOptions:(SeaImageCacheOptions*) options
{
    self.placeholderColor = options.placeholderColor;
    self.placeholderImage = options.placeholderImage;
    self.originalContentMode = options.originalContentMode;
    self.placeholderContentMode = options.placeholderContentMode;
    self.shouldAspectRatioFit = options.shouldAspectRatioFit;
    self.activityIndicatorViewStyle = options.activityIndicatorViewStyle;
    self.shouldShowLoadingActivity = options.shouldShowLoadingActivity;
    self.resetImage = options.resetImage;
}

///单例
+ (instancetype)sharedInstance
{
    static SeaImageCacheOptions *sharedOptions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedOptions = [SeaImageCacheOptions new];
    });
    
    return sharedOptions;
}

+ (void)setDefaultOptions:(SeaImageCacheOptions *)options
{
    if(!options)
        return;
    
    [[SeaImageCacheOptions sharedInstance] copyOptions:options];
}

+ (instancetype)defaultOptions
{
    return [[SeaImageCacheOptions sharedInstance] copy];
}


@end

