//
//  UIImageView+SeaImageCache.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaImageCacheOptions.h"
#import "SeaImageCacheTool.h"

/**
 加载图片类目
 */
@interface UIImageView (SeaImageCache)

/**正在加载和显示的图片 URL
 */
@property(nonatomic,readonly) NSString *sea_imageURL;

/**设置图片路径
 *@param URL 图片路径
 */
- (void)sea_setImageWithURL:(NSString*) URL;

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheCompletionHandler) completion;

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheCompletionHandler) completion progress:(SeaImageCacheProgressHandler) progress;

/**设置图片路径
 *@param URL 图片路径
 *@param options 下载选项
 */
- (void)sea_setImageWithURL:(NSString*) URL options:(SeaImageCacheOptions*) options;

/**设置图片路径
 *@param URL 图片路径
 *@param options 下载选项
 *@param completion 加载完成回调
 */
- (void)sea_setImageWithURL:(NSString*) URL options:(SeaImageCacheOptions*) options completion:(SeaImageCacheCompletionHandler) completion;

/**设置图片路径
 *@param URL 图片路径
 *@param options 下载选项
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL options:(SeaImageCacheOptions*) options completion:(SeaImageCacheCompletionHandler) completion progress:(SeaImageCacheProgressHandler) progress;

@end
