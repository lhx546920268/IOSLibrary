//
//  UIImageView+SeaMovieCacheTool.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaMovieCacheTool.h"

/**视频缓存类目
 */
@interface UIImageView (SeaMovieCacheTool)

/**视频路径
 */
@property(nonatomic,readonly) NSString *sea_movieURL;

/**第一帧图片的最大尺寸
 */
@property(nonatomic,assign) CGSize sea_firstImageMaxSize;

#pragma mark- movie

/**设置视频路径，可获取视频的信息
 *@param URL 视频路径
 *@param completion 完成回调 
 */
- (void)sea_setMovieWithURL:(NSString*) URL completion:(SeaMovieCacheToolCompletionHandler) completion;

@end
