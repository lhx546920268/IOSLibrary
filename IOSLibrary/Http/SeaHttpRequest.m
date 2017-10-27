//
//  SeaHttpRequest.m

//

#import "SeaHttpRequest.h"
#import "SeaFileManager.h"
#import "SeaURLConnection.h"


@interface SeaHttpRequest ()<SeaURLConnectionDelegate>
{
    SeaHttpOperation *_operation;
}

//网络请求
@property(nonatomic,strong) SeaURLConnection *conn;

//是否还在处理结果中
@property(nonatomic,assign) BOOL processing;

@end

@implementation SeaHttpRequest

- (id)init
{
    self = [super init];
    if(self)
    {
        [self initilization];
    }
    return self;
}

- (id)initWithDelegate:(id<SeaHttpRequestDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        self.delegate = delegate;
        [self initilization];
    }
    return self;
}

- (id)initWithDelegate:(id<SeaHttpRequestDelegate>)delegate identifier:(NSString *)identifier
{
    self = [super init];
    if(self)
    {
        self.delegate = delegate;
        self.identifier = identifier;
        [self initilization];
    }
    return self;
}

- (void)initilization
{
    self.timeOut = 60.0;
    self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    self.showDownloadProgress = NO;
    self.showUploadProgress = NO;
}

#pragma mark- property

- (void)setConn:(SeaURLConnection *)conn
{
    if(_conn != conn)
    {
        [_conn cancel];
        _conn = conn;
        _conn.downloadTemporayPath = [SeaFileManager getTemporaryFile];
        _conn.showUploadProgress = self.showUploadProgress;
        _conn.showDownloadProgress = self.showDownloadProgress;
    }
}

- (BOOL)requesting
{
    return self.conn != nil && [self.conn isExecuting];
}

#pragma mark-内存管理

- (void)dealloc
{
    [_conn cancel];
}

#pragma mark-publick

- (__kindof SeaHttpOperation*)operation
{
    return _operation;
}

#pragma mark- get请求

/**get请求 使用默认的缓存协议
 *@param url get请求路径
 */
- (void)downloadWithURL:(NSString *)url
{
    [self downloadWithURL:url dic:nil];
}

#pragma mark- post请求

/**post请求 使用默认的缓存协议
 *@param url post请求路径
 *@param dic 请求参数
 */
- (void)downloadWithURL:(NSString *)url dic:(NSDictionary *)dic
{
    [self downloadWithURL:url paraDic:dic fileDic:nil];
}

/**可上传文件的post请求 文件参数不能重复
 *@param url post请求路径
 *@param paraDic 请求参数
 *@param fileDic 文件参数
 */
- (void)downloadWithURL:(NSString *)url paraDic:(NSDictionary *)paraDic fileDic:(NSDictionary *)fileDic
{
    SeaURLRequest *request = [SeaURLRequest requestWithURL:url cachePolicy:self.cachePolicy imeoutInterval:self.timeOut];
    
    [request addPostValueFromDictionary:paraDic];
    
    [fileDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSObject *obj, BOOL *stop){
        if([obj isKindOfClass:[NSString class]])
        {
            [request addFile:(NSString*)obj forKey:key];
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            [request addFileFromFiles:(NSArray*)obj fileKey:key];
        }
    }];
    
    [self.operation onStart];
    self.conn = [[SeaURLConnection alloc] initWithDelegate:self request:request];
    [self.conn startWithoutOperationQueue];
}

/**post请求 使用默认的缓存协议
 *@param operation 工具类
 */
- (void)downloadWithOperation:(SeaHttpOperation*) operation
{
    self.processing = NO;
    NSMutableDictionary *params = operation.params;
    NSMutableDictionary *files = operation.files;
    [operation processParams:params files:files];
    
    _operation = operation;
    
    self.identifier = operation.name;
    [self downloadWithURL:operation.requestURL paraDic:params fileDic:files];
}


#pragma mark- cancel

/**取消 请求
 */
- (void)cancelRequest
{
    [self.conn cancel];
    self.conn = nil;
}


#pragma mark- SeaURLConnection delegate

- (void)connectionDidFail:(SeaURLConnection *)conn
{
    NSLog(@"SeaURLConnection fail ,url = %@", conn.request.request.URL);
    
    self.processing = YES;
    self.operation.errorCode = conn.errorCode;
    if([self.delegate respondsToSelector:@selector(httpRequestDidFail:)])
    {
        [self.delegate httpRequestDidFail:self];
    }
    
    if(self.completionHandler)
    {
        self.completionHandler(self);
    }
    
    [_operation onFail];
    [_operation onComplete];
    
    if(self.processing)
    {
        _operation = nil;
        self.processing = NO;
    }
}

- (void)connectionDidUpdateProgress:(SeaURLConnection *)conn
{
    if([self.delegate respondsToSelector:@selector(httpRequest:didUpdateUploadProgress:downloadProgress:)])
    {
        [self.delegate httpRequest:self didUpdateUploadProgress:conn.uploadProgress downloadProgress:conn.downloadProgress];
    }
    
    if(self.progressHandler)
    {
        self.progressHandler(self, conn.uploadProgress, conn.downloadProgress);
    }
    
}

- (void)connectionDidFinishLoading:(SeaURLConnection *)conn
{
    self.processing = YES;
    NSData *data = conn.responseData;
    BOOL result = YES;
    if(self.operation != nil)
    {
        result = [self.operation resultFromData:data];
    }
    
    if(result)
    {
        self.operation.errorCode = SeaHttpErrorCodeNoError;
        if([self.delegate respondsToSelector:@selector(httpRequestDidFinish:)])
        {
            [self.delegate httpRequestDidFinish:self];
        }
        [_operation onSuccess];
    }
    else
    {
        self.operation.errorCode = SeaHttpErrorCodeApiError;
        if([self.delegate respondsToSelector:@selector(httpRequestDidFail:)])
        {
            [self.delegate httpRequestDidFail:self];
        }
        [_operation onFail];
    }
    if(self.completionHandler)
    {
        self.completionHandler(self);
    }
    
    [_operation onComplete];
    
    if(self.processing)
    {
        _operation = nil;
        self.processing = NO;
    }
}

@end
