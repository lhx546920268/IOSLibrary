//
//  NSObject+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utils)

/**
 获取当前类的所有属性名称
 */
- (NSArray<NSString*>*)sea_propertyNames;

/**
 获取 class name
 */
+ (NSString*)sea_nameOfClass;
- (NSString*)sea_nameOfClass;


/**
 交换实例方法实现

 @param selector1 方法1
 @param prefix 前缀，方法2 = 前缀 + 方法1名字
 */
+ (void)sea_exchangeImplementations:(SEL) selector1 prefix:(NSString*) prefix;


/**
 交换实例方法实现

 @param selector1 方法1
 @param selector2 方法2
 */
+ (void)sea_exchangeImplementations:(SEL) selector1 selector2:(SEL) selector2;


@end
