//
//  SeaMovieCacheToolOperation.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**视频缓存回调 timeInterval 视频时长（秒 firstImage 视频第一帧图片
 */
typedef void(^SeaMovieCacheToolCompletionHandler)(NSTimeInterval timeInterval, UIImage *firstImage);

/**视频缓存工具 操作信息类
 */
@interface SeaMovieCacheToolOperation : NSObject

/**网络请求，如果只是在本地文件中寻找时为nil
 */
@property(nonatomic,strong) NSBlockOperation *blockOperation;

/**片缓存要求 数组元素是 SeaImageCacheToolRequirement
 */
@property(nonatomic,strong) NSMutableSet *requirements;

@end

/**视频缓存要求
 */
@interface SeaMovieCacheToolRequirement : NSObject

/**完成回调
 */
@property(nonatomic,copy) SeaMovieCacheToolCompletionHandler completion;

/**缩略图大小
 */
@property(nonatomic,assign) CGSize thumbnailSize;

/**第一帧图片的最大尺寸
 */
@property(nonatomic,assign) CGSize firstImageMaxSize;

/**加载视频的对象，如 UIImageView
 */
@property(nonatomic,weak) id target;

@end
