//
//  UIView+SeaImageCache.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/3/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaImageCacheOptions.h"
#import "SeaImageCacheTool.h"

/**
 加载图片类目
 */
@interface UIView (SeaImageCache)

/**正在加载和显示的图片 URL
 */
@property(nonatomic,readonly) NSString *sea_imageURL;

/**
 取消当前下载
 */
- (void)sea_cancelDownloadImage;

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

/**
 图片加载完成 子类重写

 @param image 加载的图片，nil为加载失败
 */
- (void)sea_imageDidLoad:(UIImage*) image;

/**
 设置加载中 子类重写

 @param loading 加载中
 @param options 加载选项
 */
- (void)sea_setLoading:(BOOL) loading options:(SeaImageCacheOptions*) options NS_REQUIRES_SUPER;

@end
