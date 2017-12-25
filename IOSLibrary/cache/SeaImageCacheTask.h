//
//  SeaImageCacheTask.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeaImageCacheTool.h"

@class SeaImageCacheHandler;

/**
 图片缓存任务 防止下载多次
 */
@interface SeaImageCacheTask : NSObject

/**
 图片下载任务
 */
@property(nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

/**
 图片加载选项
 */
@property(nonatomic, strong) NSMutableSet<SeaImageCacheHandler*> *handlers;

/**
 通过target 获取对应 handler，没有则创建

 @param target 对应的target
 @return handler 实例
 */
- (SeaImageCacheHandler*)handlerForTarget:(id) target;

@end

/**
 图片下载用到的东西
 */
@interface SeaImageCacheHandler : NSObject

/**
 加载图片的对象 如UIImageView
 */
@property(nonatomic, weak) id target;

/**
 缩略图大小 CGSizeZero 表示不使用缩率图
 */
@property(nonatomic, assign) CGSize thumbnailSize;

/**
 下载完成回调
 */
@property(nonatomic, copy) SeaImageCacheCompletionHandler completionHandler;

/**
 下载进度回调
 */
@property(nonatomic, copy) SeaImageCacheProgressHandler progressHandler;

@end
