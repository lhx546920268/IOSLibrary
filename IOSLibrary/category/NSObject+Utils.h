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

@end
