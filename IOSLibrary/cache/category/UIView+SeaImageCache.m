//
//  UIView+SeaImageCache.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/3/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UIView+SeaImageCache.h"
#import <objc/runtime.h>
#import "UIView+SeaActivityIndicatorView.h"
#import "SeaImageCacheTool.h"
#import "NSString+Utils.h"

///图片路径
static char SeaImageURLKey;

@implementation UIView (SeaImageCache)

- (void)setSea_imageURL:(NSString *)sea_imageURL
{
    objc_setAssociatedObject(self, &SeaImageURLKey, sea_imageURL, OBJC_ASSOCIATION_RETAIN);
}

- (NSString*)sea_imageURL
{
    return objc_getAssociatedObject(self, &SeaImageURLKey);
}

- (void)sea_cancelDownloadImage
{
    [[SeaImageCacheTool sharedInstance] cancelDownloadForURL:self.sea_imageURL target:self];
}

#pragma mark- get Image

- (void)sea_setImageWithURL:(NSString*) URL
{
    [self sea_setImageWithURL:URL completion:nil];
}

- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheCompletionHandler) completion
{
    [self sea_setImageWithURL:URL completion:completion progress:nil];
}

- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheCompletionHandler) completion progress:(SeaImageCacheProgressHandler)progress
{
    [self sea_setImageWithURL:URL options:nil completion:completion progress:progress];
}

- (void)sea_setImageWithURL:(NSString*) URL options:(SeaImageCacheOptions *)options
{
    [self sea_setImageWithURL:URL options:options completion:nil];
}

- (void)sea_setImageWithURL:(NSString *)URL options:(SeaImageCacheOptions *)options completion:(SeaImageCacheCompletionHandler)completion
{
    [self sea_setImageWithURL:URL options:options completion:completion progress:nil];
}

- (void)sea_setImageWithURL:(NSString *)URL options:(SeaImageCacheOptions *)options completion:(SeaImageCacheCompletionHandler)completion progress:(SeaImageCacheProgressHandler)progress
{
    if(!options)
        options = [SeaImageCacheOptions defaultOptions];
    
    SeaImageCacheTool *cache = [SeaImageCacheTool sharedInstance];
    
    //取消以前的下载
    if(![self.sea_imageURL isEqualToString:URL]){
        [cache cancelDownloadForURL:self.sea_imageURL target:self];
    }
    
    //无效的URL
    if([NSString isEmpty:URL]){
        
        options.shouldShowLoadingActivity = NO;
        [self sea_setLoading:YES options:options];
        
        self.sea_imageURL = nil;
        !completion ?: completion(nil);
        return;
    }
    
    [self layoutIfNeeded];
    CGSize size = CGSizeZero;
    if(options.shouldAspectRatioFit){
        size = self.bounds.size;
    }
    
    self.sea_imageURL = URL;
    
    //判断内存中是否有图片
    UIImage *image = [cache imageFromMemoryForURL:URL thumbnailSize:size];
    
    if(image){
        
        self.contentMode = options.originalContentMode;
        [self sea_imageDidLoad:image];
        [self sea_setLoading:NO options:options];
        !completion ?: completion(image);
    }else{
        [self sea_setLoading:YES options:options];
        //重新加载图片
        
        __weak UIView *weakSelf = self;
        [cache imageForURL:URL thumbnailSize:size completion:^(UIImage *image){
            
            if(image){
                [weakSelf sea_setLoading:NO options:options];
                weakSelf.contentMode = options.originalContentMode;
                [weakSelf sea_imageDidLoad:image];
                weakSelf.backgroundColor = options.originalBackgroundColor;
            }
            
            !completion ?: completion(image);
        } target:self];
        
        if(progress){
            [cache addProgressHandler:progress forURL:URL target:self];
        }
    }
}

- (void)sea_setLoading:(BOOL) loading options:(SeaImageCacheOptions*) options
{
    if(loading){
        if(options.placeholderColor){
            self.backgroundColor = options.placeholderColor;
        }
    }
    
    if(options.shouldShowLoadingActivity && loading){
        self.sea_showActivityIndicator = YES;
        self.sea_activityIndicatorView.activityIndicatorViewStyle = options.activityIndicatorViewStyle;
    }else{
        self.sea_showActivityIndicator = NO;
    }
}

- (void)sea_imageDidLoad:(UIImage*) image
{
    
}

@end
