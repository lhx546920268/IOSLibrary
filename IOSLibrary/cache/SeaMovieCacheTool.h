//
//  SeaMovieCacheTool.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeaMovieCacheToolOperation.h"

///视频缓存工具
@interface SeaMovieCacheTool : NSObject

/**缓存单例
 */
+ (instancetype)sharedInstance;

/**保存在内存中的时间 key 是视频路径，value 是NSString对象
 */
+ (NSCache*)defaultCache;

/**判断某个请求是否已存在
 *@param URL 视频路径
 *@return 是否已存在
 */
- (BOOL)isRequestingWithURL:(NSString*) URL;

/**取消某个请求
 *@param URL 视频路径
 *@param target 获取视频信息的对象，如UIImageView
 */
- (void)cancelRequestWithURL:(NSString*) URL target:(id) target;

/**添加下载完成回调
 *@param requirement 要求
 *@param URL 视频路径
 */
- (void)addRequirement:(SeaMovieCacheToolRequirement*) requirement forURL:(NSString*) URL;

/**获取视频信息
 *@param URL 视频路径
 *@param requirement 要求
 */
- (void)getMovieWithURL:(NSString*) URL requirement:(SeaMovieCacheToolRequirement*) requirement;

#pragma mark- format

/**格式化视频时间
 *@param timeInterval 视频时间长度
 *@return 类似 01:30:30 的视频时长
 */
+ (NSString*)formatMovieTime:(NSTimeInterval) timeInterval;

#pragma mark- clear

/**清除视频缓存
 *@param completion 清除完成回调
 */
- (void)clearMovieCacheWithCompletion:(void(^)(void)) completion;

@end
