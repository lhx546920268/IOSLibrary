//
//  NSObject+utilities.m
//  EasyToRun
//
//  Created by 罗海雄 on 17/9/18.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "NSObject+utilities.h"
#import <objc/runtime.h>

@implementation NSObject (utilities)

///获取当前类的所有属性名称
- (NSArray*)sea_propertyNames
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertyNames = [NSMutableArray arrayWithCapacity:count];
    
    for(int i = 0;i < count;i ++)
    {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [propertyNames addObject:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
    }
    
    return propertyNames;
}

@end
