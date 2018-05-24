//
//  NSJSONSerialization+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "NSJSONSerialization+Utils.h"
#import "SeaBasic.h"

@implementation NSJSONSerialization (Utils)

+ (NSDictionary*)sea_dictionaryFromData:(NSData*) data
{
    if(![data isKindOfClass:[NSData class]])
        return nil;
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error){
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"%@",error);
    }
    
    if([dic isKindOfClass:[NSDictionary class]]){
        return dic;
    }
    return nil;
}

+ (NSString*)sea_stringFromObject:(id) object
{
    NSData *data = [self sea_dataFromObject:object];
    if(data){
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
}

+ (NSData*)sea_dataFromObject:(id) object
{
    if([NSJSONSerialization isValidJSONObject:object]){
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        
        if(error){
            NSLog(@"生成json 出错%@",error);
        }else{
            return data;
        }
    }
    
    return nil;
}

@end
