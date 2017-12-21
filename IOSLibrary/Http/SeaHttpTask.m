//
//  SeaHttpTask.m
//  AutoLayoutDemo
//
//  Created by 罗海雄 on 2017/12/20.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaHttpTask.h"
#import "SeaHttpBuilder.h"
#import "SeaURLSessionManager.h"

@interface SeaHttpTask()


@end

@implementation SeaHttpTask
{
    NSURLSessionDataTask *_URLSessionTask;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        
    }
    
    return self;
}

/**请求URL
 */
- (nonnull NSString*)requestURL
{
    return @"";
}

/**获取参数
 */
- (nullable NSMutableDictionary*)params
{
    return nil;
}

/**获取文件
 */
- (nullable NSMutableDictionary*)files
{
    return nil;
}

- (nonnull NSString*)name
{
    if(_name == nil)
    {
        return NSStringFromClass([self class]);
    }
    
    return _name;
}


/**处理参数 比如签名
 */
- (void)processParams:(nullable NSMutableDictionary*) params files:(nullable NSMutableDictionary*)files
{
    
}

/**请求是否成功
 *@return 是否成功
 */
- (BOOL)resultFromData:(nullable NSData*) data
{
    return YES;
}

///获取请求
- (NSURLRequest*)request
{
    SeaHttpBuilder *builder = [SeaHttpBuilder buildertWithURL:self.requestURL];
    
    NSMutableDictionary *params = self.params;
    NSMutableDictionary *files = self.files;
    
    [self processParams:params files:files];
    [builder addValuesFromDictionary:params];
    [builder addFilesFromDictionary:files];
    builder.httpMethod = self.httpMethod;
    
    return builder.request;
}

- (void)setUploadProgressHandler:(void (^)(__kindof NSProgress * _Nonnull))uploadProgressHandler
{
    if(_uploadProgressHandler != uploadProgressHandler){
        _uploadProgressHandler = [uploadProgressHandler copy];
        [self addUploadProgressHandler];
    }
}

///添加上传进度
- (void)addUploadProgressHandler
{
    if(_URLSessionTask && _uploadProgressHandler){
        
        __weak SeaHttpTask *weakSelf = self;
        [self.URLSessionManager addUploadProgress:^(NSProgress *progress){
            
            [weakSelf onUploadProgressUpdate:progress];
        } forTask:_URLSessionTask];
    }
}

- (void)setDownloadProgressHandler:(void (^)(__kindof NSProgress * _Nonnull))downloadProgressHandler
{
    if(_downloadProgressHandler != downloadProgressHandler){
        _downloadProgressHandler = [downloadProgressHandler copy];
        [self addDownloadProgressHandler];
    }
}

///添加下载进度
- (void)addDownloadProgressHandler
{
    if(_URLSessionTask && _downloadProgressHandler){
        
        __weak SeaHttpTask *weakSelf = self;
        [self.URLSessionManager addDownloadProgress:^(NSProgress *progress){
            
            [weakSelf onDownloadProgressUpdate:progress];
        } forTask:_URLSessionTask];
    }
}

- (nonnull SeaURLSessionManager*)URLSessionManager
{
    return [SeaURLSessionManager shareInstance];
}

- (nonnull NSURLSessionDataTask*)getURLSessionTask
{
    if(!_URLSessionTask){
        __weak SeaHttpTask *weakSelf = self;
        _URLSessionTask = [self.URLSessionManager dataTaskWithTask:self completion:^(NSURLSessionTask *task, NSData *data, NSInteger error){
            
            [weakSelf processResult:data error:error];
        }];
        
        [self addDownloadProgressHandler];
        [self addUploadProgressHandler];
    }
    return _URLSessionTask;
}

- (BOOL)isExecuting
{
    return _URLSessionTask != nil && _URLSessionTask.state == NSURLSessionTaskStateRunning;
}

- (BOOL)isSuspended
{
    return _URLSessionTask != nil && _URLSessionTask.state == NSURLSessionTaskStateSuspended;
}

#pragma mark- 回调

///请求开始
- (void)onStart
{
    
}

///请求成功
- (void)onSuccess
{
    !self.successHandler ?: self.successHandler(self);
}

///请求失败
- (void)onFail
{
    !self.failHandler ?: self.failHandler(self);
}

///请求完成
- (void)onComplete
{
    _URLSessionTask = nil;
}

///上传进度
- (void)onUploadProgressUpdate:(nonnull NSProgress*) progress
{
    !self.uploadProgressHandler ?: self.uploadProgressHandler(progress);
}

///下载进度回调
- (void)onDownloadProgressUpdate:(nonnull NSProgress*) progress
{
    !self.downloadProgressHandler ?: self.downloadProgressHandler(progress);
}

///开始请求
- (void)start
{
    if(self.isExecuting)
        return;
    
    [self getURLSessionTask];
    
    [self onStart];
    [_URLSessionTask resume];
}

///取消
- (void)cancel
{
    if(self.isSuspended || self.isExecuting){
        [_URLSessionTask cancel];
        _URLSessionTask = nil;
    }
}

///处理请求结果
- (void)processResult:(NSData*) data error:(NSInteger) error
{
    if(error == SeaHttpErrorCodeNoError){
        if([self resultFromData:data]){
            
            [self onSuccess];
        }else{
            _errorCode = SeaHttpErrorCodeApiError;
            [self onFail];
        }
    }else{
        _errorCode = error;
        [self onFail];
    }
    
    [self onComplete];
}

@end
