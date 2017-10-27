//
//  SeaURLRequest.h

//

#import <Foundation/Foundation.h>
#import "SeaHttpInterface.h"

///打印postBody信息，release产品自动改为不打印body信息
#ifndef __OPTIMIZE__
  #define SeaURLConnectionLogConfig 1
#else
  #define SeaURLConnectionLogConfig 0
#endif

/**postBody数据格式
 */
typedef NS_ENUM(NSInteger, SeaURLRequestPostFormat)
{
    ///默认
    SeaURLRequestPostFormatURLEncoded = 0,
    
    ///表单
    SeaURLRequestPostFormatMultipartFormData = 1,
};

/**使用系统 http请求
 */
@interface SeaURLRequest : NSObject

/**postBody数据格式 default is 'SeaURLRequestPostFormatURLEncoded',如果有文件需要上传，会必须设置为 SeaURLRequestPostFormatMultipartFormData
 */
@property(nonatomic,assign) SeaURLRequestPostFormat postFormat;

/**网络请求封装
 */
@property(nonatomic,readonly,retain) NSMutableURLRequest *request;

/**要上传的数据大小 必须要 buildPostBody 后才有，get请求为0
 */
@property(nonatomic,readonly) long long uploadSize;

/**是否使用ECStore服务器的签名 default is 'YES'，post请求使用
 */
@property(nonatomic,assign) BOOL useECStoreSignature;

/**请求的URL
 */
@property(nonatomic,readonly) NSString *URL;

#pragma mark- init

/** initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0
 */
- (id)initWithURL:(NSString*) URL;

/** initWithURL:URL cachePolicy:cachePolicy timeoutInterval:60.0
 */
- (id)initWithURL:(NSString*)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy;

/**构造方法
 *@param URL 请求路径
 *@param cachePolicy http缓存协议
 *@param timeoutInterval 请求超时时间 秒
 *@return 一个实例
 */
- (id)initWithURL:(NSString*)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval;

#pragma mark- class method

/** initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0
 */
+ (id)requestWithURL:(NSString*) URL;

/** initWithURL:URL cachePolicy:cachePolicy timeoutInterval:60.0
 */
+ (id)requestWithURL:(NSString *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy;

/** initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval
 */
+ (id)requestWithURL:(NSString *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy imeoutInterval:(NSTimeInterval)timeoutInterval;


#pragma mark- 添加 Post请求 参数

//如果请求参数不为空，会自动设置请求方法为 POST

/**添加 post请求参数 参数名可以重复
 *@param value 参数值，支持 NSString,NSNumber, NSData
 *@param key 参数名
 */
- (void)addPostValue:(id<NSObject>)value forKey:(NSString*)key;

/**添加 post请求参数 参数名不能重复，会删除已存在的参数
 *@param value 参数值，支持 NSString,NSNumber, NSData
 *@param key 参数名
 */
- (void)setPostValue:(id<NSObject>)value forKey:(NSString*)key;

/**添加文件上传 参数名可以重复
 *@param filePath 本地文件全路径
 *@param key 参数名
 */
- (void)addFile:(NSString*)filePath forKey:(NSString*)key;

/**添加文件上传 参数名不能重复，会删除已存在的参数
 *@param filePath 本地文件全路径
 *@param key 参数名
 */
- (void)setFile:(NSString*)filePath forKey:(NSString*)key;

/**通过NSDictionary 添加POST请求参数
 *@param dic 含有POST请求参数的字典
 */
- (void)addPostValueFromDictionary:(NSDictionary*) dic;

/**添加多个文件 同一个参数
 *@param files 数组元素是文件本地路径 NSString
 *@param fileKey 文件参数名
 */
- (void)addFileFromFiles:(NSArray*) files fileKey:(NSString*) fileKey;

/**添加多个文件，不同的参数
 *@param dic 含有文件参数的字典
 */
- (void)addFileFromDictionary:(NSDictionary*) dic;

#pragma mark- 删除 Post请求 参数

/**删除 post请求参数
 *@param key 参数名
 */
- (void)removePostValueForKey:(NSString*)key;

/**删除 要上传的文件参数
 *@param key 参数名
 */
- (void)removeFileForKey:(NSString*)key;

#pragma mark- 构建 postBody

/**构建post请求内容
 */
- (void)buildPostBody;

@end
