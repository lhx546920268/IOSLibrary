//
//  UIImageView+SeaMovieCache.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/25.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UIImageView+SeaMovieCache.h"
#import "NSString+Utils.h"
#import <objc/runtime.h>
#import "UIView+SeaActivityIndicatorView.h"

///视频链接
static char SeaMovieURLKey;

@implementation UIImageView (SeaMovieCache)

- (NSString*)sea_movieURL
{
    return objc_getAssociatedObject(self, &SeaMovieURLKey);
}

- (void)setSea_movieURL:(NSString *)sea_movieURL
{
    objc_setAssociatedObject(self, &SeaMovieURLKey, sea_movieURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark- download

- (void)sea_setMovieWithURL:(NSString *)URL
{
    [self sea_setMovieWithURL:URL completion:nil];
}

- (void)sea_setMovieWithURL:(NSString *)URL completion:(SeaMovieCacheCompletionHandler)completion
{
    [self sea_setMovieWithURL:URL options:nil completion:completion];
}

- (void)sea_setMovieWithURL:(NSString*) URL options:(SeaImageCacheOptions *)options completion:(SeaMovieCacheCompletionHandler)completion
{
//    if(!options)
//        options = [SeaImageCacheOptions defaultOptions];
//    
//    SeaMovieCacheTool *cache = [SeaMovieCacheTool sharedInstance];
//    
//    //取消以前的下载
//    if(![self.sea_movieURL isEqualToString:URL]){
//        [cache cancelDownloadForURL:self.sea_movieURL target:self];
//    }
//    
//    //无效的URL
//    if([NSString isEmpty:URL]){
//        
//        options.shouldShowLoadingActivity = NO;
//        [self sea_setLoading:YES options:options];
//        
//        self.sea_movieURL = nil;
//        !completion ?: completion(nil);
//        return;
//    }
//    
//    [self layoutIfNeeded];
//    CGSize size = CGSizeZero;
//    if(options.shouldAspectRatioFit){
//        size = self.bounds.size;
//    }
//    
//    self.sea_movieURL = URL;
//    
//    //判断内存中是否有图片
//    SeaMovieCacheInfo *info = [cache movieInfoFromMemoryForURL:URL thumbnailSize:size];;
//    
//    if(info){
//        
//        self.contentMode = options.originalContentMode;
//        self.image = info.firstImage;
//        [self sea_setLoading:NO options:options];
//        !completion ?: completion(info);
//    }else{
//        [self sea_setLoading:YES options:options];
//        //重新加载图片
//        
//        __weak UIImageView *weakSelf = self;
//        [cache movieInfoForURL:URL thumbnailSize:size completion:^(SeaMovieCacheInfo *cacheInfo){
//            
//            if(cacheInfo){
//                [weakSelf sea_setLoading:NO options:options];
//                weakSelf.contentMode = options.originalContentMode;
//                weakSelf.image = cacheInfo.firstImage;
//                weakSelf.backgroundColor = options.originalBackgroundColor;
//            }
//            
//            !completion ?: completion(cacheInfo);
//        } target:self];
//    }
}

- (void)sea_setLoading:(BOOL) loading options:(SeaImageCacheOptions*) options
{
    if(loading){
        if(options.placeholderColor){
            self.backgroundColor = options.placeholderColor;
        }
        
        if(options.placeholderImage){
            self.image = options.placeholderImage;
            self.contentMode = options.placeholderContentMode;
        }else{
            self.image = nil;
        }
    }
    
    if(options.shouldShowLoadingActivity && loading){
        self.sea_showActivityIndicator = YES;
        self.sea_activityIndicatorView.activityIndicatorViewStyle = options.activityIndicatorViewStyle;
    }else{
        self.sea_showActivityIndicator = NO;
    }
}


@end
