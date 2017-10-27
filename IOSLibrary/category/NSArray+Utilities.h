//
//  NSArray+Subscript.h

//

#import <Foundation/Foundation.h>

@interface NSArray (Utilities)

/**获取不越界的对象,如果越界，返回nil
 */
- (id)objectAtNotBeyondIndex:(NSUInteger) index;

@end

@interface NSMutableArray (Utilities)

/**添加一个数组中不存在的对象
 */
- (void)addNotExistObject:(id) obj;

/**插入一个数组中不存在的对象
 */
- (void)insertNotExistObject:(id) obj atIndex:(NSInteger) index;

/**添加一个不为空的对象
 */
- (void)addNotNilObject:(id) obj;

/**判断数组中是否包含某个对象--只针对字符串
 */
- (BOOL)arraryIsContainString:(NSString *)string;
@end
