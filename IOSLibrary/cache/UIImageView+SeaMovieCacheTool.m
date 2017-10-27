//
//  UIImageView+SeaMovieCacheTool.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "UIImageView+SeaMovieCacheTool.h"
#import <objc/runtime.h>
#import "SeaMovieCacheTool.h"
#import "NSString+Utilities.h"
#import "UIImageView+SeaCache.h"
#import "SeaImageCacheTool.h"

/// 视频路径
static char SeaMovieURLKey;

/// 第一帧图片的最大尺寸
static char SeaMovieFirstImageMaxSizeKey;

@implementation UIImageView (SeaMovieCacheTool)


#pragma mark- movie

- (NSString*)sea_movieURL
{
    return objc_getAssociatedObject(self, &SeaMovieURLKey);
}

- (void)setSea_movieURL:(NSString *)sea_movieURL
{
    objc_setAssociatedObject(self, &SeaMovieURLKey, sea_movieURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)sea_firstImageMaxSize
{
    return [objc_getAssociatedObject(self, &SeaMovieFirstImageMaxSizeKey) CGSizeValue];
}

- (void)setSea_firstImageMaxSize:(CGSize)sea_firstImageMaxSize
{
    objc_setAssociatedObject(self, &SeaMovieFirstImageMaxSizeKey, [NSValue valueWithCGSize:sea_firstImageMaxSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**设置视频路径，可获取视频的信息
 *@param URL 视频路径
 *@param completion 完成回调
 */
- (void)sea_setMovieWithURL:(NSString*) URL completion:(SeaMovieCacheToolCompletionHandler) completion
{
    SeaMovieCacheTool *cache = [SeaMovieCacheTool sharedInstance];
    
    //无效的url
    if([NSString isEmpty:URL])
    {
        [self setupLoading:NO];
        
        //优先使用预载图
//        if(self.sea_placeHolderImage)
//        {
//            self.contentMode = self.sea_placeHolderContentMode;
//            self.image = self.sea_placeHolderImage;
//        }
//        else
//        {
//            self.image = nil;
//            self.backgroundColor = self.sea_placeHolderColor;
//        }
        
        [cache cancelRequestWithURL:self.sea_movieURL target:self];
        
        self.sea_movieURL = nil;
        !completion ?: completion(0,nil);
        
        return;
    }
    
    //此图片正在下载
    if([cache isRequestingWithURL:URL])
    {
        [self setupLoading:YES];
        [cache addRequirement:[self requirementWithCompletion:completion] forURL:URL];
        return;
    }
    
    //取消以前的下载
    [cache cancelRequestWithURL:self.sea_movieURL target:self];
    self.sea_movieURL = URL;
    

    ///从内存获取
    NSString *time = [[SeaMovieCacheTool defaultCache] objectForKey:URL];
    UIImage *image = [[SeaImageCacheTool sharedInstance] imageFromMemoryWithURL:URL thumbnailSize:self.sea_thumbnailSize];
    if(time && image)
    {
       // self.contentMode = self.sea_originContentMode;
       // self.image = image;
        [self setupLoading:NO];
        !completion ?: completion([time doubleValue], image);
    }
    else
    {
        [self setupLoading:YES];
        //重新加载
        [cache getMovieWithURL:URL requirement:[self requirementWithCompletion:completion]];
    }
}

///视频缓存要求
- (SeaMovieCacheToolRequirement*)requirementWithCompletion:(SeaMovieCacheToolCompletionHandler) completion
{
    //加载完成回调
    __weak UIImageView *weakSelf = self;
    SeaMovieCacheToolCompletionHandler completionHandler = ^(NSTimeInterval time, UIImage *image)
    {
        
        [weakSelf setupLoading:NO];
        
        //渐变效果
        if(image)
        {
           // weakSelf.contentMode = weakSelf.sea_originContentMode;
          //  weakSelf.image = image;
            weakSelf.backgroundColor = [UIColor clearColor];
        }
        
        !completion ?: completion(time,image);
    };
    
    SeaMovieCacheToolRequirement *req = [[SeaMovieCacheToolRequirement alloc] init];
    req.firstImageMaxSize = self.sea_firstImageMaxSize;
    req.target = self;
    req.thumbnailSize = self.sea_thumbnailSize;
    req.completion = completionHandler;
    
    return req;
}

@end
