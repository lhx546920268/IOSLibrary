//
//  SeaURLSessionManager.h
//  AutoLayoutDemo
//
//  Created by 罗海雄 on 2017/12/20.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeaHttpTask;
@protocol SeaHttpTaskDelegate;

///请求完成回调 error = SeaHttpErrorCodeNoError 成功
typedef void(^SeaURLSessionCompletionHandler)(NSURLSessionDataTask *task, NSData *data, NSInteger error);

///下载完成回调 error = SeaHttpErrorCodeNoError 成功 如果设置了下载路径 URL为对应路径，否则为一个临时文件，回调后会被删除
typedef void(^SeaURLSessionDownloadHandler)(NSURLSessionDownloadTask *task, NSURL *URL, NSInteger error);

///上传进度回调
typedef void(^SeaURLSessionUploadProgressHandler)(NSProgress *progress);

///下载进度回调
typedef void(^SeaURLSessionDownloadProgressHandler)(NSProgress *progress);


/**
 NSURLSession 管理器
 */
@interface SeaURLSessionManager : NSObject


/**
 通过配置创建一个 实例

 @param configuration 配置
 @return 实例
 */
- (instancetype)initWithConfiguration:(NSURLSessionConfiguration*) configuration;

/**
 单例
 */
+ (instancetype)shareInstance;

/**
 创建一个请求任务
 
 @param task http请求任务
 @param completion 完成回调 取消没回调
 @return 一个 NSURLSessionDataTask 实例
 */
- (NSURLSessionDataTask*)dataTaskWithTask:(SeaHttpTask*) task completion:(SeaURLSessionCompletionHandler) completion;

/**
 创建一个请求任务
 
 @param request 一个请求 可通过 SeaHttpTask 或者 SeaHttpBuilder 构建
 @param completion 完成回调 取消没回调
 @return 一个 NSURLSessionDataTask 实例
 */
- (NSURLSessionDataTask*)dataTaskWithRequest:(NSURLRequest*) request completion:(SeaURLSessionCompletionHandler) completion;

/**
 创建一个下载任务

 @param URL 下载路径
 @param DestinationPath 下载完成后文件会移动到这个地方
 @param completion 下载完成回调
 @return 一个 NSURLSessionDownloadTask 实例
 */
- (NSURLSessionDownloadTask*)downloadTaskWithURL:(NSString*) URL destinationPath:(NSString*) DestinationPath completion:(SeaURLSessionDownloadHandler) completion;

/**
 添加上传进度

 @param uploadProgress 上传进度回调
 @param task 对应任务
 */
- (void)addUploadProgress:(SeaURLSessionUploadProgressHandler) uploadProgress forTask:(NSURLSessionTask*) task;

/**
 设置显示上传进度条
 
 @param show 是否显示
 @param task 对应任务
 */
- (void)setShowUploadProgress:(BOOL) show forTask:(NSURLSessionTask*) task;

/**
 添加下载进度
 
 @param downloadProgress 下载进度回调
 @param task 对应任务
 */
- (void)addDownloadProgress:(SeaURLSessionDownloadProgressHandler) downloadProgress forTask:(NSURLSessionTask*) task;

/**
 设置显示下载进度条
 
 @param show 是否显示
 @param task 对应任务
 */
- (void)setShowDownloadProgress:(BOOL) show forTask:(NSURLSessionTask*) task;

/**
 添加代理

 @param delegate 代理
 @param task 对应任务
 */
- (void)addDelegate:(id<SeaHttpTaskDelegate>) delegate forTask:(NSURLSessionTask*) task;

@end
