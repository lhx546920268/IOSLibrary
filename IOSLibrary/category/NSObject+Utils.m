//
//  NSObject+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "NSObject+Utils.h"
#import <objc/runtime.h>
#import "NSString+Utils.h"

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
    [self sea_exchangeImplementations:selector1 prefix:prefix clazz:self.class];
}

+ (void)sea_exchangeImplementations:(SEL)selector1 prefix:(NSString *)prefix clazz:(Class)clazz
{
    Method method1 = class_getInstanceMethod(clazz, selector1);
    Method method2 = class_getInstanceMethod(clazz, NSSelectorFromString([NSString stringWithFormat:@"%@%@", prefix, NSStringFromSelector(selector1)]));
    
    method_exchangeImplementations(method1, method2);
}

+ (void)sea_exchangeImplementations:(SEL)selector1 selector2:(SEL)selector2
{
    [self sea_exchangeImplementations:selector1 selector2:selector2 clazz:self.class];
}

+ (void)sea_exchangeImplementations:(SEL)selector1 selector2:(SEL)selector2 clazz:(Class)clazz
{
    Method method1 = class_getInstanceMethod(clazz, selector1);
    Method method2 = class_getInstanceMethod(clazz, selector2);
    
    method_exchangeImplementations(method1, method2);
}

- (void)sea_encodeWithCoder:(NSCoder *)coder
{
    [self sea_encodeWithCoder:coder clazz:[self class]];
}

- (void)sea_encodeWithCoder:(NSCoder*) coder clazz:(Class) clazz
{
    if(clazz == [NSObject class]){
        return;
    }
    
    //获取当前类的所有属性，该方法无法获取父类或者子类的属性
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    for(int i = 0;i < count;i ++){
        
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        //类型地址 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
        NSString *attr = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        NSArray *attrs = [attr componentsSeparatedByString:@","];
        
        //判断是否是只读属性
        if(attrs.count > 0 && ![attrs containsObject:@"R"]){
            
            id value = [self valueForKey:name];
            [coder encodeObject:value forKey:name];
        }
    }
    
    //递归获取父类的属性
    [self sea_encodeWithCoder:coder clazz:[clazz superclass]];
}

- (void)sea_initWithCoder:(NSCoder *)decoder
{
    [self sea_initWithCoder:decoder clazz:[self class]];
}

- (void)sea_initWithCoder:(NSCoder*) decoder clazz:(Class) clazz
{
    if(clazz == [NSObject class]){
        return;
    }
    
    //获取当前类的所有属性，该方法无法获取父类或者子类的属性
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    for(int i = 0;i < count;i ++){
        
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        //类型地址 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
        NSString *attr = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        NSArray *attrs = [attr componentsSeparatedByString:@","];
        
        //判断是否是只读属性
        if(attrs.count > 0 && ![attrs containsObject:@"R"]){
            
            NSString *type = [attrs firstObject];
            id value = nil;
            //判断是否是对象属性
            if([type containsString:@"T@\""]){
                type = [type stringByReplacingOccurrencesOfString:@"T@\"" withString:@""];
                type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                value = [decoder decodeObjectOfClass:NSClassFromString(type) forKey:name];
                
            }else{
                value = [decoder decodeObjectForKey:name];
            }
            
            [self setValue:value forKey:name];
        }
    }
    
    //递归获取父类的属性
    [self sea_initWithCoder:decoder clazz:[clazz superclass]];
}

@end
