//
//  NSObject+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "NSObject+Utils.h"
#import <objc/runtime.h>

@implementation NSObject (Utils)

- (NSArray<NSString*>*)sea_propertyNames
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertyNames = [NSMutableArray arrayWithCapacity:count];
    
    for(int i = 0;i < count;i ++){
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [propertyNames addObject:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
    }
    
    return propertyNames;
}

- (NSString*)sea_nameOfClass
{
    return NSStringFromClass(self.class);
}

+ (NSString*)sea_nameOfClass
{
    return NSStringFromClass(self.class);
}


+ (void)sea_exchangeImplementations:(SEL)selector1 prefix:(NSString *)prefix
{
    Method method1 = class_getInstanceMethod(self.class, selector1);
    Method method2 = class_getInstanceMethod(self.class, NSSelectorFromString([NSString stringWithFormat:@"%@%@", prefix, NSStringFromSelector(selector1)]));
    
    method_exchangeImplementations(method1, method2);
}

+ (void)sea_exchangeImplementations:(SEL)selector1 selector2:(SEL)selector2
{
    Method method1 = class_getInstanceMethod(self.class, selector1);
    Method method2 = class_getInstanceMethod(self.class, selector2);
    
    method_exchangeImplementations(method1, method2);
}

@end
