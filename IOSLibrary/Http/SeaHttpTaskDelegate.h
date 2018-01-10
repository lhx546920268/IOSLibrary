//
//  SeaHttpTaskDelegate.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/21.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 http 任务代理
 */
@protocol SeaHttpTaskDelegate <NSObject>

@optional

/**
 请求任务完成
 
 @param dataTask 请求任务
 @param data 返回的数据，如果 error 不等于 SeaHttpErrorCodeNoError 则为nil
 @param error 错误码，SeaHttpErrorCodeNoError为成功
 */
- (void)URLSessionDataTask:(NSURLSessionDataTask*) dataTask didCompleteWithData:(NSData*) data error:(NSInteger) error;

/**
 下载任务完成
 
 @param downloadTask 下载任务
 @param URL 下载完成对应的文件路径 如果 error 不等于 SeaHttpErrorCodeNoError 则为nil
 @param error 错误码，SeaHttpErrorCodeNoError为成功
 */
- (void)URLSessionDownloadTask:(NSURLSessionDownloadTask*) downloadTask didCompleteWithURL:(NSURL*) URL error:(NSInteger) error;

/**
 更新上传进度
 
 @param task 对应任务
 @param progress 上传进度 使用 progress.fractionCompleted
 */
- (void)URLSessionTask:(NSURLSessionTask*) task didUpdateUploadProgress:(NSProgress*) progress;

/**
 更新下载进度
 
 @param task 对应任务
 @param progress 下载进度 使用 progress.fractionCompleted
 */
- (void)URLSessionTask:(NSURLSessionTask*) task didUpdateDownloadProgress:(NSProgress*) progress;

@end
