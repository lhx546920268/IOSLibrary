//
//  NSJSONSerialization+Utilities.h

//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Utilities)

/**便利的Json解析 避免了 data = nil时，抛出异常
 *@param data Json数据
 *@return NSDictionary
 */
+ (NSDictionary*)JSONDictionaryWithData:(NSData*) data;

/**把对象转换成Json 字符串
 *@param object 要转换成json的对象
 *@return json字符串
 */
+ (NSString*)JSONStringFromObject:(id) object;

@end
