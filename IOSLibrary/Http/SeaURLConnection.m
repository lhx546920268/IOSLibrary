//
//  SeaURLConnection.m

//

#import "SeaURLConnection.h"
#import "SeaBasic.h"

/**Range头域可以请求实体的一个或者多个子范围。例如，
 表示头500个字节：bytes=0-499
 表示第二个500字节：bytes=500-999
 表示最后500个字节：bytes=-500
 表示500字节以后的范围：bytes=500-
 第一个和最后一个字节：bytes=0-0,-1
 同时指定几个范围：bytes=500-600,601-999
 
 但是服务器可以忽略此请求头，如果无条件GET包含Range请求头，响应会以状态码206（PartialContent）返回而不是以200 （OK）。
 */
static NSString *const SeaURLConnectionRange = @"Range";

/**Content-Range实体头用于指定整个实体中的一部分的插入位置，他也指示了整个实体的长度。
 在服务器向客户返回一个部分响应，它必须描述响应覆盖的范围和整个实体长度
 */
static NSString *const SeaURLConnectionContentRange = @"Content-Range";

/**http请求状态
 */
typedef NS_ENUM(NSInteger, SeaURLConnectionState)
{
    SeaURLConnectionStateReady = 1, //准备请求
    SeaURLConnectionStateExecuting = 2, //执行中
    SeaURLConnectionStateCanceled = 3, //请求取消
    SeaURLConnectionStateFinished = 4, //请求完成
    SeaURLConnectionStateFailed = 5, //请求失败
};

/**通过http请求状态获取 NSOperation KVO key
 */
static inline NSString* NSOperationKVOKeyFromState(SeaURLConnectionState state)
{
    switch (state)
    {
        case SeaURLConnectionStateReady :
            return @"isReady";
            break;
        case SeaURLConnectionStateExecuting :
            return @"isExecuting";
            break;
        case SeaURLConnectionStateCanceled :
        case SeaURLConnectionStateFinished :
        case SeaURLConnectionStateFailed :
            return @"isFinished";
    }
}

@interface SeaURLConnection ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

/**http连接
 */
@property(nonatomic,strong) NSURLConnection *connection;

/**输出流
 */
@property(nonatomic,strong) NSOutputStream *outputStream;

/**下载的数据 当 downloadDestPath = nil 时，使用
 */
@property(nonatomic,strong) NSMutableData *downloadData;

/**已下载的数据大小，用于断点下载
 */
@property(nonatomic,assign) long long breakpointDownloadSize;

/**http请求状态
 */
@property(nonatomic,assign) SeaURLConnectionState state;

/**后台任务标识
 */
@property(nonatomic,assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

/**没有请求队列，独立执行
 */
@property(nonatomic,assign) BOOL executionIndependently;

/**当前运行的线程
 */
@property(nonatomic,strong) NSThread *currentThread;

@end


@implementation SeaURLConnection

@synthesize name;

/**初始化
 *@param delegate htpp代理
 *@return 一个实例
 */
- (id)initWithDelegate:(id<SeaURLConnectionDelegate>) delegate request:(SeaURLRequest *)request
{
    self = [super init];
    if(self)
    {
        _continueDownloadAfterEnterBackground = YES;
        _request = request;
        [_request buildPostBody];
        _totalBytesToUpload = request.uploadSize;
        
        self.showDownloadProgress = NO;
        self.showUploadProgress = NO;
        self.deleteDownloadTemporaryPathAfterDealloc = YES;
        self.delegate = delegate;
        
        _state = SeaURLConnectionStateReady;
        _errorCode = 0;
    }
    
    return self;
}

/**不加入NSOperationQueue独立执行，必须使用此方法，不要调用start否则会阻塞部分UI
 */
- (void)startWithoutOperationQueue
{
    self.executionIndependently = YES;
    [self start];
}

#pragma mark- dealloc

- (void)dealloc
{
    [_outputStream close];
    [self removeDownloadFile];
}

#pragma mark- readOnly property

- (NSData*)responseData
{
    NSData *data = nil;
    if(self.downloadData)
    {
        data = self.downloadData;
    }
    else if(self.downloadTemporayPath)
    {
        data = [NSData dataWithContentsOfFile:self.downloadTemporayPath];
    }
    else if(self.downloadDestinationPath)
    {
        data = [NSData dataWithContentsOfFile:self.downloadDestinationPath];
    }
    
    return data;
}

- (NSString*)URL
{
    return _request.URL;
}

#pragma mark- NSOperation override

/**开始下载
 */
- (void)start
{
    //必须判断是否可以执行了
    if(self.isReady)
    {
        @synchronized(self){
            
            UIApplication *application = [UIApplication sharedApplication];
            
            __weak SeaURLConnection *conn = self;
            self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void){
                
                [conn cancel];
                
                if(conn.backgroundTaskIdentifier != UIBackgroundTaskInvalid)
                {
                    [application endBackgroundTask:conn.backgroundTaskIdentifier];
                    conn.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
                }
            }];
            
            _totalBytesToDownload = 0;
            _totalBytesDidDownload = 0;
            
            if([self.delegate respondsToSelector:@selector(connectionDidGetUploaddSize:)])
            {
                [self.delegate connectionDidGetUploaddSize:self];
            }
            
            //断点下载
            if(self.supportBreakpointDownload && ![NSString isEmpty:self.downloadTemporayPath])
            {
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                
                BOOL isDirectory = NO;
                //文件存在并且不是文件夹
                if([fileManager fileExistsAtPath:self.downloadTemporayPath isDirectory:&isDirectory] && !isDirectory)
                {
                    _breakpointDownloadSize = [[fileManager attributesOfItemAtPath:self.downloadTemporayPath error:nil] fileSize];
                    [self.request.request setValue:[NSString stringWithFormat:@"bytes=%lld-", _breakpointDownloadSize] forHTTPHeaderField:SeaURLConnectionRange];
                    
                    NSLog(@"断点下载 %lld", _breakpointDownloadSize);
                }
            }
            
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request.request delegate:self startImmediately:NO];
            self.connection = connection;
            
            self.state = SeaURLConnectionStateExecuting;
            self.currentThread = [NSThread currentThread];
        }
        
        [self.connection start];
        
        //开始运行环，否则在加入NSOperationQueue 后代理将不执行，切必须要在 connection start后调用
        if(!self.executionIndependently && !self.isFinished)
        {
            CFRunLoopRun();
        }
    }
}


/**取消下载
 */
- (void)cancel
{
    if(self.currentThread)
    {
        [self performSelector:@selector(cancelRequest) onThread:self.currentThread withObject:nil waitUntilDone:NO];
    }
    else
    {
        [self cancelRequest];
    }
}

- (BOOL)isReady
{
    return [super isReady] && self.state == SeaURLConnectionStateReady;
}

- (BOOL)isExecuting
{
    return self.state == SeaURLConnectionStateExecuting;
}

- (BOOL)isFinished
{
    switch (self.state)
    {
        case SeaURLConnectionStateFailed :
        case SeaURLConnectionStateCanceled :
        case SeaURLConnectionStateFinished :
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

//是否并发
- (BOOL)isConcurrent
{
    return YES;
}

//是否异步
- (BOOL)isAsynchronous
{
    return YES;
}

#pragma mark- http state

//设置http请求状态
- (void)setState:(SeaURLConnectionState)state
{
    if(_state != state)
    {
        
        ///频繁调用会造成卡顿
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:state == SeaURLConnectionStateExecuting];
        
        //添加KVO通知
        NSString *oldKey = NSOperationKVOKeyFromState(_state);
        NSString *nowKey = NSOperationKVOKeyFromState(state);
        
        [self willChangeValueForKey:oldKey];
        [self willChangeValueForKey:nowKey];
        _state = state;
        [self didChangeValueForKey:oldKey];
        [self didChangeValueForKey:nowKey];
        
        switch (_state)
        {
            case SeaURLConnectionStateCanceled :
            case SeaURLConnectionStateFailed :
            case SeaURLConnectionStateFinished :
            {
                if(self.backgroundTaskIdentifier != UIBackgroundTaskInvalid)
                {
                    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
                    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
                }
                
                if(!self.executionIndependently)
                {
                    //停止当前运行环，否则出现不可预料的情况
                    CFRunLoopStop(CFRunLoopGetCurrent());
                }
            }
                break;
            default:
                break;
        }
    }
}

//取消请求
- (void)cancelRequest
{
    @synchronized(self){

        if(!self.isCancelled && !self.isFinished)
        {
            self.delegate = nil;
            self.completionHandler = nil;
            self.progressHandler = nil;
            
            //判断是否正在加载
            if(self.isExecuting)
            {
                //取消http
                [self.connection cancel];
                [super cancel];
                
                self.connection = nil;
                _request = nil;
                self.downloadData = nil;
                
                //关闭输出流
                if(self.outputStream)
                {
                    [self.outputStream close];
                    self.outputStream = nil;
                }
                
                //删除临时文件
                [self removeDownloadFile];
                self.state = SeaURLConnectionStateCanceled;
            }
        }
    }
}

#pragma mark- NSURLConnection delegate

//下载失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self removeDownloadFile];
    if(error.code != NSURLErrorCancelled)
    {
        NSLog(@"%@", error);
        
        _errorCode = error.code;
        
        if([self.delegate respondsToSelector:@selector(connectionDidFail:)])
        {
            [self.delegate connectionDidFail:self];
        }
        
        if(self.completionHandler)
        {
            self.completionHandler(self);
        }
        
        @synchronized(self){
            self.state = SeaURLConnectionStateFailed;
            self.currentThread = nil;
        }
    }
}

#pragma mark- NSURLConnectionData delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSInteger statusCode = [(NSHTTPURLResponse*) response statusCode];
        
        ///http 304 是读本地缓存时返回的
        if((statusCode < 200 || statusCode > 299) && statusCode != 304)
        {
            NSLog(@"statusCode %d", (int)statusCode);
            
            _errorCode = statusCode;
            
            if([self.delegate respondsToSelector:@selector(connectionDidFail:)])
            {
                [self.delegate connectionDidFail:self];
            }
            
            if(self.completionHandler)
            {
                self.completionHandler(self);
            }
            
            [self cancelRequest];
            return;
        }
    }
    
    if(response.expectedContentLength != NSURLResponseUnknownLength)
    {
        _totalBytesToDownload = response.expectedContentLength;
    }
    
    // NSLog(@"%@", [(NSHTTPURLResponse*) response allHeaderFields]);
    
    if([self.delegate respondsToSelector:@selector(connectionDidGetDownloadSize:)])
    {
        [self.delegate connectionDidGetDownloadSize:self];
    }
    
    if(self.downloadTemporayPath)
    {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        //判断文件是否存在并且不是文件夹
        BOOL isDirectory = NO;
        if(![fileManager fileExistsAtPath:self.downloadTemporayPath isDirectory:&isDirectory] && !isDirectory)
        {
            [fileManager createFileAtPath:self.downloadTemporayPath contents:nil attributes:nil];
        }
        
        BOOL append = NO;
        
        //判断是否支持断点下载
        if(_breakpointDownloadSize > 0 && [response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSDictionary *headerFields = [(NSHTTPURLResponse*) response allHeaderFields];
            //判断服务器是否支持断点下载
            if([headerFields objectForKey:SeaURLConnectionContentRange])
            {
                _totalBytesDidDownload = _breakpointDownloadSize;
                _totalBytesToDownload += _breakpointDownloadSize;
                append = YES;
            }
            else
            {
                _breakpointDownloadSize = 0;
            }
        }
        
        self.outputStream = [[NSOutputStream alloc] initToFileAtPath:self.downloadTemporayPath append:append];;
        [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.outputStream open];
    }
    else
    {
        if(self.totalBytesToDownload != 0)
        {
            self.downloadData = [NSMutableData dataWithCapacity:(NSUInteger)self.totalBytesToDownload];
        }
        else
        {
            self.downloadData = [NSMutableData data];
        }
    }
}

//收到下载数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSUInteger length = data.length;
    
    //把下载的数据写入文件
    if(self.downloadTemporayPath)
    {
        NSUInteger bytesDidWrite = 0; //已写的数据长度
        const u_int8_t* buffer = (u_int8_t*)[data bytes]; //需要写入文件的数据
        
        while (bytesDidWrite < length)
        {
            NSUInteger len = [self.outputStream write:&buffer[bytesDidWrite] maxLength:length - bytesDidWrite];
            
            //写入文件出错，取消下载
            if(len == -1)
            {
                break;
            }
            
            bytesDidWrite += len;
        }
        
        //输出流出错了
        if(self.outputStream.streamError)
        {
            if([self.delegate respondsToSelector:@selector(connectionDidFail:)])
            {
                _errorCode = NSNotFound;
                [self.delegate connectionDidFail:self];
            }
            
            [self cancelRequest];
            return;
        }
    }
    else //写入内存
    {
        [self.downloadData appendData:data];
    }
    
    _totalBytesDidDownload += length;
    
    //显示下载进度
    if(self.showDownloadProgress)
    {
        //http请求可能不在主线程上运行
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            _downloadProgress = (double)_totalBytesDidDownload / (double)MAX(1, _totalBytesToDownload);
            
            if([self.delegate respondsToSelector:@selector(connectionDidUpdateProgress:)])
            {
                [self.delegate connectionDidUpdateProgress:self];
            }
            
            if(self.progressHandler)
            {
                self.progressHandler(self);
            }
        });
    }
}

//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.outputStream close];
    self.outputStream = nil;
    
    //把临时文件移动到目的文件
    if(self.downloadTemporayPath && self.downloadDestinationPath)
    {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager moveItemAtPath:self.downloadTemporayPath toPath:self.downloadDestinationPath error:nil];
        self.downloadTemporayPath = nil;
    }
    
    if(self.completionHandler != nil)
    {
        self.completionHandler(self);
    }
    
    if([self.delegate respondsToSelector:@selector(connectionDidFinishLoading:)])
    {
        [self.delegate connectionDidFinishLoading:self];
    }
    
    @synchronized(self){
        
        self.state = SeaURLConnectionStateFinished;
        self.currentThread = nil;
    }
}


- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    
    //显示上传进度
    if(self.showUploadProgress)
    {
        //http请求可能不在主线程上运行
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            _totalBytesDidUpload = totalBytesWritten;
            _uploadProgress = (double)totalBytesWritten / (double)MAX(1, totalBytesExpectedToWrite);
            
            if([self.delegate respondsToSelector:@selector(connectionDidUpdateProgress:)])
            {
                [self.delegate connectionDidUpdateProgress:self];
            }
            
            if(self.progressHandler)
            {
                self.progressHandler(self);
            }
        });
    }
}

#pragma mark- private method

//删除下载文件
- (void)removeDownloadFile
{
    //如果临时文件已移到目的文件中，不需要删除
    if(_deleteDownloadTemporaryPathAfterDealloc && ![NSString isEmpty:_downloadTemporayPath] && [NSString isEmpty:_downloadDestinationPath])
    {
        [[[NSFileManager alloc] init] removeItemAtPath:_downloadTemporayPath error:nil];
        self.downloadTemporayPath = nil;
    }
}

@end
