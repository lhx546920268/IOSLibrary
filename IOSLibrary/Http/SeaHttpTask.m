//
//  SeaHttpTask.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/20.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaHttpTask.h"
#import "SeaURLSessionManager.h"
#import "SeaBasic.h"

@interface SeaHttpTask()

///参数构造
@property(nonatomic, strong) SeaHttpBuilder *builder;

@end

@implementation SeaHttpTask
{
    ///当前任务
    NSURLSessionDataTask *_URLSessionTask;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        
    }
    
    return self;
}

- (void)dealloc
{
    
}

#pragma mark 子类实现

- (nonnull NSString*)requestURL
{
    return @"";
}

- (nullable NSMutableDictionary*)params
{
    return nil;
}

- (nullable NSMutableDictionary*)files
{
    return nil;
}

- (nullable NSArray<NSHTTPCookie*>*)cookies
{
    return nil;
}

- (nullable NSDictionary<NSString*, NSString*>*)headers
{
    return nil;
}

- (nonnull NSString*)name
{
    if(_name == nil){
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
    builder.postFormat = self.postFormat;
    builder.headers = self.headers;
    builder.cookies = self.cookies;
    
    NSMutableDictionary *params = self.params;
    NSMutableDictionary *files = self.files;
    
    [self processParams:params files:files];
    [builder addValuesFromDictionary:params];
    [builder addFilesFromDictionary:files];
    builder.httpMethod = self.httpMethod;
    self.builder = builder;
    
    return builder.request;
}

#pragma mark handler

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
            
            [weakSelf cancelTimeoutObserve];
            [weakSelf processResult:data error:error];
        }];
        
        [self addDownloadProgressHandler];
        [self addUploadProgressHandler];
    }
    return _URLSessionTask;
}

#pragma mark status

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
    [self observeTimeout];
}

///请求成功
- (void)onSuccess
{
    
}

///请求失败
- (void)onFail
{
    
}

///请求完成
- (void)onComplete
{
    _URLSessionTask = nil;
}

///超时
- (void)onTimeout
{
    if(self.isExecuting || self.isSuspended){
        [_URLSessionTask cancel];
        _URLSessionTask = nil;
        NSLog(@"自己设定的请求超时 %@", _URLSessionTask.originalRequest.URL);
        [self processResult:nil error:NSURLErrorTimedOut];
    }
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

#pragma mark timeout

///取消超时监听
- (void)cancelTimeoutObserve
{
    if(self.timeoutInterval){
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(onTimeout) object:nil];
    }
}

///监听超时
- (void)observeTimeout
{
    if(self.timeoutInterval > 0){
        [self performSelector:@selector(onTimeout) withObject:nil afterDelay:self.timeoutInterval];
    }
}

#pragma mark- public method

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
        _isCanceled = YES;
        [_URLSessionTask cancel];
        _URLSessionTask = nil;
        [self onComplete];
    }
}

#pragma mark- private method

///处理请求结果
- (void)processResult:(NSData*) data error:(NSInteger) error
{
    if(error == SeaHttpErrorCodeNoError){
        if([self resultFromData:data]){
            
            [self requestDidSuccess];
        }else{
            _errorCode = SeaHttpErrorCodeApiError;
            [self requestDidFail];
        }
    }else{
        _errorCode = error;
        [self requestDidFail];
    }
    
    [self onComplete];
}

- (void)requestDidSuccess
{
    [self onSuccess];
    !self.successHandler ?: self.successHandler(self);
}

- (void)requestDidFail
{
    [self onFail];
    !self.failHandler ?: self.failHandler(self);
}


@end
