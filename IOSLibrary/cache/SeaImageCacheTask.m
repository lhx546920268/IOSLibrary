//
//  SeaImageCacheTask.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaImageCacheTask.h"

@implementation SeaImageCacheTask

- (instancetype)init
{
    self = [super init];
    if(self){
        self.handlers = [NSMutableSet set];
    }
    
    return self;
}

- (SeaImageCacheHandler*)handlerForTarget:(id) target
{
    SeaImageCacheHandler *handler = nil;
    for(SeaImageCacheHandler *tmp in self.handlers){
        if([tmp.target isEqual:target]){
            handler = tmp;
            break;
        }
    }
    
    if(!handler){
        handler = [SeaImageCacheHandler new];
        handler.target = target;
        [self.handlers addObject:handler];
    }
    return handler;
}

@end


@implementation SeaImageCacheHandler

@end
