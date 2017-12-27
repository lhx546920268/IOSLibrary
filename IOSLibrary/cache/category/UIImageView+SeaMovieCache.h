//
//  UIImageView+SeaMovieCache.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/25.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaMovieCacheTool.h"
#import "SeaImageCacheOptions.h"

/**
 视频缓存类目
 */
@interface UIImageView (SeaMovieCache)

/**
 视频链接
 */
@property(nonatomic,readonly) NSString *sea_movieURL;


/**
 设置视频链接 该方法只会设置imageView 的 image

 @param URL 视频链接
 */
- (void)sea_setMovieWithURL:(NSString*) URL;

/**
 设置视频链接，可获取视频的信息
 
 *@param URL 视频链接
 *@param completion 完成回调
 */
- (void)sea_setMovieWithURL:(NSString*) URL completion:(SeaMovieCacheCompletionHandler) completion;

/**
 设置视频链接，可获取视频的信息
 
 *@param URL 视频链接
 *@param options 下载选项
 *@param completion 完成回调
 */
- (void)sea_setMovieWithURL:(NSString*) URL options:(SeaImageCacheOptions*) options completion:(SeaMovieCacheCompletionHandler) completion;

@end
