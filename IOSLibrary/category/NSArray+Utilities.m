//
//  NSArray+Subscript.m

//

#import "NSArray+Utilities.h"

@implementation NSArray (Utilities)

/**获取不越界的对象,如果越界，返回nil
 */
- (id)objectAtNotBeyondIndex:(NSUInteger) index
{
    if(index < self.count)
    {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end


@implementation NSMutableArray (Utilities)

- (void)addNotExistObject:(id)obj
{
    if(![self containsObject:obj])
    {
        [self addObject:obj];
    }
}

- (void)insertNotExistObject:(id)obj atIndex:(NSInteger)index
{
    if(![self containsObject:obj])
    {
        [self insertObject:obj atIndex:index];
    }
}

/**添加一个不为空的对象
 */
- (void)addNotNilObject:(id) obj
{
    if(obj != nil)
    {
        [self addObject:obj];
    }
}

/**判断数组中是否包含某个对象--只针对字符串
 */
- (BOOL)arraryIsContainString:(NSString *)string{
    
    BOOL isEqual = NO;
    
    for (NSString *object in self) {
        
        if ([object isEqualToString:string]) {
            
            isEqual = YES;
            
            break;
        }
        else{
            
            isEqual = NO;
        }
    }
    
    return isEqual;
}


@end

