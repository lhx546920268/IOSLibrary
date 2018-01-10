//
//  SeaWeakObjectContainer.m
//  IOSLibrary
//
//  Created by 罗海雄 on 16/7/14.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import "SeaWeakObjectContainer.h"

@implementation SeaWeakObjectContainer

+ (instancetype)containerWithObject:(id) object
{
    SeaWeakObjectContainer *container = [[SeaWeakObjectContainer alloc] init];
    container.weakObject = object;
    
    return container;
}

@end
