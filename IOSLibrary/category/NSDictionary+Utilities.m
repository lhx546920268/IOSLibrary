//
//  NSDictionary+customDic.m

//

#import "NSDictionary+Utilities.h"

@implementation NSDictionary (Utilities)

/**去空获取对象 并且如果对象是NSNumber将会以NSInteger转化成字符串
 */
- (NSString*)sea_stringForKey:(id<NSCopying>) key
{
    id value = [self objectForKey:key];
    
    if([value isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@", value];
    }
    
    if([value isKindOfClass:[NSString class]])
    {
        return value;
    }
    else
    {
        return nil;
    }
}

/**获取可转成数字的对象 NSNumber 、NSString
 */
- (id)numberForKey:(id<NSCopying>) key
{
    id value = [self objectForKey:key];

    if([value isKindOfClass:[NSNumber class]])
    {
        return value;
    }
    else if([value isKindOfClass:[NSString class]])
    {
        return value;
    }
    return nil;
}

/**获取字典
 */
- (NSDictionary*)dictionaryForKey:(id<NSCopying>) key
{
    NSDictionary *dic = [self objectForKey:key];
    if([dic isKindOfClass:[NSDictionary class]])
    {
        return dic;
    }
    return nil;
}

/**获取数组
 */
- (NSArray*)arrayForKey:(id<NSCopying>) key
{
    NSArray *array = [self objectForKey:key];
    if([array isKindOfClass:[NSArray class]])
    {
        return array;
    }
    return nil;
}

@end

@implementation NSMutableDictionary (Utilities)

/**判断对象是否为空，才设置字典键值
 */
- (void)setObject:(id)object withKey:(id<NSCopying>)key
{
    if(object != nil && ![object isEqual:[NSNull null]] && object != NULL)
    {
        [self setObject:object forKey:key];
    }
}

@end

