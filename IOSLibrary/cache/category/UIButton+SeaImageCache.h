//
//  UIButton+SeaImageCache.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaImageCacheOptions.h"
#import "SeaImageCacheTool.h"

@interface UIButton (SeaImageCache)

/**
 当前state 的图片路径
 */
@property(nonatomic,readonly) NSString *sea_imageURL;

/**
 当前state 的背景图片路径
 */
@property(nonatomic,readonly) NSString *sea_backgroundImageURL;

/**
 获取对应状态的图片路径
 */
- (NSString*)sea_imageURLForState:(UIControlState) state;

/**
 设置图片路径
 
 *@param URL 图片路径
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheCompletionHandler) completion;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state progress:(SeaImageCacheProgressHandler) progress;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheCompletionHandler) completion progress:(SeaImageCacheProgressHandler) progress;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param options 下载选项
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state options:(SeaImageCacheOptions*) options;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param options 下载选项
 *@param completion 加载完成回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state options:(SeaImageCacheOptions*) options completion:(SeaImageCacheCompletionHandler) completion;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param options 下载选项
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state options:(SeaImageCacheOptions*) options progress:(SeaImageCacheProgressHandler) progress;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param options 下载选项
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state options:(SeaImageCacheOptions*) options completion:(SeaImageCacheCompletionHandler) completion progress:(SeaImageCacheProgressHandler) progress;


/**
 获取对应状态的背景图片路径
 */
- (NSString*)sea_backgroundImageURLForState:(UIControlState) state;

/**
 设置图片路径
 
 *@param URL 图片路径
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state ;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheCompletionHandler) completion;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param progress 加载进度回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state progress:(SeaImageCacheProgressHandler) progress;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheCompletionHandler) completion progress:(SeaImageCacheProgressHandler) progress;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param options 下载选项
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state options:(SeaImageCacheOptions*) options;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param options 下载选项
 *@param completion 加载完成回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state options:(SeaImageCacheOptions*) options completion:(SeaImageCacheCompletionHandler) completion;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param options 下载选项
 *@param progress 加载进度回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state options:(SeaImageCacheOptions*) options progress:(SeaImageCacheProgressHandler) progress;

/**
 设置图片路径
 
 *@param URL 图片路径
 *@param options 下载选项
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state options:(SeaImageCacheOptions*) options completion:(SeaImageCacheCompletionHandler) completion progress:(SeaImageCacheProgressHandler) progress;

@end
