//
//  SeaUserDefaults.m

//

#import "SeaUserDefaults.h"

@implementation SeaUserDefaults

+ (BOOL)boolForKey:(NSString*) key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}


+ (void)setBool:(BOOL) value forKey:(NSString*) key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

+ (id)objectForKey:(NSString*) key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setObject:(id) obj forKey:(NSString*) key
{
    if(key == nil)
        return;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:obj forKey:key];
    [userDefaults synchronize];
}

+ (void)removeObjectForKey:(NSString*) key
{
    if(key == nil)
        return;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

@end
