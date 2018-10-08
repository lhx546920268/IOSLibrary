//
//  SeaHttpBuilder.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/20.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaHttpBuilder.h"
#import "SeaHttpParam.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSString+Utils.h"
#import "SeaHttpTask.h"
#import "NSJSONSerialization+Utils.h"

//postBody 默认格式
static NSString *const SeaURLEncoded = @"application/x-www-form-urlencoded";

///json方式上传
static NSString *const SeaApplicationJSON = @"application/json";

//postBody 表单格式
static NSString *const SeaMultipartFormData = @"multipart/form-data";

//字符集
static NSString *const SeaCharset = @"charset";

//内容类型
static NSString *const SeaContentType = @"Content-Type";

//定义

@interface SeaHttpBuilder ()

//请求参数 数组元素是 SeaHttpRequestParam
@property(nonatomic,strong) NSMutableArray *params;

//body 输出流，把body写入文件
@property(nonatomic,strong) NSOutputStream *bodyOutputStream;

//body 上传临时文件
@property(nonatomic,copy) NSString *uploadTemporaryPath;

#if SeaHttpLogConfig
//debug模式的postBody
@property(nonatomic,strong) NSString *debugPostBodyString;

#endif

@end

@implementation SeaHttpBuilder

@synthesize URL = _URL;
@synthesize request = _request;

#pragma mark- init

- (instancetype)initWithURL:(NSString*)URL
{
    self = [super init];
    if(self){
        _URL = [URL copy];
        self.postFormat = SeaPostFormatURLEncoded;
    }
    return self;
}

+ (instancetype)buildertWithURL:(NSString*) URL
{
    return [[SeaHttpBuilder alloc] initWithURL:URL];
}

#pragma mark- dealloc

- (void)dealloc
{
    [_bodyOutputStream close];
    
    //删除临时文件
    if(_uploadTemporaryPath){
        [[[NSFileManager alloc] init] removeItemAtPath:_uploadTemporaryPath error:nil];
    }
}

#pragma mark- property

- (NSString*)URL
{
    return _URL;
}

- (NSURLRequest*)request
{
    _request = [NSMutableURLRequest new];
    
    NSString *httpMethod = self.httpMethod;
    if([NSString isEmpty:httpMethod]){
        httpMethod = self.params.count > 0 ? SeaHttpMethodPOST : SeaHttpMethodGET;
    }
    
    //上传文件必须用post
    if([self isExistFile]){
        httpMethod = SeaHttpMethodPOST;
        self.postFormat = SeaPostFormatMultipartFormData;
    }
    
    NSAssert([httpMethod isEqualToString:SeaHttpMethodGET] || [httpMethod isEqualToString:SeaHttpMethodPOST], @"HTTPMethod 必须为 GET 或 POST");
    
    _request.HTTPMethod = httpMethod;
    
    if([httpMethod isEqualToString:SeaHttpMethodGET]){
        NSString *params = [self buildGetBody];
        if([_URL hasSuffix:@"?"]){
            _request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _URL, params]];
        }else{
            _request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", _URL, params]];
        }
    }else{
        _request.URL = [NSURL URLWithString:_URL];
        [self buildPostBody];
    }
    
    //如果有额外的cookie 则添加
    if(self.cookies.count > 0){
        [_request addValue:[[NSHTTPCookie requestHeaderFieldsWithCookies:self.cookies] objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    }

    if(self.headers.count > 0){
        [self.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop){
            [self->_request addValue:value forHTTPHeaderField:key];
        }];
    }
    
    return _request;
}

#pragma mark- 添加 请求 参数

//如果请求参数不为空，会自动设置请求方法为 POST

/**添加 请求参数 参数名可以重复
 *@param value 参数值，支持 NSString,NSNumber, NSData
 *@param key 参数名
 */
- (void)addValue:(id<NSObject>)value forKey:(NSString*)key
{
    if(!self.params){
        self.params = [NSMutableArray array];
    }
    
    [self.params addObject:[SeaHttpParam paramWithValue:value key:key]];
}

/**添加 请求参数 参数名不能重复，会删除已存在的参数
 *@param value 参数值，支持 NSString,NSNumber, NSData
 *@param key 参数名
 */
- (void)setValue:(id<NSObject>)value forKey:(NSString*)key
{
    [self removeValueForKey:key];
    
    [self addValue:value forKey:key];
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
    if([[[NSFileManager alloc] init] fileExistsAtPath:filePath isDirectory:nil]){
        if(!self.params){
            self.params = [NSMutableArray array];
        }
        
        [self.params addObject:[SeaHttpParam paramWithFilePath:filePath key:key]];
    }
}

/**添加文件上传 参数名不能重复，会删除已存在的参数
 *@param filePath 本地文件全路径
 *@param key 参数名
 */
- (void)setFile:(NSString*)filePath forKey:(NSString*)key
{
    [self removeFileForKey:key];
    [self addFile:filePath forKey:key];
}

/**通过NSDictionary 添加请求参数
 *@param dic 含有请求参数的字典
 */
- (void)addValuesFromDictionary:(NSDictionary<NSString*, id<NSObject>>*) dic
{
    if(dic.count > 0){
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            
            [self addValue:obj forKey:key];
        }];
    }
}

/**添加多个文件 同一个参数
 *@param files 数组元素是文件本地路径 NSString
 *@param fileKey 文件参数名
 */
- (void)addFiles:(NSArray<NSString*>*) files fileKey:(NSString*) fileKey
{
    if(files.count > 0 && fileKey != nil){
        for(NSString *filePath in files){
            [self addFile:filePath forKey:fileKey];
        }
    }
}

/**添加多个文件，不同的参数
 *@param dic 含有文件参数的字典
 */
- (void)addFilesFromDictionary:(NSDictionary<NSString*, NSString*>*) dic
{
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        
        [self setFile:obj forKey:key];
    }];
}


#pragma mark- 删除 请求 参数

/**删除 请求参数
 *@param key 参数名
 */
- (void)removeValueForKey:(NSString*)key
{
    [self removeValueForKey:key paramType:SeaHttpParamTypeDefault];
}

/**删除 要上传的文件参数
 *@param key 参数名
 */
- (void)removeFileForKey:(NSString*)key
{
    [self removeValueForKey:key paramType:SeaHttpParamTypeFile];
}

/**删除参数
 *@param key 参数名
 *@param type 参数类型
 */
- (void)removeValueForKey:(NSString*)key paramType:(SeaHttpParamType) type
{
    for(NSInteger i = 0;i < self.params.count;i ++){
        SeaHttpParam *param = [self.params objectAtIndex:i];
        if(param.paramType == type && [param.key isEqualToString:key]){
            [self.params removeObjectAtIndex:i];
            i --;
        }
    }
}

#pragma mark- 构建 get 参数

///构建 get 请求参数
- (NSString*)buildGetBody
{
    NSInteger i = 0;
    NSMutableString *string = [NSMutableString string];
    for(SeaHttpParam *param in self.params){
        if([param paramIsAvaliable]){
            ///如果是字符串要编码，防止包含特殊字符时，出现不可预料的问题
            NSString *value = (NSString*)param.value;
            if([value isKindOfClass:[NSString class]]){
                value = [NSString sea_encodeStringWithUTF8:value];
            }
            
            [string appendFormat:@"%@=%@", [NSString sea_encodeStringWithUTF8:param.key], value];
            if(i != self.params.count - 1){
                [string appendString:@"&"];
            }
        }
        i ++;
    }
    
    return string;
}

#pragma mark- 构建 postBody

/**判断是否有文件上传，文件上传不能使用 SeaURLRequestPostFormatURLEncoded
 */
- (BOOL)isExistFile
{
    BOOL exist = NO;
    for(SeaHttpParam *param in self.params){
        if(param.paramType == SeaHttpParamTypeFile){
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
    if(self.params.count == 0)
        return;
    
    switch (self.postFormat){
        case SeaPostFormatURLEncoded : {
            [self bulidURLEncodedPostBody];
        }
            break;
        case SeaPostFormatMultipartFormData : {
            [self bulidMultipartFormDataPostBody];
        }
            break;
        case SeaPostFormatJSON : {
            [self buildJSONPostBody];
        }
            break;
    }
}

/**构建 默认格式的 post请求内容
 */
- (void)bulidURLEncodedPostBody
{
    //设置请求头
    [_request setValue:[NSString stringWithFormat:@"%@; %@",SeaURLEncoded,  [self charset]] forHTTPHeaderField:SeaContentType];
    
    NSMutableData *postData = [NSMutableData data];
    
    //设置请求body
    NSInteger i = 0;
    for(SeaHttpParam *param in self.params){
        if([param paramIsAvaliable]){
            ///如果是字符串要编码，防止包含特殊字符时，出现不可预料的问题
            NSString *value = (NSString*)param.value;
            if([value isKindOfClass:[NSString class]]){
                value = [NSString sea_encodeStringWithUTF8:value];
            }
            
            [postData appendData:
             [[NSString stringWithFormat:@"%@=%@%@", [NSString sea_encodeStringWithUTF8:param.key], value, i == self.params.count - 1 ? @"" : @"&"]
              dataUsingEncoding:NSUTF8StringEncoding]];
        }
        i ++;
    }
    
    _uploadSize = postData.length;
    
#if SeaHttpLogConfig
    if(postData.length < 200){
        self.debugPostBodyString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"URLEncodedPostBody begin == \n%@\n URLEncodedPostBody end ===\n", self.debugPostBodyString);
    }
#endif
    [_request setValue:[NSString stringWithFormat:@"%ld", (long)postData.length] forHTTPHeaderField:@"Content-Length"];
    
    
    _request.HTTPBody = postData;
}

/**构建json
 */
- (void)buildJSONPostBody
{
    //设置请求头
    [_request setValue:[NSString stringWithFormat:@"%@; %@",SeaApplicationJSON,  [self charset]] forHTTPHeaderField:SeaContentType];
    
    //设置请求body
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:self.params.count];
    
    for(SeaHttpParam *param in self.params){
        if([param paramIsAvaliable]){
            ///如果是字符串要编码，防止包含特殊字符时，出现不可预料的问题
            NSString *value = (NSString*)param.value;
            if([value isKindOfClass:[NSString class]]){
                value = [NSString sea_encodeStringWithUTF8:value];
            }
            
            [dic setObject:value forKey:param.key];
        }
    }
    
    NSData *data = [NSJSONSerialization sea_dataFromObject:dic];
    
#if SeaHttpLogConfig
    self.debugPostBodyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"application/json begin == \n%@\n application/json end ===\n", self.debugPostBodyString);
#endif
    [_request setValue:[NSString stringWithFormat:@"%ld", (long)data.length] forHTTPHeaderField:@"Content-Length"];
    
    
    _request.HTTPBody = data;
}

/**构建 表单格式的 post请求内容
 */
- (void)bulidMultipartFormDataPostBody
{
    //post body 边界
    NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@", [[NSUUID UUID] UUIDString]];
    
    //设置请求头
    [_request setValue:[NSString stringWithFormat:@"%@; %@; boundary=%@", SeaMultipartFormData, [self charset], stringBoundary] forHTTPHeaderField:SeaContentType];
    
    [self setupBodyOutStream];
    
    //设置边界
    [self appendPostBodyString:[NSString stringWithFormat:@"--%@\r\n",stringBoundary]];
    
    //每个参数项目的分隔符
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    
    //添加Body内容
    NSInteger i = 0;
    for(SeaHttpParam *param in self.params){
        if(![param paramIsAvaliable])
            continue;
        switch (param.paramType){
            case SeaHttpParamTypeDefault : {
                [self appendPostBodyString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param.key]];
                
                [self appendPostBodyData:param.NSDataValue];
            }
                break;
            case SeaHttpParamTypeFile : {
                [self appendPostBodyString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", param.key, [(NSString*)param.value lastPathComponent]]];
                
                [self appendPostBodyString:[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", [SeaHttpBuilder mimeTypeForFileAtPath:(NSString*)param.value]]];
                [self appendPostBodyFromFile:(NSString*)param.value];
            }
                break;
        }
        i ++;
        
        //只有当当前参数项目不是最后一个 才添加分隔符
        if(i != self.params.count){
            [self appendPostBodyString:endItemBoundary];
        }
    }
    
    //添加body末尾
    [self appendPostBodyString:[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary]];
    
    //设置请求头内容长度
    long long fileSize = [[[[NSFileManager alloc] init] attributesOfItemAtPath:self.uploadTemporaryPath error:nil] fileSize];
    
    
    [_request setValue:[NSString stringWithFormat:@"%lld", fileSize] forHTTPHeaderField:@"Content-Length"];
    
    _request.HTTPBodyStream = [NSInputStream inputStreamWithFileAtPath:self.uploadTemporaryPath];
    
    [self.bodyOutputStream close];
    self.bodyOutputStream = nil;
    _uploadSize = fileSize;
    
#if SeaHttpLogConfig
    // NSLog(@"file contene %@", [[NSString alloc] initWithContentsOfFile:self.uploadTemporaryPath encoding:NSUTF8StringEncoding error:nil]);
    NSLog(@"MultipartFormDataPostBody begin == \n file size %lld\n %@\n MultipartFormDataPostBody end ===\n", fileSize, self.debugPostBodyString);
#endif
}

//字符集
- (NSString*)charset
{
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return [NSString stringWithFormat:@"%@=%@", SeaCharset, charset];
}

//添加post 字符串
- (void)appendPostBodyString:(NSString*) string
{
    [self appendPostBodyData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

//添加post 二进制数据
- (void)appendPostBodyData:(NSData*) data
{
#if SeaHttpLogConfig
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
    while ([inputStream hasBytesAvailable]){
        //每次读取 256kb
        uint8_t buffer[1024 * 256];
        bytesDidRead = [inputStream read:buffer maxLength:sizeof(buffer)];
        
        //判断是否已读完
        if(bytesDidRead == 0){
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
    if(!self.bodyOutputStream){
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
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]){
        return nil;
    }
    
    // Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    
    CFRelease(UTI);
    
    if (!MIMEType){
        return @"application/octet-stream";
    }
    
    return CFBridgingRelease(MIMEType);
}

@end
