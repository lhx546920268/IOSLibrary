//
//  SeaDetectVersion.h
//  Sea

//

#import <Foundation/Foundation.h>

/**版本检测
 */
@interface SeaDetectVersion : NSObject

/**版本检测完成后的操作 trackViewURL 新版本的更新路径 localVersion 当前版本 newestVersion 最新版本
 */
@property(nonatomic,copy) void(^completionHandler)(NSString *trackViewURL, NSString *localVersion, NSString *newestVersion);

/**检测版本 如果上一次检测距离现在没有超过 版本检测的时间间隔
 *@param immediate 是否马上检测是否有新版本
 *@return 是否进行版本检测
 */
- (BOOL)detectVersionImmediately:(BOOL) immediate;

/**取消检测
 */
- (void)cancel;

@end
