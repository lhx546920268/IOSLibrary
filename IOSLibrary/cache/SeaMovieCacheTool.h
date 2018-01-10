//
//  SeaMovieCacheTool.h
//
//  Created by 罗海雄 on 16/4/25.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaMovieCacheInfo;

/**
 获取视频数据完成回调

 @param cacheInfo 视频缓存信息
 */
typedef void(^SeaMovieCacheCompletionHandler)(SeaMovieCacheInfo *cacheInfo);

/**
 视频缓存信息
 */
@interface SeaMovieCacheInfo : NSObject<NSCopying>

/**
 视频时长
 */
@property(nonatomic, readonly) long long duration;

/**
 格式化视频时长
 */
@property(nonatomic, readonly) NSString *formatDuration;

/**
 视频第一帧图片
 */
@property(nonatomic, readonly) UIImage *firstImage;


/**
 构造方法

 @param duration 视频时长
 @param image 视频第一帧图片
 @return 一个实例
 */
- (instancetype)initWithDuration:(long long) duration image:(UIImage*) image;

@end

/**
 视频缓存数据库
 */
@interface SeaMovieDurationDataBase : NSObject

/**
 单例
 */
+ (instancetype)sharedInstance;

/**
 插入一条数据
 
 @param duration 视频时长
 @param URL 视频链接
 @return 是否成功
 */
- (BOOL)insertDuration:(long long) duration URL:(NSString*) URL;

/**
 删除小于或等于对应时间的视频数据
 
 @param date 要小于等于的时间
 @return 是否成功
 */
- (BOOL)deleteCachesEarlierOrEqualDate:(NSDate*) date;

/**
 获取对应视频链接的时长
 
 @param URL 视频链接
 @return 视频时长
 */
- (long long)durationForURL:(NSString*) URL;

/**
 清空
 */
- (void)clear;


@end

/**
 加载并缓存视频第一帧图片，视频时间长度
 */
@interface SeaMovieCacheTool : NSObject

/**缓存单例
 */
+ (instancetype)sharedInstance;

/**相关下载是否正在进行中
 *@param URL 视频链接
 */
- (BOOL)isDownloadingForURL:(NSString*) URL;

/**取消某个下载任务
 *@param URL 视频链接
 *@param target 获取视频信息的对象，如UIImageView
 */
- (void)cancelDownloadForURL:(NSString*) URL target:(id) target;

/**
 添加下载完成回调

 @param completion 完成回调
 @param size 第一帧图片缩率图大小
 @param target 获取视频信息的对象，如UIImageView
 @param URL 视频链接
 */
- (void)addCompletion:(SeaMovieCacheCompletionHandler) completion thumbnailSize:(CGSize) size target:(id) target forURL:(NSString*) URL;

/**
 获取视频信息 现在本地查询是否存在，没有则下载获取

 @param URL 视频链接
 @param size 第一帧图片缩率图大小
 @param completion 完成回调
 @param target 获取视频信息的对象，如UIImageView
 */
- (void)movieInfoForURL:(NSString*) URL thumbnailSize:(CGSize) size completion:(SeaMovieCacheCompletionHandler) completion target:(id) target;

/**
 从内存中获取视频信息

 @param URL 视频链接
 @param size 第一帧图片缩率图大小
 @return 视频信息
 */
- (SeaMovieCacheInfo*)movieInfoFromMemoryForURL:(NSString*) URL thumbnailSize:(CGSize) size;

#pragma mark- format

/**格式化视频时长
 *@param duration 视频时间长度
 *@return 类似 01:30:30 的视频时长
 */
+ (NSString*)format:(long long) duration;


@end
