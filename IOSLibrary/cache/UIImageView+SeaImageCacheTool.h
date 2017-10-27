//
//  UIImageView+SeaImageCacheTool.h

//

#import <UIKit/UIKit.h>
#import "SeaImageCacheTool.h"

@class AVURLAsset;

/**图片缓存类目
 */
@interface UIImageView (SeaImageCacheTool)

/**图片服务器路径
 */
@property(nonatomic,readonly) NSString *sea_imageURL;

/**设置图片路径
 *@param URL 图片路径
 */
- (void)sea_setImageWithURL:(NSString*) URL;

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheToolCompletionHandler) completion;

/**设置图片路径
 *@param URL 图片路径
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL progress:(SeaImageCacheToolProgressHandler) progress;

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheToolCompletionHandler) completion progress:(SeaImageCacheToolProgressHandler) progress;



@end
