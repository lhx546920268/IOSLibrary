//
//  SeaURLSessionManager.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/20.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaURLSessionManager.h"
#import "SeaURLSessionTaskDelegate.h"
#import "SeaHttpTask.h"

@interface SeaURLSessionManager()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property(nonatomic, strong) NSURLSession *session;

@property(nonatomic, strong) NSMutableDictionary<NSNumber*, SeaURLSessionTaskDelegate*> *delegates;

@end

@implementation SeaURLSessionManager

- (instancetype)init
{
    return [self initWithConfiguration:nil];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration*) configuration
{
    self = [super init];
    if(self){
        if(configuration == nil){
            configuration = [self defaultURLSessionConfiguration];
        }
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        self.delegates = [NSMutableDictionary dictionary];
    }
    return self;
}

///默认的配置
- (NSURLSessionConfiguration*)defaultURLSessionConfiguration
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.timeoutIntervalForRequest = 15;
    configuration.timeoutIntervalForResource = 15;
    configuration.networkServiceType = NSURLNetworkServiceTypeDefault;
    configuration.allowsCellularAccess = YES;
    configuration.HTTPShouldSetCookies = YES;
    
    return configuration;
}

/**
 单例
 */
+ (instancetype)shareInstance
{
    static SeaURLSessionManager *shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [SeaURLSessionManager new];
    });
    
    return shareManager;
}

#pragma mark- task

- (NSURLSessionDataTask*)dataTaskWithTask:(SeaHttpTask*) task completion:(SeaURLSessionCompletionHandler) completion
{
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:task.request];
    [self addDataTask:dataTask httpTask:task completion:completion];
    return dataTask;
}

- (NSURLSessionDataTask*)dataTaskWithRequest:(NSURLRequest*) request completion:(SeaURLSessionCompletionHandler) completion
{
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    [self addDataTask:dataTask completion:completion];
    return dataTask;
}

- (NSURLSessionDownloadTask*)downloadTaskWithURL:(NSString*) URL destinationPath:(NSString*) destinationPath completion:(SeaURLSessionDownloadHandler) completion
{
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:URL]];
    [self addDownloadTask:downloadTask destinationPath:destinationPath completion:completion];
    
    return downloadTask;
}

#pragma mark- progress

- (void)addUploadProgress:(SeaURLSessionUploadProgressHandler) uploadProgress forTask:(NSURLSessionTask*) task
{
    if(!uploadProgress || !task)
        return;
    SeaURLSessionTaskDelegate *delegate = [self delegateForTask:task];
    delegate.uploadProgressHandler = uploadProgress;
}

- (void)setShowUploadProgress:(BOOL) show forTask:(NSURLSessionTask*) task
{
    if(!task)
        return;
    SeaURLSessionTaskDelegate *delegate = [self delegateForTask:task];
    delegate.showUploadProgress = show;
}

- (void)addDownloadProgress:(SeaURLSessionDownloadProgressHandler) downloadProgress forTask:(NSURLSessionTask*) task
{
    if(!downloadProgress || !task)
        return;
    SeaURLSessionTaskDelegate *delegate = [self delegateForTask:task];
    delegate.downloadProgressHandler = downloadProgress;
}

- (void)setShowDownloadProgress:(BOOL) show forTask:(NSURLSessionTask*) task
{
    if(!task)
        return;
    SeaURLSessionTaskDelegate *delegate = [self delegateForTask:task];
    delegate.showDownloadProgress = show;
}


#pragma mark- delegate

- (void)addDelegate:(id<SeaHttpTaskDelegate>) delegate forTask:(NSURLSessionTask*) task
{
    if(!delegate || !task)
        return;
    SeaURLSessionTaskDelegate *taskDelegate = [self delegateForTask:task];
    [taskDelegate addDelegate:delegate];
}

#pragma mark- private method

///添加任务代理
- (SeaURLSessionTaskDelegate*)addDataTask:(NSURLSessionDataTask*) dataTask
                               completion:(SeaURLSessionCompletionHandler) completionHandler
{
    return [self addDataTask:dataTask httpTask:nil completion:completionHandler];
}


//添加任务
- (SeaURLSessionTaskDelegate*)addDataTask:(NSURLSessionDataTask*) dataTask httpTask:(SeaHttpTask*) httpTask completion:(SeaURLSessionCompletionHandler) completionHandler
{
    if(!dataTask)
        return nil;
    SeaURLSessionTaskDelegate *delegate = [[SeaURLSessionTaskDelegate alloc] initWithDataTask:dataTask];
    delegate.completionHandler = completionHandler;
    delegate.httpTask = httpTask;
    
    [self.delegates setObject:delegate forKey:@(dataTask.taskIdentifier)];
    return delegate;
}

///添加下载任务
- (SeaURLSessionTaskDelegate*)addDownloadTask:(NSURLSessionDownloadTask*) downloadTask destinationPath:(NSString*) destinationPath
                           completion:(SeaURLSessionDownloadHandler) completionHandler
{
    if(!downloadTask)
        return nil;
    SeaURLSessionTaskDelegate *delegate = [[SeaURLSessionTaskDelegate alloc] initWithDownloadTask:downloadTask destinationPath:destinationPath];
    delegate.downloadHandler = completionHandler;
    
    [self.delegates setObject:delegate forKey:@(downloadTask.taskIdentifier)];
    return delegate;
}

//获取代理
- (SeaURLSessionTaskDelegate*)delegateForTask:(NSURLSessionTask*) task
{
    return [self.delegates objectForKey:@(task.taskIdentifier)];
}

//删除代理
- (void)removeTask:(NSURLSessionTask*) task
{
    [self.delegates removeObjectForKey:@(task.taskIdentifier)];
}

#pragma mark- NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    SeaURLSessionTaskDelegate *delegate = [self delegateForTask:task];
    [delegate URLSession:session task:task didCompleteWithError:error];
    [self removeTask:task];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    SeaURLSessionTaskDelegate *delegate = [self delegateForTask:task];
    [delegate URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
}

#pragma mark- NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    SeaURLSessionTaskDelegate *delegate = [self delegateForTask:dataTask];
    [delegate URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    SeaURLSessionTaskDelegate *delegate = [self delegateForTask:dataTask];
    [delegate URLSession:session dataTask:dataTask didReceiveData:data];
}

#pragma mark- NSURLSessionDownloadTaskDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location
{
    SeaURLSessionTaskDelegate *delegate = [self delegateForTask:downloadTask];
    [delegate URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    SeaURLSessionTaskDelegate *delegate = [self delegateForTask:downloadTask];
    [delegate URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

@end
