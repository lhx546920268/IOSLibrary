//
//  SeaURLRequest.m

//

#import "SeaURLRequest.h"
#import "SeaHttpRequestParam.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SeaBasic.h"

//超时时间
static NSTimeInterval SeaURLRequestDefaultTimeoutInterval = 60.0;

//postBody 默认格式
static NSString * const SeaURLRequestURLEncodedString = @"application/x-www-form-urlencoded";

//postBody 表单格式
static NSString *const SeaURLRequestMultipartFormDataString = @"multipart/form-data";

//字符集
static NSString *const SeaURLRequestCharset = @"charset";

//内容类型
static NSString *const SeaURLRequestContentType = @"Content-Type";

//定义

@interface SeaURLRequest ()
{
    ///http请求链接
    NSString *_URL;
}

//post请求参数 数组元素是 SeaHttpRequestParam
@property(nonatomic,retain) NSMutableArray *postParams;

//body 输出流，把body写入文件
@property(nonatomic,retain) NSOutputStream *bodyOutputStream;

//body 上传临时文件
@property(nonatomic,copy) NSString *uploadTemporaryPath;

#if SeaURLConnectionLogConfig
//debug模式的postBody
@property(nonatomic,strong) NSString *debugPostBodyString;

#endif

@end

@implementation SeaURLRequest

#pragma mark- init

/** initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0
 */
- (id)initWithURL:(NSString*) URL
{
    return [self initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:SeaURLRequestDefaultTimeoutInterval];
}

/** initWithURL:URL cachePolicy:cachePolicy timeoutInterval:60.0
 */
- (id)initWithURL:(NSString*)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
    return [self initWithURL:URL cachePolicy:cachePolicy timeoutInterval:SeaURLRequestDefaultTimeoutInterval];
}

/**构造方法
 *@param URL 请求路径
 *@param cachePolicy http缓存协议
 *@param timeoutInterval 请求超时时间 秒
 *@return 一个实例
 */
- (id)initWithURL:(NSString*)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
    self = [super init];
    if(self)
    {
        self.useECStoreSignature = NO;
        
        _URL = [URL copy];
        _request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL] cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
        
       // _request.HTTPShouldHandleCookies = NO;
        //_request.HTTPShouldUsePipelining = YES;
      //  [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        self.postFormat = SeaURLRequestPostFormatURLEncoded;
    }
    return self;
}

#pragma mark- class method

/** initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0
 */
+ (id)requestWithURL:(NSString*) URL
{
    return [[SeaURLRequest alloc] initWithURL:URL];
}

/** initWithURL:URL cachePolicy:cachePolicy timeoutInterval:60.0
 */
+ (id)requestWithURL:(NSString *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
    return [[SeaURLRequest alloc] initWithURL:URL cachePolicy:cachePolicy];
}

/** initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval
 */
+ (id)requestWithURL:(NSString *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy imeoutInterval:(NSTimeInterval)timeoutInterval
{
    return [[SeaURLRequest alloc] initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
}

#pragma mark- dealloc

- (void)dealloc
{
    [_bodyOutputStream close];

    //删除临时文件
    if(_uploadTemporaryPath)
    {
        [[[NSFileManager alloc] init] removeItemAtPath:_uploadTemporaryPath error:nil];
    }
}

#pragma mark- property

- (NSString*)URL
{
    return _URL;
}

#pragma mark- 添加 Post请求 参数

//如果请求参数不为空，会自动设置请求方法为 POST

/**添加 post请求参数 参数名可以重复
 *@param value 参数值，支持 NSString,NSNumber, NSData
 *@param key 参数名
 */
- (void)addPostValue:(id<NSObject>)value forKey:(NSString*)key
{
    if(!self.postParams)
    {
        self.postParams = [NSMutableArray array];
    }
    
    [self.postParams addObject:[SeaHttpRequestParam requestParamWithValue:value key:key]];
}

/**添加 post请求参数 参数名不能重复，会删除已存在的参数
 *@param value 参数值，支持 NSString,NSNumber, NSData
 *@param key 参数名
 */
- (void)setPostValue:(id<NSObject>)value forKey:(NSString*)key
{
    [self removePostValueForKey:key];
    
    [self addPostValue:value forKey:key];
}

/**添加文件上传 参数名可以重复
 *@param filePath 本地文件全路径
 *@param key 参数名
 */
- (void)addFile:(NSString*)filePath forKey:(NSString*)key
{
    if([NSString isEmpty:filePath])
        return;
    
    //判断文件是否存在
    if([[[NSFileManager alloc] init] fileExistsAtPath:filePath isDirectory:nil])
    {
        if(!self.postParams)
        {
            self.postParams = [NSMutableArray array];
        }
        
        [self.postParams addObject:[SeaHttpRequestParam requestParamWithFilePath:filePath key:key]];
    }
}

/**添加文件上传 参数名不能重复，会删除已存在的参数
 *@param filePath 本地文件全路径
 *@param 参数名
 */
- (void)setFile:(NSString*)filePath forKey:(NSString*)key
{
    [self removeFileForKey:key];
    [self addFile:filePath forKey:key];
}

/**通过NSDictionary 添加POST请求参数
 *@param dic 含有POST请求参数的字典
 */
- (void)addPostValueFromDictionary:(NSDictionary*) dic
{
    if(dic.count > 0)
    {
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
           
            [self addPostValue:obj forKey:key];
        }];
    }
}

/**添加多个文件 同一个参数
 *@param files 数组元素是文件本地路径 NSString
 *@param fileKey 文件参数名
 *@param
 */
- (void)addFileFromFiles:(NSArray*) files fileKey:(NSString*) fileKey
{
    if(files.count > 0 && fileKey != nil)
    {
        for(NSString *filePath in files)
        {
            [self addFile:filePath forKey:fileKey];
        }
    }
}

/**添加多个文件，不同的参数
 *@param dic 含有文件参数的字典
 */
- (void)addFileFromDictionary:(NSDictionary*) dic
{
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
       
        [self setFile:obj forKey:key];
    }];
}


#pragma mark- 删除 Post请求 参数

/**删除 post请求参数
 *@param key 参数名
 */
- (void)removePostValueForKey:(NSString*)key
{
    [self removeValueForKey:key paramType:SeaHttpRequestParamTypeDefault];
}

/**删除 要上传的文件参数
 *@param key 参数名
 */
- (void)removeFileForKey:(NSString*)key
{
    [self removeValueForKey:key paramType:SeaHttpRequestParamTypeFile];
}

/**删除参数
 *@param key 参数名
 *@param type 参数类型
 */
- (void)removeValueForKey:(NSString*)key paramType:(SeaHttpRequestParamType) type
{
    for(NSInteger i = 0;i < self.postParams.count;i ++)
    {
        SeaHttpRequestParam *param = [self.postParams objectAtIndex:i];
        if(param.paramType == type && [param.key isEqualToString:key])
        {
            [self.postParams removeObjectAtIndex:i];
            i --;
        }
    }
}

#pragma mark- 构建 postBody

/**判断是否有文件上传，文件上传不能使用 SeaURLRequestPostFormatURLEncoded
 */
- (BOOL)isExistFile
{
    BOOL exist = NO;
    for(SeaHttpRequestParam *param in self.postParams)
    {
        if(param.paramType == SeaHttpRequestParamTypeFile)
        {
            exist = YES;
            break;
        }
    }
    return exist;
}

/**构建post请求内容
 */
- (void)buildPostBody
{
    if(self.postParams.count == 0)
        return;
    //添加ecStore签名
    if(self.useECStoreSignature)
    {
        if(self.postParams == nil)
        {
            self.postParams = [NSMutableArray arrayWithCapacity:3];
        }
        
        [self.postParams sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            SeaHttpRequestParam *param1 = (SeaHttpRequestParam*)obj1;
            SeaHttpRequestParam *param2 = (SeaHttpRequestParam*)obj2;
            NSComparisonResult result = [param1.key compare:param2.key];
            return result == NSOrderedDescending;
        }];
        
        
        
        NSMutableString *signature = [NSMutableString string];
        
        NSString *lastKey = @"";
        
        for (SeaHttpRequestParam *param in self.postParams)
        {
            NSString *key = nil;
            NSString *value = nil;
            switch (param.paramType)
            {
                case SeaHttpRequestParamTypeDefault:
                {
                    key = param.key;
                    
                    //如果出现连续相同的参数key，则使用它的下标签名，如 a[0]=1&a[1]=2，a[1]签名的使用使用1，而不是使用a1
                    NSInteger index = [key rangeOfString:@"["].location;
                    
                    if(index != NSNotFound)
                    {
                        NSString *theKey = [key substringToIndex:index];
                        
                        if([theKey isEqualToString:lastKey])
                        {
                            key = [key substringFromIndex:index];
                        }
                        
                        lastKey = theKey;
                    }
                    
                    key = [key stringByReplacingOccurrencesOfString:@"[" withString:@""];
                    key = [key stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    
                    value = [NSString stringWithFormat:@"%@", param.value];
                }
                    break;
                case SeaHttpRequestParamTypeFile :
                {
                    key = @"";
                    value = @"";
                }
            }
            
            [signature appendFormat:@"%@%@", key, value];
        }
        NSLog(@"sign is %@",signature);
        
        NSString *result = [NSString stringWithFormat:@"%@", signature];
    
        result = [[result md5] uppercaseString];
        result = [NSString stringWithFormat:@"%@%@",result,SeaNetworkSignatureToken];
        result = [[result md5] uppercaseString];
        
        [self.postParams addObject:[SeaHttpRequestParam requestParamWithValue:result key:@"sign"]];
    }
    
    self.request.HTTPMethod = SeaHttpRequestMethodPost;
    switch (self.postFormat)
    {
        case SeaURLRequestPostFormatURLEncoded :
        {
            if([self isExistFile])
            {
                self.postFormat = SeaURLRequestPostFormatMultipartFormData;
                [self bulidMultipartFormDataPostBody];
            }
            else
            {
                [self bulidURLEncodedPostBody];
            }
        }
            break;
        case SeaURLRequestPostFormatMultipartFormData :
        {
            [self bulidMultipartFormDataPostBody];
        }
            break;
    }
    
    
}

/**构建 默认格式的 post请求内容
 */
- (void)bulidURLEncodedPostBody
{
    //设置请求头
    [self.request setValue:[NSString stringWithFormat:@"%@; %@",SeaURLRequestURLEncodedString,  [self charset]] forHTTPHeaderField:SeaURLRequestContentType];
    
    NSMutableData *postData = [NSMutableData data];
    
    //设置请求body
    NSInteger i = 0;
    for(SeaHttpRequestParam *param in self.postParams)
    {
        if([param paramIsAvaliable])
        {
            ///如果是字符串要编码，防止包含特殊字符时，出现不可预料的问题
            NSString *value = (NSString*)param.value;
            if([value isKindOfClass:[NSString class]])
            {
                value = [NSString encodeString:value];
            }
            
            [postData appendData:
             [[NSString stringWithFormat:@"%@=%@%@", [NSString encodeString:param.key], value, i == self.postParams.count - 1 ? @"" : @"&"]
              dataUsingEncoding:NSUTF8StringEncoding]];
        }
        i ++;
    }
    
      _uploadSize = postData.length;
    
#if SeaURLConnectionLogConfig
    self.debugPostBodyString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"URLEncodedPostBody begin == \n%@\n URLEncodedPostBody end ===\n", self.debugPostBodyString);
#endif
    [self.request setValue:[NSString stringWithFormat:@"%ld", (long)postData.length] forHTTPHeaderField:@"Content-Length"];
    
 
    self.request.HTTPBody = postData;
   // self.request.HTTPBody = [@"method=mobileapi.passport.post_login&uname=15975443486&password=123456&date=2015-08-27 19:08:56&direct=true&sign=8EFD5EC8B7510BD42F6545761CBF5D74" dataUsingEncoding:NSUTF8StringEncoding];;
}

/**构建 表单格式的 post请求内容
 */
- (void)bulidMultipartFormDataPostBody
{
    //post body 边界
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    
     NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    
    
    NSString *contentType = [NSString stringWithFormat:@"%@; %@; boundary=%@", SeaURLRequestMultipartFormDataString, [self charset], stringBoundary];
    
    //设置请求头
    [self.request setValue:contentType forHTTPHeaderField:SeaURLRequestContentType];
    
    [self setupBodyOutStream];
    
    //设置边界
    [self appendPostBodyString:[NSString stringWithFormat:@"--%@\r\n",stringBoundary]];
    
    //每个参数项目的分隔符
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    
    //添加Body内容
    NSInteger i = 0;
    for(SeaHttpRequestParam *param in self.postParams)
    {
        if(![param paramIsAvaliable])
            continue;
        switch (param.paramType)
        {
            case SeaHttpRequestParamTypeDefault :
            {
                [self appendPostBodyString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param.key]];

                [self appendPostBodyData:param.NSDataValue];
            }
                break;
            case SeaHttpRequestParamTypeFile :
            {
                [self appendPostBodyString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", param.key, [(NSString*)param.value lastPathComponent]]];
                
                [self appendPostBodyString:[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", [SeaURLRequest mimeTypeForFileAtPath:(NSString*)param.value]]];
                [self appendPostBodyFromFile:(NSString*)param.value];
            }
                break;
        }
        i ++;
        
        //只有当当前参数项目不是最后一个 才添加分隔符
        if(i != self.postParams.count)
        {
            [self appendPostBodyString:endItemBoundary];
        }
    }
    
    //添加body末尾
    [self appendPostBodyString:[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary]];
    
    //设置请求头内容长度
    long long fileSize = [[[[NSFileManager alloc] init] attributesOfItemAtPath:self.uploadTemporaryPath error:nil] fileSize];

    
    [self.request setValue:[NSString stringWithFormat:@"%lld", fileSize] forHTTPHeaderField:@"Content-Length"];
    
    self.request.HTTPBodyStream = [NSInputStream inputStreamWithFileAtPath:self.uploadTemporaryPath];
    
    [self.bodyOutputStream close];
    self.bodyOutputStream = nil;
    _uploadSize = fileSize;
    
#if SeaURLConnectionLogConfig
   // NSLog(@"file contene %@", [[NSString alloc] initWithContentsOfFile:self.uploadTemporaryPath encoding:NSUTF8StringEncoding error:nil]);
    NSLog(@"MultipartFormDataPostBody begin == \n file size %lld\n %@\n MultipartFormDataPostBody end ===\n", fileSize, self.debugPostBodyString);
#endif
}

//字符集
- (NSString*)charset
{
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return [NSString stringWithFormat:@"%@=%@", SeaURLRequestCharset, charset];
}

//添加post 字符串
- (void)appendPostBodyString:(NSString*) string
{
    [self appendPostBodyData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

//添加post 二进制数据
- (void)appendPostBodyData:(NSData*) data
{
#if SeaURLConnectionLogConfig
    if(self.debugPostBodyString == nil)
        self.debugPostBodyString = @"";
    
    self.debugPostBodyString = [self.debugPostBodyString stringByAppendingString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
#endif
    
    [self.bodyOutputStream write:[data bytes] maxLength:[data length]];
}

//从文件中添加post数据
- (void)appendPostBodyFromFile:(NSString*) filePath
{
    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:filePath];
    [inputStream open];
    
    NSInteger bytesDidRead;
    while ([inputStream hasBytesAvailable])
    {
        //每次读取 256kb
        uint8_t buffer[1024 * 256];
        bytesDidRead = [inputStream read:buffer maxLength:sizeof(buffer)];
        
        //判断是否已读完
        if(bytesDidRead == 0)
        {
            break;
        }
        
        //把内容写入文件
        [self.bodyOutputStream write:buffer maxLength:bytesDidRead];
    }
    
    [inputStream close];
}

//设置输出流
- (void)setupBodyOutStream
{
    if(!self.bodyOutputStream)
    {
        //创建临时文件
        self.uploadTemporaryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]];
        self.bodyOutputStream = [NSOutputStream outputStreamToFileAtPath:self.uploadTemporaryPath append:NO];
        [self.bodyOutputStream open];
    }
}

#pragma mark- mime-type detection

/**通过文件路径获取 contentType 
 *@param path 本地文件路径
 *@return 表单上传文件的 contentType
 */
+ (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path])
    {
        return nil;
    }
    
    // Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    
    CFRelease(UTI);
    
    if (!MIMEType)
    {
        return @"application/octet-stream";
    }
    
    return CFBridgingRelease(MIMEType);
}

@end
