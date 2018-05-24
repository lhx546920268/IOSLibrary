//
//  NSJSONSerialization+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Utils)

/**
 
 便利的Json解析 避免了 data = nil时，抛出异常
 
 *@param data Json数据
 *@return NSDictionary
 */
+ (NSDictionary*)sea_dictionaryFromData:(NSData*) data;

/**
 把Json 对象转换成 json字符串
 *@param object 要转换成json的对象
 *@return json字符串
 */
+ (NSString*)sea_stringFromObject:(id) object;

/**
 把 json 对象转换成 json二进制
 *@param object 要转换成json的对象
 *@return json字符串
 */
+ (NSData*)sea_dataFromObject:(id) object;

@end
