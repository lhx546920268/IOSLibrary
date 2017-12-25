//
//  SeaMovieCacheTask.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/25.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaMovieCacheTask.h"

@implementation SeaMovieCacheTask

- (instancetype)init
{
    self = [super init];
    if(self){
        self.handlers = [NSMutableSet set];
    }
    
    return self;
}

- (SeaMovieCacheHandler*)handlerForTarget:(id) target
{
    SeaMovieCacheHandler *handler = nil;
    for(SeaMovieCacheHandler *tmp in self.handlers){
        if([tmp.target isEqual:target]){
            handler = tmp;
            break;
        }
    }
    
    if(!handler){
        handler = [SeaMovieCacheHandler new];
        handler.target = target;
        [self.handlers addObject:handler];
    }
    return handler;
}

@end

@implementation SeaMovieCacheHandler

@end
