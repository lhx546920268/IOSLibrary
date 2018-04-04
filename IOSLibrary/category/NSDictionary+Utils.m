//
//  NSDictionary+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "NSDictionary+Utils.h"
#import "NSString+Utils.h"

@implementation NSDictionary (Utils)


- (NSString*)sea_stringForKey:(id<NSCopying>) key
{
    id value = [self objectForKey:key];
    
    if([value isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@", value];
    }
    
    if([value isKindOfClass:[NSString class]]){
        return value;
    }else{
        return nil;
    }
}

- (NSString*)sea_decodedStringForKey:(id<NSCopying>) key
{
    return [[self sea_stringForKey:key] sea_decodeWithUTF8];
}

- (id)sea_numberForKey:(id<NSCopying>) key
{
    id value = [self objectForKey:key];
    
    if([value isKindOfClass:[NSNumber class]]){
        return value;
    }else if([value isKindOfClass:[NSString class]]){
        return value;
    }
    return nil;
}

- (NSDictionary*)sea_dictionaryForKey:(id<NSCopying>) key
{
    NSDictionary *dic = [self objectForKey:key];
    if([dic isKindOfClass:[NSDictionary class]]){
        return dic;
    }
    return nil;
}

- (NSArray*)sea_arrayForKey:(id<NSCopying>) key
{
    NSArray *array = [self objectForKey:key];
    if([array isKindOfClass:[NSArray class]]){
        return array;
    }
    return nil;
}

@end

@implementation NSMutableDictionary (Utils)

- (void)sea_setObject:(id)object forKey:(id<NSCopying>)key
{
    if(object != nil && ![object isEqual:[NSNull null]] && object != NULL){
        [self setObject:object forKey:key];
    }
}

@end
