//
//  SeaURLSessionTaskDelegate.h
//  AutoLayoutDemo
//
//  Created by 罗海雄 on 2017/12/20.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeaURLSessionManager.h"

@protocol SeaHttpTaskDelegate;

@class SeaHttpTask;

/**
 网络请求 代理
 */
@interface SeaURLSessionTaskDelegate : NSObject<NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

/**
 完成回调
 */
@property(nonatomic, copy) SeaURLSessionCompletionHandler completionHandler;

/**
 下载完成回调
 */
@property(nonatomic, copy) SeaURLSessionDownloadHandler downloadHandler;

/**
 上传进度回调
 */
@property(nonatomic, copy) SeaURLSessionUploadProgressHandler uploadProgressHandler;

/**
 下载进度回调
 */
@property(nonatomic, copy) SeaURLSessionDownloadProgressHandler downloadProgressHandler;

/**
 是否显示上传进度 default is 'NO'
 */
@property(nonatomic, assign) BOOL showUploadProgress;

/**
 是否显示下载进度 default is 'NO'
 */
@property(nonatomic, assign) BOOL showDownloadProgress;

/**
 http 任务
 */
@property(nonatomic, strong) SeaHttpTask *httpTask;

/**
 构造方法

 @param task 请求任务
 @return 一个实例
 */
- (instancetype)initWithDataTask:(NSURLSessionDataTask*) task;

/**
 构造方法

 @param task 下载任务
 @param destinationPath 下载完成后文件会移动到这里
 @return 一个实例
 */
- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask*) task destinationPath:(NSString*) destinationPath;

/**
 添加代理

 @param delegate 对应的代理
 */
- (void)addDelegate:(id<SeaHttpTaskDelegate>) delegate;

@end
