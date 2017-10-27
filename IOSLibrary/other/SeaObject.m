//
//  SeaObject.m
//  EasyToRun
//
//  Created by 罗海雄 on 17/9/18.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaObject.h"

@implementation SeaObject

+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    SeaObject *obj = [[[self class] alloc] init];
    [obj setDictionary:dic];
    
    return obj;
}

- (void)setDictionary:(NSDictionary*) dic
{
    
}

@end
