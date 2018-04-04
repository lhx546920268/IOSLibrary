//
//  NSDictionary+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)

/**
 去空获取对象 并且如果对象是NSNumber将会转化成字符串
 */
- (NSString*)sea_stringForKey:(id<NSCopying>) key;

/**
 解码 去空获取对象 并且如果对象是NSNumber将会转化成字符串
 */
- (NSString*)sea_decodedStringForKey:(id<NSCopying>) key;

/**
 获取可转成数字的对象 NSNumber 、NSString
 */
- (id)sea_numberForKey:(id<NSCopying>) key;

/**
 获取字典
 */
- (NSDictionary*)sea_dictionaryForKey:(id<NSCopying>) key;

/**
 获取数组
 */
- (NSArray*)sea_arrayForKey:(id<NSCopying>) key;

@end

@interface NSMutableDictionary (Utils)

/**
 判断对象是否为空，才设置字典键值
 */
- (void)sea_setObject:(id) object forKey:(id<NSCopying>) key;

@end
