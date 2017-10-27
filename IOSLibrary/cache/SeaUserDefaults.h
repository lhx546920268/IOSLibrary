//
//  SeaUserDefaults.h

//

#import <Foundation/Foundation.h>

/**快速的使用 NSUserDefaults
 */
@interface SeaUserDefaults : NSObject


+ (BOOL)boolForKey:(NSString*) key;
+ (void)setBool:(BOOL) value forKey:(NSString*) key;

+ (id)objectForKey:(NSString*) key;
+ (void)setObject:(id) obj forKey:(NSString*) key;

+ (void)removeObjectForKey:(NSString*) key;

@end
