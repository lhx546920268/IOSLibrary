//
//  NSMutableArray+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/26.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (Utils)

/**
 objectAtIndex 如果index 越界，返回nil
 
 @param index 下标
 @return 对应 object
 */
- (ObjectType)sea_objectAtIndex:(NSUInteger) index;

@end

@interface NSMutableArray<ObjectType> (Utils)

/**
 添加前会判断数组中是否已存在

 @param obj 要加入的对象
 @return 是否加入成功 不成功则表示已存在
 */
- (BOOL)sea_addNotExistObject:(ObjectType) obj;

/**
 添加前会判断数组中是否已存在

 @param obj 要加入的对象
 @param index 插入的位置
 @return 是否加入成功 不成功则表示已存在
 */
- (BOOL)sea_insertNotExistObject:(ObjectType) obj atIndex:(NSInteger) index;

/**
 添加不为空的对象

 @param obj 要加入的对象
 */
- (void)sea_addNotNilObject:(ObjectType) obj;

/**
 判断数组中是否存在某个字符串

 @param string 要判断的字符串
 @return 是否存在
 */
- (BOOL)sea_containString:(NSString *)string;

@end
