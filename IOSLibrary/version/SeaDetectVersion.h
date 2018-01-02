//
//  SeaDetectVersion.h
//  Sea

//

#import <Foundation/Foundation.h>

/**
 版本检测完成后的操作

 @param downloadURL 新版本的更新路径
 @param currentVersion 当前版本
 @param latestVersion 最新版本
 */
typedef void(^SeaDetectVersionCompletionHandler)(NSString *downloadURL, NSString *currentVersion, NSString *latestVersion);

/**版本检测
 */
@interface SeaDetectVersion : NSObject

/**
 检测版本 如果上一次检测距离现在没有超过 版本检测的时间间隔
 
 *@param appId 可以登录 iTunes connect 查看 appId
 *@param interval 检测间隔 秒
 *@param immediately 是否马上检测是否有新版本 YES时将忽略 interval
 *@param completion 完成回调
 *@return 如果进行版本检测 返回对应的下载任务，否则 nil
 */
+ (NSURLSessionDataTask*)detectVersionWithAppId:(NSString*) appId interval:(NSTimeInterval) interval immediately:(BOOL) immediately completion:(SeaDetectVersionCompletionHandler) completion;

@end
