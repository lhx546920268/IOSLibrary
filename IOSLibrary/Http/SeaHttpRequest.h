//
//  SeaHttpRequest.h

//

#import <Foundation/Foundation.h>
#import "SeaHttpInterface.h"
#import "SeaHttpOperation.h"

@class SeaHttpRequest;

///使用block时，如果block有使用成员变量，属性时要用 __weak修饰，防止循环引用

/**完成回调 使用属性中的 identifier 请求标识 来识别是哪个请求
 *@param request 网络请求对象
 */
typedef void(^SeaHttpRequestCompletionHandler)(SeaHttpRequest *request);

/**进度回调 showUploadProgress 必须设置为 YES，showDownloadProgress 必须设置为 YES，在主线程上调用，使用属性中的 identifier 请求标识 来识别是哪个请求
 *@param request 网络请求对象
 *@param uploadProgress 上传进度，范围 0 ~ 1.0
 *@param downloadProgress 下载进度，范围 0 ~ 1.0
 */
typedef void(^SeaHttpRequestProgressHandler)(SeaHttpRequest *request, float uploadProgress, float downloadProgress);

/**http请求代理
 */
@protocol SeaHttpRequestDelegate <NSObject>


///以下代理可使用 request属性中的 identifier 请求标识 来识别是哪个请求

/**请求失败
 */
- (void)httpRequestDidFail:(SeaHttpRequest*) request;

/**请求完成
 */
- (void)httpRequestDidFinish:(SeaHttpRequest *)request;

@optional

/**更新进度条
 */
- (void)httpRequest:(SeaHttpRequest *)request didUpdateUploadProgress:(float) progress downloadProgress:(float) downlodProgress;

@end


/**http请求 一次只能执行一次请求，如果要并发执行多个请求，请使用 SeaNetworkQueue
 */
@interface SeaHttpRequest : NSObject

@property(nonatomic,weak) id<SeaHttpRequestDelegate> delegate;

@property(nonatomic, readonly) __kindof SeaHttpOperation *operation;

/**超时时间 default is '60.0'
 */
@property(nonatomic,assign) NSTimeInterval timeOut;

/**缓存协议 default is 'NSURLRequestUseProtocolCachePolicy'
 */
@property(nonatomic,assign) NSURLRequestCachePolicy cachePolicy;

/**是否显示上传进度 default is 'NO'
 */
@property(nonatomic,assign) BOOL showUploadProgress;

/**是否显示下载进度 default is 'NO'
 */
@property(nonatomic,assign) BOOL showDownloadProgress;

/**请求标识
 */
@property(nonatomic,copy) NSString *identifier;

/**请求完成回调
 */
@property(nonatomic,copy) SeaHttpRequestCompletionHandler completionHandler;

/**进度回调
 */
@property(nonatomic,copy) SeaHttpRequestProgressHandler progressHandler;

/**是否正在请
 */
@property(nonatomic,readonly) BOOL requesting;

//构造方法
- (id)init;
- (id)initWithDelegate:(id<SeaHttpRequestDelegate>) delegate;
- (id)initWithDelegate:(id<SeaHttpRequestDelegate>)delegate identifier:(NSString*) identifier;

#pragma mark- get请求

/**get请求 使用默认的缓存协议
 *@param url get请求路径
 */
- (void)downloadWithURL:(NSString*) url;

#pragma mark- post请求

/**post请求 使用默认的缓存协议
 *@param url post请求路径
 *@param dic 请求参数
 */
- (void)downloadWithURL:(NSString*) url dic:(NSDictionary*) dic;

/**可上传文件的post请求 文件参数不能重复
 *@param url post请求路径
 *@param paraDic 请求参数
 *@param fileDic 文件参数 value可以为数组，一个key多个文件
 */
- (void)downloadWithURL:(NSString *)url paraDic:(NSDictionary*) paraDic fileDic:(NSDictionary*) fileDic;


/**post请求 使用默认的缓存协议
 *@param operation 工具类
 */
- (void)downloadWithOperation:(SeaHttpOperation*) operation;

#pragma mark- cancel

/**取消 请求
 */
- (void)cancelRequest;


@end
