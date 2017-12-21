//
//  SeaImageCacheToolOperation.h

//

#import <UIKit/UIKit.h>

/**图片异步加载完成回调块
 *@param image 下载完成的图片
 *@param fromNetwork 是否是从网络上加载
 */
typedef void (^SeaImageCacheToolCompletionHandler)(UIImage *image, BOOL fromNetwork);

/**图片下载进度回调
 *@param progress 下载进度 范围 0 ~ 1.0
 */
typedef void(^SeaImageCacheToolProgressHandler)(float progress);

/**图片缓存工具 操作信息类
 */
@interface SeaImageCacheToolOperation : NSObject

/**下载任务，如果只是在本地文件中寻找时为nil
 */
@property(nonatomic,strong) NSURLSessionDownloadTask *downloadTask;

/**片缓存要求 数组元素是 SeaImageCacheToolRequirement
 */
@property(nonatomic,strong) NSMutableSet *requirements;

@end

/**图片缓存要求
 */
@interface SeaImageCacheToolRequirement : NSObject

/**完成回调
 */
@property(nonatomic,copy) SeaImageCacheToolCompletionHandler completion;

/**进度回调
 */
@property(nonatomic,copy) SeaImageCacheToolProgressHandler progressHandler;

/**缩略图大小
 */
@property(nonatomic,assign) CGSize thumbnailSize;

/**加载图片的对象，如 UIImageView , UIButton
 */
@property(nonatomic,weak) id target;

@end
