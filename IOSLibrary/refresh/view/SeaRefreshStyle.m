//
//  SeaRefreshStyle.m
//  IOSLibrary
//
//  Created by luohaixiong on 2018/7/20.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaRefreshStyle.h"
#import "SeaDefaultRefreshControl.h"
#import "SeaDefaultLoadMoreControl.h"

@implementation SeaRefreshStyle

- (instancetype)init
{
    self = [super init];
    if(self){
        self.refreshClass = [SeaDefaultRefreshControl class];
        self.loadMoreClass = [SeaDefaultLoadMoreControl class];
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    static SeaRefreshStyle *style = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        style = [SeaRefreshStyle new];
    });
    
    return style;
}

@end
