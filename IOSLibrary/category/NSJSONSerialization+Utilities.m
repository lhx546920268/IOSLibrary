//
//  NSJSONSerialization+Utilities.m

//

#import "NSJSONSerialization+Utilities.h"

@implementation NSJSONSerialization (Utilities)

/**便利的Json解析
 *@param data Json数据
 *@return NSDictionary
 */
+ (NSDictionary*)JSONDictionaryWithData:(NSData*) data
{
    if(![data isKindOfClass:[NSData class]])
        return nil;
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error)
    {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"%@",error);
    }
    
    if([dic isKindOfClass:[NSDictionary class]])
    {
        return dic;
    }
    return nil;
}

/**把对象转换成Json 字符串
 *@param object 要转换成json的对象
 *@return json字符串
 */
+ (NSString*)JSONStringFromObject:(id) object
{
    if([NSJSONSerialization isValidJSONObject:object])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        
        if(error)
        {
            NSLog(@"生成json 出错%@",error);
        }
        else
        {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    
    return @"";
}


@end
