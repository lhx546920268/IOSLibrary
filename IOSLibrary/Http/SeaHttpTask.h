//
//  SeaHttpTask.h
//  AutoLayoutDemo
//
//  Created by 罗海雄 on 2017/12/20.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

///POST 请求
static NSString * _Nullable const SeaHttpMethodPOST = @"POST";

///GET
static NSString * _Nullable const SeaHttpMethodGET = @"GET";

///http请求失败错误码
typedef NS_ENUM(NSInteger, SeaHttpErrorCode)
{
    ///没有错误
    SeaHttpErrorCodeNoError = 0,
    
    ///api错误
    SeaHttpErrorCodeApiError = 1,
};

@class SeaURLSessionManager;

/**
 单个http请求任务 子类可重写对应的方法
 不需要添加一个属性来保持 strong ，任务开始后会添加到一个全局 队列中
 */
@interface SeaHttpTask : NSObject

/**请求失败错误码，成功 SeaHttpErrorCodeNoError 可能有 SeaHttpErrorCodeApiError
 */
@property(nonatomic, assign) NSInteger errorCode;

/**
 获取 SeaURLSessionManager, 默认为 [SeaURLSessionManager shareInstance]
 */
@property(nonnull, nonatomic, readonly) SeaURLSessionManager *URLSessionManager;

/**
 是否正在执行
 */
@property(nonatomic, readonly) BOOL isExecuting;

/**
 是否暂停
 */
@property(nonatomic, readonly) BOOL isSuspended;

/**
 获取请求
 */
@property(nonnull, nonatomic, readonly) NSURLRequest *request;

/**成功回调
 */
@property(nonatomic, copy) void(^ _Nullable successHandler)(__kindof SeaHttpTask * _Nonnull task);

/**失败回调
 */
@property(nonatomic, copy) void(^ _Nullable failHandler)(__kindof SeaHttpTask * _Nonnull task);

/**
 上传进度
 */
@property(nonatomic, copy) void(^ _Nullable uploadProgressHandler)(__kindof NSProgress * _Nonnull progress);

/**
 下载进度
 */
@property(nonatomic, copy) void(^ _Nullable downloadProgressHandler)(__kindof NSProgress * _Nonnull progress);

/**请求URL
 */
- (nonnull NSString*)requestURL;

/**获取参数
 */
- (nullable NSMutableDictionary*)params;

/**获取文件
 */
- (nullable NSMutableDictionary*)files;

/**处理参数 比如签名
 */
- (void)processParams:(nullable NSMutableDictionary*) params files:(nullable NSMutableDictionary*)files;

/**请求标识 默认返回类的名称
 */
@property(nonnull, nonatomic, copy) NSString *name;

/**
 默认自动识别
 */
@property(nonnull, nonatomic, copy) NSString *httpMethod;

/**请求是否成功
 *@return 是否成功
 */
- (BOOL)resultFromData:(nullable NSData*) data;

/**
 获取对应任务
 */
- (nonnull NSURLSessionDataTask*)getURLSessionTask;

#pragma mark- 回调

///请求开始
- (void)onStart NS_REQUIRES_SUPER;

///请求成功
- (void)onSuccess NS_REQUIRES_SUPER;

///请求失败
- (void)onFail NS_REQUIRES_SUPER;

///上传进度
- (void)onUploadProgressUpdate:(nonnull NSProgress*) progress NS_REQUIRES_SUPER;

///下载进度回调
- (void)onDownloadProgressUpdate:(nonnull NSProgress*) progress NS_REQUIRES_SUPER;

///请求完成
- (void)onComplete NS_REQUIRES_SUPER;

///开始请求
- (void)start NS_REQUIRES_SUPER;

///取消
- (void)cancel NS_REQUIRES_SUPER;

@end
