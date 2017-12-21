//
//  SeaURLSessionTaskDelegate.m
//  AutoLayoutDemo
//
//  Created by 罗海雄 on 2017/12/20.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaURLSessionTaskDelegate.h"
#import "SeaHttpTaskDelegate.h"
#import "SeaHttpTask.h"
#import "SeaHttpBuilder.h"
#import "NSString+Utilities.h"
#import "SeaFileManager.h"
#import "SeaBasic.h"
#import "SeaWeakObjectContainer.h"

///进度监听属性
static NSString *const SeaProgressKeyPath = @"fractionCompleted";

@interface SeaURLSessionTaskDelegate()

/**
 请求返回的数据
 */
@property(nonatomic,strong) NSMutableData *responseData;

/**
 相关任务
 */
@property(nonatomic,strong) NSURLSessionDataTask *dataTask;

/**
 下载任务
 */
@property(nonatomic,strong) NSURLSessionDownloadTask *downloadTask;

/**
 下载完成后的文件路径
 */
@property(nonatomic,strong) NSURL *downloadDestinationURL;

/**
 临时文件路径 如果没设置下载路径，会移动该位置，防止系统的被删除
 */
@property(nonatomic,strong) NSURL *temporaryURL;

/**
 上传进度
 */
@property(nonatomic,strong) NSProgress *uploadProgress;

/**
 下载进度
 */
@property(nonatomic,strong) NSProgress *downloadProgress;

/**
 代理
 */
@property(nonatomic,strong) NSMutableSet<SeaWeakObjectContainer*> *delegates;

@end

@implementation SeaURLSessionTaskDelegate

- (instancetype)initWithDataTask:(NSURLSessionDataTask*) task
{
    self = [super init];
    if(self){
        
        self.dataTask = task;
        self.responseData = [NSMutableData data];
    }
    return self;
}

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask*) task destinationPath:(NSString*) destinationPath
{
    self = [super init];
    if(self){
        self.downloadTask = task;
        if([NSString isEmpty:destinationPath]){
            //必须要有下载文件路径，系统下载的文件会被删除
            self.temporaryURL = [NSURL fileURLWithPath:[SeaFileManager getTemporaryFile]];
        }else{
            self.downloadDestinationURL = [NSURL fileURLWithPath:destinationPath];
        }
    }
    return self;
}

- (void)setUploadProgressHandler:(SeaURLSessionUploadProgressHandler)uploadProgressHandler
{
    if(_uploadProgressHandler != uploadProgressHandler){
        if(uploadProgressHandler){
            _uploadProgressHandler = [uploadProgressHandler copy];
            if(!self.uploadProgress){
                self.uploadProgress = [self progressWithParent:nil];
            }
            self.showUploadProgress = YES;
        }else{
            _uploadProgressHandler = nil;
        }
    }
}

- (void)setDownloadProgressHandler:(SeaURLSessionDownloadProgressHandler)downloadProgressHandler
{
    if(_downloadProgressHandler != downloadProgressHandler){
        if(downloadProgressHandler){
            _downloadProgressHandler = [downloadProgressHandler copy];
            if(!self.downloadProgress){
                self.downloadProgress = [self progressWithParent:nil];
            }
            self.showDownloadProgress = YES;
        }else{
            _downloadProgressHandler = nil;
        }
    }
}

- (void)setShowUploadProgress:(BOOL)showUploadProgress
{
    if(_showUploadProgress != showUploadProgress){
        _showUploadProgress = showUploadProgress;
        if(_showUploadProgress){
            if(!self.uploadProgress){
                self.uploadProgress = [self progressWithParent:nil];
            }
        }else{
            self.uploadProgress = nil;
        }
    }
}

- (void)setShowDownloadProgress:(BOOL)showDownloadProgress
{
    if(_showDownloadProgress != showDownloadProgress){
        _showDownloadProgress = showDownloadProgress;
        if(_showDownloadProgress){
            if(!self.downloadProgress){
                self.downloadProgress = [self progressWithParent:nil];
            }
        }else{
            self.downloadProgress = nil;
        }
    }
}

///创建一个进度实例
- (NSProgress*)progressWithParent:(NSProgress*) parent
{
    NSProgress *progress;
    if(parent){
        progress = [[NSProgress alloc] initWithParent:parent userInfo:nil];
    }else{
        progress = [[NSProgress alloc] init];
    }
    
    __weak SeaURLSessionTaskDelegate *weakSelf = self;
    progress.totalUnitCount = NSURLSessionTransferSizeUnknown;
    progress.cancellable = YES;
    progress.cancellationHandler = ^(void){
      
        [weakSelf.dataTask cancel];
    };
    
    progress.pausable = YES;
    progress.pausingHandler = ^(void){
        
        [weakSelf.dataTask suspend];
    };
    
    if (@available(iOS 9.0, *)) {
        progress.resumingHandler = ^(void){
            [weakSelf.dataTask resume];
        };
    }
    
    //添加进度 kvo
    [progress addObserver:self forKeyPath:SeaProgressKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    return progress;
}

- (void)dealloc
{
    [self.uploadProgress removeObserver:self forKeyPath:SeaProgressKeyPath];
    [self.downloadProgress removeObserver:self forKeyPath:SeaProgressKeyPath];
    [SeaFileManager deleteOneFile:[self.temporaryURL absoluteString]];
}

#pragma mark- kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:SeaProgressKeyPath]){
        
        dispatch_main_async_safe(^(void){
           
            if([object isEqual:self.uploadProgress]){
                !self.uploadProgressHandler ?: self.uploadProgressHandler(self.uploadProgress);
                
                NSURLSessionTask *task = self.dataTask ? self.dataTask : self.downloadTask;
                for(SeaWeakObjectContainer *container in self.delegates){
                    if([container.weakObject respondsToSelector:@selector(URLSessionTask:didUpdateUploadProgress:)]){
                        [container.weakObject URLSessionTask:task didUpdateUploadProgress:self.uploadProgress];
                    }
                }
                
            }else if (self.downloadProgress){
                !self.downloadProgressHandler ?: self.downloadProgressHandler(self.downloadProgress);
                
                NSURLSessionTask *task = self.dataTask ? self.dataTask : self.downloadTask;
                for(SeaWeakObjectContainer *container in self.delegates){
                    if([container.weakObject respondsToSelector:@selector(URLSessionTask:didUpdateDownloadProgress:)]){
                        [container.weakObject URLSessionTask:task didUpdateDownloadProgress:self.downloadProgress];
                    }
                }
            }
        });
    }
}

#pragma mark- NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //请求任务完成
    dispatch_main_async_safe(^(void){
        if(error){
            //取消将忽略
            if(error.code != NSURLErrorCancelled){
                if(self.dataTask){
                    !self.completionHandler ?: self.completionHandler(self.dataTask, nil, error.code);
                    
                    for(SeaWeakObjectContainer *container in self.delegates){
                        if([container.weakObject respondsToSelector:@selector(URLSessionDataTask:didCompleteWithData:error:)]){
                            [container.weakObject URLSessionDataTask:(NSURLSessionDataTask*)task didCompleteWithData:nil error:error.code];
                        }
                    }
                    
                }else if (self.downloadTask){
                    !self.downloadHandler ?: self.downloadHandler(self.downloadTask, nil, error.code);
                    
                    for(SeaWeakObjectContainer *container in self.delegates){
                        if([container.weakObject respondsToSelector:@selector(URLSessionDownloadTask:didCompleteWithURL:error:)]){
                            [container.weakObject URLSessionDownloadTask:(NSURLSessionDownloadTask*)task didCompleteWithURL:nil error:error.code];
                        }
                    }
                }
            }
        }else{
            if(self.dataTask){
                !self.completionHandler ?: self.completionHandler(self.dataTask, self.responseData, SeaHttpErrorCodeNoError);
                
                for(SeaWeakObjectContainer *container in self.delegates){
                    if([container.weakObject respondsToSelector:@selector(URLSessionDataTask:didCompleteWithData:error:)]){
                        [container.weakObject URLSessionDataTask:(NSURLSessionDataTask*)task didCompleteWithData:self.responseData error:SeaHttpErrorCodeNoError];
                    }
                }
            }
        }
    })
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if(self.uploadProgress){
        self.uploadProgress.totalUnitCount = totalBytesExpectedToSend;
        self.uploadProgress.completedUnitCount = totalBytesSent;
    }
}

#pragma mark- NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    
    if([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSInteger statusCode = [(NSHTTPURLResponse*) response statusCode];
        
        ///http 304 是读本地缓存时返回的
        if((statusCode < 200 || statusCode > 299) && statusCode != 304)
        {
            //请求失败了
            disposition = NSURLSessionResponseCancel;
        }
    }
    
    !completionHandler ?: completionHandler(disposition);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    if(self.downloadProgress){
        self.downloadProgress.totalUnitCount = dataTask.countOfBytesExpectedToReceive;
        self.downloadProgress.completedUnitCount = dataTask.countOfBytesReceived;
    }
}

#pragma mark- NSURLSessionDownloadTaskDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location
{
    NSURL *URL = location;
    NSURL *destURL = self.downloadDestinationURL;
    if(!destURL){
        destURL = self.temporaryURL;
    }
    
    NSError *error;
    if([[NSFileManager defaultManager] moveItemAtURL:location toURL:destURL error:&error]){
        URL = destURL;
    }else{
#if SeaHttpLogConfig
        NSLog(@"%@", error);
#endif
    }
    
    dispatch_main_async_safe(^(void){
        !self.downloadHandler ?: self.downloadHandler(downloadTask, URL, SeaHttpErrorCodeNoError);
        
        for(SeaWeakObjectContainer *container in self.delegates){
            if([container.weakObject respondsToSelector:@selector(URLSessionDownloadTask:didCompleteWithURL:error:)]){
                [container.weakObject URLSessionDownloadTask:downloadTask didCompleteWithURL:URL error:SeaHttpErrorCodeNoError];
            }
        }
    })
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if(self.downloadProgress){
        self.downloadProgress.totalUnitCount = totalBytesExpectedToWrite;
        self.downloadProgress.completedUnitCount = totalBytesWritten;
    }
}

#pragma mark- public method

- (void)addDelegate:(id<SeaHttpTaskDelegate>) delegate
{
    if(!delegate)
        return;
    
    if(!self.delegates){
        self.delegates = [NSMutableSet set];
    }
    
    [self.delegates addObject:[SeaWeakObjectContainer containerWithObject:delegate]];
}

@end
