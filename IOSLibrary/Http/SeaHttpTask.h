//
//  SeaHttpTask.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/20.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeaHttpBuilder.h"

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

/**
 请求超时 由于NSURLSession创建后 不能修改超时时间，只能自己模拟一个请求超时用于某些特殊场景
 default is '0' 不使用这个字段
 */
@property(nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 请求失败错误码，成功 SeaHttpErrorCodeNoError 可能有 SeaHttpErrorCodeApiError
 */
@property(nonatomic, readonly) NSInteger errorCode;

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

/*
 是否是自己取消
 */
@property(nonatomic, readonly) BOOL isCanceled;

/**
 获取请求
 */
@property(nonnull, nonatomic, readonly) NSURLRequest *request;

/**
 成功回调
 */
@property(nonatomic, copy) void(^ _Nullable successHandler)(__kindof SeaHttpTask * _Nonnull task);

/**
 失败回调
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

/**
 请求URL
 */
- (nonnull NSString*)requestURL;

/**
 获取参数
 */
- (nullable NSMutableDictionary*)params;

/**
 获取文件
 */
- (nullable NSMutableDictionary*)files;

/**获取二外的cookie
 NSDictionary *dic = @{
 NSHTTPCookieName : @"JSESSIONID",
 NSHTTPCookieValue : @"5f9b51e3-8444-4ff2-a346-9e668c30c60d",
 NSHTTPCookieDomain : @"simu.dtb.cn",
 NSHTTPCookiePath : @"/"
 };
 
 NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
 */
- (nullable NSArray<NSHTTPCookie*>*)cookies;

/**
 获取额外的请求头
 */
- (nullable NSDictionary<NSString*, NSString*>*)headers;

/**
 处理参数 比如签名
 */
- (void)processParams:(nullable NSMutableDictionary*) params files:(nullable NSMutableDictionary*)files;

/**
 请求标识 默认返回类的名称
 */
@property(nonnull, nonatomic, copy) NSString *name;

/**
 默认自动识别
 */
@property(nonnull, nonatomic, copy) NSString *httpMethod;

/**
 post请求 postBody 格式
 */
@property(nonatomic, assign) SeaPostFormat postFormat;

/**
 请求是否成功
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

///请求成功 在这里解析数据
- (void)onSuccess NS_REQUIRES_SUPER;

///请求失败
- (void)onFail NS_REQUIRES_SUPER;

///上传进度
- (void)onUploadProgressUpdate:(nonnull NSProgress*) progress NS_REQUIRES_SUPER;

///下载进度回调
- (void)onDownloadProgressUpdate:(nonnull NSProgress*) progress NS_REQUIRES_SUPER;

///请求完成 无论是 失败 成功 或者取消
- (void)onComplete NS_REQUIRES_SUPER;

///开始请求
- (void)start NS_REQUIRES_SUPER;

///取消
- (void)cancel NS_REQUIRES_SUPER;

@end
