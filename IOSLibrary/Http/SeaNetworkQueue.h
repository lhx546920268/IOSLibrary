//
//  SeaNetworkQueue.h

//

#import <Foundation/Foundation.h>
#import "SeaHttpInterface.h"

@class SeaHttpOperation;

@class SeaNetworkQueue;

///使用block时，如果block有使用成员变量，属性时要用 __weak修饰，防止循环引用

/**完成回调
 *@param queue 请求队列
 *@param operation 来识别是哪个请求
 */
typedef void(^SeaNetworkQueueRequestCompletionHandler)(SeaNetworkQueue *queue, SeaHttpOperation *operation);

/**队列进度回调 showQueueProgress 必须设置为 YES，在主线程上调用
 *@param queue 网络请求对象
 *@param uploadProgress 上传进度，范围 0 ~ 1.0
 *@param downloadProgress 下载进度，范围 0 ~ 1.0
 */
typedef void(^SeaNetworkQueueProgressHandler)(SeaNetworkQueue *queue, float uploadProgress, float downloadProgress);

/**单个进度回调 showRequestProgress 必须设置为 YES，在主线程上调用
 *@param queue 网络请求对象
 *@param uploadProgress 上传进度，范围 0 ~ 1.0
 *@param downloadProgress 下载进度，范围 0 ~ 1.0
 *@param operation 来识别是哪个请求
 */
typedef void(^SeaNetworkQueueRequestProgressHandler)(SeaNetworkQueue *queue, float uploadProgress, float downloadProgress, SeaHttpOperation *operation);

/**整个队列请求完成
 *@param queue 请求队列
 */
typedef void(^SeaNetworkQueueCompletionHandler)(SeaNetworkQueue *queue);


/**网络请求队列代理
 */
@protocol SeaNetworkQueueDelegate <NSObject>

/**队列中的某个请求完成
 *@param operation 完成的数据
 */
- (void)networkQueue:(SeaNetworkQueue*) queue requestDidFinish:(SeaHttpOperation*) operation;

/**队列中的某个请求完成
 *@param operation 完成的数据
 */
- (void)networkQueue:(SeaNetworkQueue*) queue requestDidFail:(SeaHttpOperation*) operation;

/**队列请求完成
 */
- (void)networkQueueDidFinish:(SeaNetworkQueue*) queue;

@optional

/**更新某个请求的进度条
 */
- (void)networkQueue:(SeaNetworkQueue *)queue didUpdateUploadProgress:(float) progress downloadProgress:(float) downlodProgress operation:(SeaHttpOperation*) operation;

/**更新整个队列的进度条
 */
- (void)networkQueue:(SeaNetworkQueue *)queue didUpdateQueueUploadProgress:(float) progress downloadProgress:(float) downlodProgress;

@end

/**网络请求队列
 */
@interface SeaNetworkQueue : NSObject

/**是否取消所有请求当有一个请求失败时 default is 'YES'
 */
@property(nonatomic,assign) BOOL shouldCancelAllRequestWhenOneFail;

/**是否有个请求失败
 */
@property(nonatomic,assign) BOOL hasOneFail;

/**请求的最大并发数量
 */
@property(nonatomic,assign) NSInteger maxConcurrentOperationCount;

/**是否显示每个请求的进度 default is 'NO'
 */
@property(nonatomic,assign) BOOL showRequestProgress;

/**是否显示整个队列的请求进度 default is 'MP'
 */
@property(nonatomic,assign) BOOL showQueueProgress;

/**要下载的内容的总长度
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

/**请求完成回调
 */
@property(nonatomic,copy) SeaNetworkQueueRequestCompletionHandler requestCompletionHandler;

/**单个请求进度回调
 */
@property(nonatomic,copy) SeaNetworkQueueRequestProgressHandler requestProgressHandler;

/**队列请求进度回调
 */
@property(nonatomic,copy) SeaNetworkQueueProgressHandler queueProgressHandler;

/**队列请求完成回调
 */
@property(nonatomic,copy) SeaNetworkQueueCompletionHandler queueCompletionHandler;

/**构造方法
 *@param delegate 队列代理
 *@return 一个实例
 */
- (id)initWithDelegate:(id<SeaNetworkQueueDelegate>) delegate;

/**添加请求 如 [addRequestWithURL:url param:nil identifier:identifier]
 */
- (void)addRequestWithURL:(NSString*) url identifier:(NSString*) identifier;

/**添加请求
 *@param url 请求地址
 *@param param 请求参数，如果是get请求，传nil, 如果post请求没有参数 传一个初始化的 NSDictionary
 *@param identifier 请求标识 不能为nil
 */
- (void)addRequestWithURL:(NSString*) url param:(NSDictionary*) param identifier:(NSString*) identifier;

/**添加请求
 *@param url 请求地址
 *@param param 请求参数，如果是get请求，传nil，如果post请求没有参数 传一个初始化的 NSDictionary
 *@param files 文件路径，value 可以是 数组
 *@param identifier 请求标识
 */
- (void)addRequestWithURL:(NSString*) url param:(NSDictionary*) param files:(NSDictionary*) files identifier:(NSString*) identifier;

/**添加请求
 *@param operation 工具类
 */
- (void)addRequestWithOperation:(SeaHttpOperation*) operation;

/**开始下载
 */
- (void)startDownload;

/**取消某个请求
 *@param identifier 请求标识 不能为nil
 */
- (void)cancelRequestWithIdentifier:(NSString*) identifier;

/**取消所有请求
 */
- (void)cancelAllRequest;

/**相关下载是否正在进行中
 *@param identifier 请求标识
 */
- (BOOL)isRequestingWithIdentifier:(NSString*) identifier;

/**重新设置
 */
- (void)reset;

@end
