//
//  NSDictionary+customDic.h

//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utilities)

/**去空获取对象 并且如果对象是NSNumber将会以NSInteger转化成字符串
 */
- (NSString*)sea_stringForKey:(id<NSCopying>) key;

/**获取可转成数字的对象 NSNumber 、NSString
 */
- (id)numberForKey:(id<NSCopying>) key;

/**获取字典
 */
- (NSDictionary*)dictionaryForKey:(id<NSCopying>) key;

/**获取数组
 */
- (NSArray*)arrayForKey:(id<NSCopying>) key;

@end


@interface NSMutableDictionary (Utilities)

/**判断对象是否为空，才设置字典键值
 */
- (void)setObject:(id) object withKey:(id<NSCopying>) key;

@end



