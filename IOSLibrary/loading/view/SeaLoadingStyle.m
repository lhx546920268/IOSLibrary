//
//  SeaLoadingStyle.m
//  IOSLibrary
//
//  Created by luohaixiong on 2018/6/3.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaLoadingStyle.h"
#import "SeaNetworkActivityView.h"
#import "SeaFailPageView.h"
#import "SeaPageLoadingView.h"

@implementation SeaLoadingStyle

- (instancetype)init
{
    self = [super init];
    if(self){
        self.networkActivityClass = [SeaNetworkActivityView class];
        self.pageLoadingClass = [SeaPageLoadingView class];
        self.failPageClass = [SeaFailPageView class];
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    static SeaLoadingStyle *style = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        style = [SeaLoadingStyle new];
    });
    
    return style;
}

@end
