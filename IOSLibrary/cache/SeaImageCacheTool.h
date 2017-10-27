//
//  SeaImageCacheTool.h
//  Sea
//
//
//

#import <UIKit/UIKit.h>
#import "SeaImageCacheToolOperation.h"

///图片路径属性
static char SeaImageCacheToolImageURL;

///图片路径字典，object是图片路径 NSString ，key是 NSNumber UIControlState
static char SeaImageCacheToolImageURLDictionary;

///背景图片路径字典 object是图片路径 NSString ，key是 NSNumber UIControlState
static char SeaImageCacheToolBackgroundImageURLDictionary;

///图片缩略图
static char SeaImageCacheToolThumbnailSize;

///是否显示加载指示器
static char SeaImageCacheToolShowLoadingActivity;

///预载背景颜色
static char SeaImageCacheToolPlaceHolderColor;

///本来的背景颜色
static char SeaImageCacheToolOriginBackgroundColor;

///预载图
static char SeaImageCacheToolPlaceHolderImage;

///加载指示器
static char SeaImageCacheToolActivity;

///加载指示器样式
static char SeaImageCacheToolActivityStyle;

///是否正在加载
static char SeaImageCacheToolLoading;

@class SeaImageCacheTool;

/**图片异步加载及缓存器 代理
 */
@protocol SeaImageCacheToolDelegate <NSObject>

@optional

/**收到内存警告
 */
- (void)imageCacheToolDidReceiveMemoryWarning:(SeaImageCacheTool*) cacheTool;

@end

/**图片异步加载及缓存器
 */
@interface SeaImageCacheTool : NSObject

/**使用代理时，必须在代理的dealloc之前把 delegate置nil,否则容易造成程序崩溃
 */
@property(nonatomic,weak) id<SeaImageCacheToolDelegate> delegate;

/**图片加载超时时间 default is '25.0'
 */
@property(nonatomic,assign) NSTimeInterval timeoutSeconds;

/**缓存路径
 */
@property(nonatomic,copy,readonly) NSString *cachePath;

/**缓存图片保存在本地的最大时间，default is '60 * 60 * 24 * 7'，一周
 */
@property(nonatomic,assign) NSTimeInterval diskCacheExpirationTimeInterval;

#pragma mark- single instance

/**单例
 */
+ (SeaImageCacheTool*)sharedInstance;

/**保存在内存中的图片 key 是图片路径，value 是UIImage对象
 */
+ (NSCache*)defaultCache;

/**相关下载是否正在进行中
 *@param url 正在请求的url
 */
- (BOOL)isRequestingWithURL:(NSString*) url;

/**批量取消相关下载
 *@param urls 数组元素是url, NSString 对象
 */
- (void)cancelDownloadWithURLs:(NSArray*) urls;

/**取消单个下载
 *@param url 正在请求的url
 *@param target 下载图片的对象，如UIImageView
 */
- (void)cancelDownloadWithURL:(NSString *)url target:(id) target;

/**添加下载完成回调
 *@param completion 下载完成回调
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 *@param target 下载图片的对象，如UIImageView
 *@param url 图片路径
 */
- (void)addCompletion:(SeaImageCacheToolCompletionHandler) completion thumbnailSize:(CGSize) size target:(id) target forURL:(NSString*) url;

/**添加下载进度回调
 *@param progressHandler 进度回调
 *@param url 图片路径
 *@param target 下载图片的对象，如UIImageView
 */
- (void)addProgressHandler:(SeaImageCacheToolProgressHandler) progressHandler forURL:(NSString *)url target:(id) target;

/**获取图片 先在内存中获取，没有则在缓存文件中查找，没有才通过http请求下载图片
 *@param url 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 *@param completion 图片加载完成回调
 *@param target 下载图片的对象，如UIImageView
 */
- (void)getImageWithURL:(NSString*) url thumbnailSize:(CGSize) size completion:(SeaImageCacheToolCompletionHandler) completion target:(id) target;

/**缓存图片
 *@param image 要缓存的图片
 *@param url 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不缓存缩略图
 *@param flag 是否需要保存到内存中
 *@return 如果保存在内存，则返回对应的图片，否则返回nil
 */
- (UIImage*)cacheImage:(UIImage*) image withURL:(NSString*) url thumbnailSize:(CGSize) size saveToMemory:(BOOL) flag;

/**缓存图片文件
 *@param imageFile 要缓存的图片文件
 *@param url 图片路径
 */
- (void)cacheImageFile:(NSString*) imageFile withURL:(NSString*) url;

/**通过图片路径获取本地缓存图片，如果没有则返回nil
 *@param url 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 */
- (UIImage*)imageFromCacheWithURL:(NSString*) url thumbnailSize:(CGSize) size;

/**通过图片路径获取内存图片，如果没有则返回nil
 *@param url 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 */
- (UIImage*)imageFromMemoryWithURL:(NSString*) url thumbnailSize:(CGSize) size;

/**删除图片缓存
 *@param urls 数组元素是 网络图片路径 NSString对象
 */
- (void)removeCacheImageWithURL:(NSArray*) urls;

/**获取图片缓存文件路径
 *@return 图片缓存路径
 */
- (NSString*)getCachePath;

/**清除所有的缓存图片
 *@param completion 清除完成回调
 */
- (void)clearCacheImageWithCompletion:(void(^)(void)) completion;

/**清除已过期的缓存图片
 *@param completion 清除完成回调
 */
- (void)clearExpirationCacheImageWithCompletion:(void(^)(void)) completion;

/**计算缓存大小
 *@param completion 计算完成回调 size,缓存大小，字节
 */
- (void)caculateCacheSizeWithCompletion:(void(^)(unsigned long long size)) completion;

#pragma mark- Class method

/**把字节格式化
 *@param bytes 要格式化的字节
 *@return 大小字符串，如 1.1M
 */
+ (NSString*)formatBytes:(long long) bytes;

@end
