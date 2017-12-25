//
//  SeaMovieCacheTask.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/25.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeaMovieCacheTool.h"

@class SeaMovieCacheHandler;

/**
 视频缓存任务 防止下载多次
 */
@interface SeaMovieCacheTask : NSObject

/**
 视频信息获取任务
 */
@property(nonatomic, strong) NSBlockOperation *operation;

/**
 视频加载选项
 */
@property(nonatomic, strong) NSMutableSet<SeaMovieCacheHandler*> *handlers;

/**
 通过target 获取对应 handler，没有则创建
 
 @param target 对应的target
 @return handler 实例
 */
- (SeaMovieCacheHandler*)handlerForTarget:(id) target;


@end

/**
 视频信息获取后用到的东西
 */
@interface SeaMovieCacheHandler : NSObject

/**
 加载视频信息的对象 如UIImageView
 */
@property(nonatomic, weak) id target;

/**
 缩略图大小 CGSizeZero 表示不使用缩率图
 */
@property(nonatomic, assign) CGSize thumbnailSize;

/**
 完成回调
 */
@property(nonatomic, copy) SeaMovieCacheCompletionHandler completionHandler;

@end
