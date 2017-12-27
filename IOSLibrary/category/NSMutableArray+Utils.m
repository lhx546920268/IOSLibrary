//
//  NSMutableArray+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/26.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "NSMutableArray+Utils.h"

@implementation NSArray (Utils)

- (id)sea_objectAtIndex:(NSUInteger) index
{
    if(index < self.count){
        return [self objectAtIndex:index];
    }
    return nil;
}

@end

@implementation NSMutableArray (Utils)

- (BOOL)sea_addNotExistObject:(id)obj
{
    if(![self containsObject:obj]){
        [self addObject:obj];
        return YES;
    }
    
    return NO;
}

- (BOOL)sea_insertNotExistObject:(id)obj atIndex:(NSInteger)index
{
    if(![self containsObject:obj]){
        [self insertObject:obj atIndex:index];
        return YES;
    }
    return NO;
}


- (void)sea_addNotNilObject:(id) obj
{
    if(obj != nil){
        [self addObject:obj];
    }
}

- (BOOL)sea_containString:(NSString *)string
{
    BOOL isEqual = NO;
    
    for (NSString *str in self) {
        
        if ([str isEqualToString:string]) {
            isEqual = YES;
            break;
        }
    }
    
    return isEqual;
}


@end
