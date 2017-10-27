//
//  SeaURLConnection.h

//

#import <Foundation/Foundation.h>
#import "SeaHttpInterface.h"
#import "SeaURLRequest.h"


@class SeaURLConnection;

///使用block时，如果block有使用成员变量，属性时要用 __weak修饰，防止循环引用

/**完成回调
 *@param conn 网络请求对象
 */
typedef void(^SeaURLConnectionCompletionHandler)(SeaURLConnection *conn);

/**进度回调 showUploadProgress 必须设置为 YES，showDownloadProgress 必须设置为 YES，在主线程上调用
 *@param conn 网络请求对象
 * 使用conn中的属性 uploadProgress 和 downloadProgress
 */
typedef void(^SeaURLConnectionProgressHandler)(SeaURLConnection *conn);


/**系统http请求链接代理
 */
@protocol SeaURLConnectionDelegate <NSObject>

@optional

/**加载完成
 *@param conn 当前请求
 */
- (void)connectionDidFinishLoading:(SeaURLConnection*) conn;

/**加载失败
 *@param conn 当前请求
 */
- (void)connectionDidFail:(SeaURLConnection *) conn;

/**上传进度 showUploadProgress 必须设置为 YES，在主线程上调用 使用conn中的属性 uploadProgress 和 downloadProgress
 *@param conn 当前请求
 */
- (void)connectionDidUpdateProgress:(SeaURLConnection *)conn;

/**得到要下载的数据大小
 */
- (void)connectionDidGetDownloadSize:(SeaURLConnection*) conn;

/**得到要上传的数据大小
 */
- (void)connectionDidGetUploaddSize:(SeaURLConnection*) conn;

@end

/**系统http请求链接，该对象不能重复使用，如果要重复使用，请使用 SeaHttpRequest，
 */
@interface SeaURLConnection : NSOperation

/**下载路径 default is 'nil'，如果已设置，下载完成后将会把文件移到这里
 */
@property(nonatomic,copy) NSString *downloadDestinationPath;

/**下载临时文件，下载的内容将保存在这里，default is 'nil',如果没有设置，下载后的数据将保存在内存中
 */
@property(nonatomic,copy) NSString *downloadTemporayPath;

/**是否支持断点下载，default is 'NO'
 *@warning downloadTemporayPath必须设置已下载的文件路径，如果downloadTemporayPath为nil，或者该路径的文件不存在，将忽略此值，最好把deleteDownloadTemporaryPathAfterDealloc设置为NO
 */
@property(nonatomic,assign) BOOL supportBreakpointDownload;

/**请求返回的数据
 */
@property(nonatomic,readonly) NSData *responseData;

/**请求路径
 */
@property(nonatomic,readonly,strong) NSString *URL;

/**请求状态码，0表示请求成，否则请求失败
 */
@property(nonatomic,readonly) NSInteger errorCode;

/**对象释放后是否删除临时文件 default is 'YES'
 */
@property(nonatomic,assign) BOOL deleteDownloadTemporaryPathAfterDealloc;

/**是否显示上传进度 default is 'NO'
 */
@property(nonatomic,assign) BOOL showUploadProgress;

/**是否显示下载进度 default is 'NO'
 */
@property(nonatomic,assign) BOOL showDownloadProgress;

/**上传进度 范围 0 ~ 1.0
 */
@property(nonatomic,readonly) float uploadProgress;

/**下载进度 范围 0 ~ 1.0
 */
@property(nonatomic,readonly) float downloadProgress;

/**要下载的内容的总长度 当请求被响应之前为‘0’
 */
@property(nonatomic,readonly) long long totalBytesToDownload;

/**已下载的内容长度
 */
@property(nonatomic,readonly) long long totalBytesDidDownload;

/**要上传的内容的总长度
 */
@property(nonatomic,readonly) long long totalBytesToUpload;

/**已上传的内容长度
 */
@property(nonatomic,readonly) long long totalBytesDidUpload;

/**进入后台后是否继续加载，default is 'YES'
 */
@property(nonatomic,assign) BOOL continueDownloadAfterEnterBackground;

/**请求信息 default is 'nil'
 */
@property(nonatomic,strong) NSDictionary *userInfo;

/**请求
 */
@property(nonatomic,readonly) SeaURLRequest *request;

/**请求完成回调
 */
@property(nonatomic,copy) SeaURLConnectionCompletionHandler completionHandler;

/**进度回调
 */
@property(nonatomic,copy) SeaURLConnectionProgressHandler progressHandler;

/**标识
 */
@property(copy) NSString *name;

@property(nonatomic,weak) id<SeaURLConnectionDelegate> delegate;

/**初始化
 *@param delegate htpp代理
 *@param request http请求封装
 *@return 一个实例
 */
- (id)initWithDelegate:(id<SeaURLConnectionDelegate>) delegate request:(SeaURLRequest*) request;

/**不加入NSOperationQueue独立执行，必须使用此方法，不要调用start否则会阻塞部分UI
 */
- (void)startWithoutOperationQueue;

@end
