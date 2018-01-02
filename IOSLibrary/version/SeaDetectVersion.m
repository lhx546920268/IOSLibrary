//
//  SeaDetectVersion.m
//  Sea

//

#import "SeaDetectVersion.h"
#import "NSDate+Utils.h"
#import "NSString+Utils.h"
#import "NSJSONSerialization+Utils.h"
#import "NSDictionary+Utils.h"
#import "SeaTools.h"

@implementation SeaDetectVersion

#pragma mark- public method

+ (NSURLSessionDataTask*)detectVersionWithAppId:(NSString*) appId interval:(NSTimeInterval)interval immediately:(BOOL)immediately completion:(SeaDetectVersionCompletionHandler)completion
{
    if(immediately || [self shouldDetectForInterval:interval]){
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appId]];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            
            if(!error){
                NSDictionary *dic = [NSJSONSerialization sea_dictionaryFromData:data];
                NSArray *resArray = [dic sea_arrayForKey:@"results"];
                
                if(resArray.count > 0){
                    NSDictionary *valueDic = [resArray firstObject];
                    
                    NSString *latestVersion = [valueDic sea_stringForKey:@"version"];
                    NSString *currentVersion = appVersion();
                    
                    !completion ?: completion([self shouldUpdateForCurrentVersion:currentVersion latestVersion:latestVersion] ? [valueDic sea_stringForKey:@"trackViewUrl"] : nil, currentVersion, latestVersion);
                }
            }
        }];
        [task resume];
        
        return task;
    }else{
        return nil;
    }
}

///是否已超过时间间隔
+ (BOOL)shouldDetectForInterval:(NSTimeInterval) interval
{
    NSString *time = [self lastDetectTime];
    if([NSString isEmpty:time])
        return YES;
    return [NSDate sea_TimeMinus:[NSDate sea_currentTime] time:time greaterThan:interval];
}

///最新的版本检测时间
+ (NSString*)lastDetectTime
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"com.lhx.detectVersionTime"];
}

///保存最新检测时间
+ (void)saveLastDetectTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate sea_currentTime] forKey:@"com.lhx.detectVersionTime"];
    [defaults synchronize];
}

///是否需要更新版本
+ (BOOL)shouldUpdateForCurrentVersion:(NSString*) currentVersion latestVersion:(NSString*) latestVersion
{
    if([NSString isEmpty:latestVersion])
        return NO;
    
    return [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue] < [[latestVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
}

@end
