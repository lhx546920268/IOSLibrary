//
//  SeaImageCacheTool.h
//  Sea
//
//
//

#import <UIKit/UIKit.h>

/**
 图片加载完成回调
 
 @param image 成功后的图片，失败则为nil
 */
typedef void(^SeaImageCacheCompletionHandler)(UIImage *image);

/**
 图片加载进度回调
 
 @param progress 加载进度，使用 fractionCompleted 显示进度
 */
typedef void(^SeaImageCacheProgressHandler)(NSProgress *progress);


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

#pragma mark- download

/**相关下载是否正在进行中
 *@param URL 正在的URL
 */
- (BOOL)isDownloadingForURL:(NSString*) URL;

/**批量取消相关下载
 *@param URLs 图片URL
 */
- (void)cancelDownloadForURLs:(NSArray<NSString*>*) URLs;

/**取消单个下载
 *@param URL 正在下载的图片URL
 *@param target 下载图片的对象，如UIImageView
 */
- (void)cancelDownloadForURL:(NSString*)URL target:(id) target;

/**添加下载完成回调
 *@param completion 下载完成回调
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 *@param target 下载图片的对象，如UIImageView
 *@param URL 图片路径
 */
- (void)addCompletion:(SeaImageCacheCompletionHandler) completion thumbnailSize:(CGSize) size target:(id) target forURL:(NSString*) URL;

/**添加下载进度回调
 *@param progressHandler 进度回调
 *@param URL 图片路径
 *@param target 下载图片的对象，如UIImageView
 */
- (void)addProgressHandler:(SeaImageCacheProgressHandler) progressHandler forURL:(NSString *)URL target:(id) target;

/**保存图片到硬盘
 *@param image 要缓存的图片
 *@param URL 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不缓存缩略图
 *@param flag 是否需要保存到内存中
 *@return 如果保存在内存，则返回对应的图片，否则返回nil
 */
- (UIImage*)saveImageToDisk:(UIImage*) image forURL:(NSString*) URL thumbnailSize:(CGSize) size saveToMemory:(BOOL) flag;

/**保存图片文件到硬盘
 *@param imageFile 要缓存的图片文件
 *@param URL 图片路径
 */
- (void)saveImageFileToDisk:(NSString*) imageFile forURL:(NSString*) URL;

/**通过图片路径获取本地缓存图片，如果没有则返回nil
 *@param URL 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 */
- (UIImage*)imageFromDiskForURL:(NSString*) URL thumbnailSize:(CGSize) size;

/**通过图片路径获取内存图片，如果没有则返回nil
 *@param URL 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 */
- (UIImage*)imageFromMemoryForURL:(NSString*) URL thumbnailSize:(CGSize) size;

/**获取图片 先在缓存文件中查找，没有才通过http下载图片
 *@param URL 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 *@param completion 图片加载完成回调
 *@param target 下载图片的对象，如UIImageView
 */
- (void)imageForURL:(NSString*) URL thumbnailSize:(CGSize) size completion:(SeaImageCacheCompletionHandler) completion target:(id) target;

/**删除图片缓存
 *@param URLs 数组元素是 网络图片路径 NSString对象
 */
- (void)removeCacheImageForURLs:(NSArray<NSString*>*) URLs;

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
