//
//  UIButton+SeaImageCache.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UIButton+SeaImageCache.h"
#import <objc/runtime.h>
#import "NSString+Utils.h"
#import "UIView+SeaActivityIndicatorView.h"

static char SeaImageCacheImageURLDictionaryKey;
static char SeaImageCacheBackgroundImageURLDictionaryKey;

@implementation UIButton (SeaImageCache)

#pragma mark- property


- (NSString*)sea_imageURL
{
    return [self.sea_imageURLDictionary objectForKey:@(self.state)];
}

- (NSString*)sea_backgroundImageURL
{
    return [self.sea_backgroundImageURLDictionary objectForKey:@(self.state)];
}

#pragma mark- set Image


/**获取下载的图片路径
 */
- (NSString*)sea_imageURLForState:(UIControlState) state
{
    return [self.sea_imageURLDictionary objectForKey:@(state)];
}


/**图片路径存储器
 */
- (NSMutableDictionary<NSNumber*, NSString*>*)sea_imageURLDictionary
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &SeaImageCacheImageURLDictionaryKey);
    
    if(dic == nil){
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &SeaImageCacheImageURLDictionaryKey, dic, OBJC_ASSOCIATION_RETAIN);
    }
    
    return dic;
}

- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState)state
{
    [self sea_setImageWithURL:URL forState:state completion:nil progress:nil];
}

- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState)state completion:(SeaImageCacheCompletionHandler) completion
{
    [self sea_setImageWithURL:URL forState:state completion:completion progress:nil];
}

- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state progress:(SeaImageCacheProgressHandler) progress
{
    [self sea_setImageWithURL:URL forState:state completion:nil progress:progress];
}

- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheCompletionHandler) completion progress:(SeaImageCacheProgressHandler) progress
{
    [self sea_setImageWithURL:URL forState:state options:nil completion:completion progress:progress];
}

- (void)sea_setImageWithURL:(NSString *)URL forState:(UIControlState)state options:(SeaImageCacheOptions *)options
{
    [self sea_setImageWithURL:URL forState:state options:options completion:nil];
}

- (void)sea_setImageWithURL:(NSString *)URL forState:(UIControlState)state options:(SeaImageCacheOptions *)options completion:(SeaImageCacheCompletionHandler)completion
{
    [self sea_setImageWithURL:URL forState:state options:options completion:completion progress:nil];
}

- (void)sea_setImageWithURL:(NSString *)URL forState:(UIControlState)state options:(SeaImageCacheOptions *)options progress:(SeaImageCacheProgressHandler)progress
{
    [self sea_setImageWithURL:URL forState:state options:options completion:nil progress:progress];
}

- (void)sea_setImageWithURL:(NSString *)URL forState:(UIControlState)state options:(SeaImageCacheOptions *)options completion:(SeaImageCacheCompletionHandler)completion progress:(SeaImageCacheProgressHandler)progress
{
    if(!options)
        options = [SeaImageCacheOptions defaultOptions];
    
    SeaImageCacheTool *cache = [SeaImageCacheTool sharedInstance];
    
    NSMutableDictionary *dic = [self sea_imageURLDictionary];
    
    //取消以前的下载
    NSString *oldURL = [dic objectForKey:@(state)];
    if(![oldURL isEqualToString:URL]){
        [cache cancelDownloadForURL:oldURL target:self];
    }
    
    //无效的URL
    if([NSString isEmpty:URL]){
        [dic removeObjectForKey:@(state)];
        [self setImageLoading:YES forState:state options:options];
        !completion ?: completion(nil);
        
        return;
    }
    
    [self layoutIfNeeded];
    CGSize size = CGSizeZero;
    if(options.shouldAspectRatioFit){
        size = self.bounds.size;
    }
    
    [dic setObject:URL forKey:@(state)];
    
    //判断内存中是否有图片
    UIImage *image = [cache imageFromMemoryForURL:URL thumbnailSize:size];
    
    if(image){
        [self setImage:image forState:state];
        [self setImageLoading:NO forState:state options:options];
        !completion ?: completion(image);
    }
    
    if(!image){
        [self setImageLoading:YES forState:state options:options];
        
         __weak UIButton *weakSelf = self;
        [cache imageForURL:URL thumbnailSize:size completion:^(UIImage *image){
            
            if(image){
                [weakSelf setImageLoading:NO forState:state options:options];
                [weakSelf setImage:image forState:state];
                weakSelf.backgroundColor = options.originalBackgroundColor;
            }
            
            !completion ?: completion(image);
        } target:self];
        
        if(progress){
            [cache addProgressHandler:progress forURL:URL target:self];
        }
    }
}

- (void)setImageLoading:(BOOL) loading forState:(UIControlState) state options:(SeaImageCacheOptions*) options
{
    if(loading){
        if(options.placeholderColor){
            self.backgroundColor = options.placeholderColor;
        }
        
        if(options.placeholderImage){
            [self setImage:options.placeholderImage forState:state];
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

#pragma mark- backgroundImage

- (NSString*)sea_backgroundImageURLForState:(UIControlState) state
{
    return [self.sea_backgroundImageURLDictionary objectForKey:@(state)];
}

/**背景图片路径存储器
 */
- (NSMutableDictionary*)sea_backgroundImageURLDictionary
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &SeaImageCacheBackgroundImageURLDictionary);
    
    if(dic == nil){
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &SeaImageCacheBackgroundImageURLDictionary, dic, OBJC_ASSOCIATION_RETAIN);
    }
    
    return dic;
}

- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state
{
    [self sea_setBackgroundImageWithURL:URL forState:state completion:nil progress:nil];
}

- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheCompletionHandler) completion
{
    [self sea_setBackgroundImageWithURL:URL forState:state completion:completion progress:nil];
}

- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state progress:(SeaImageCacheProgressHandler) progress
{
    [self sea_setBackgroundImageWithURL:URL forState:state completion:nil progress:progress];
}

- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheCompletionHandler) completion progress:(SeaImageCacheProgressHandler) progress
{
    [self sea_setBackgroundImageWithURL:URL forState:state options:nil completion:completion progress:progress];
}

- (void)sea_setBackgroundImageWithURL:(NSString *)URL forState:(UIControlState)state options:(SeaImageCacheOptions *)options
{
    [self sea_setBackgroundImageWithURL:URL forState:state options:options completion:nil];
}

- (void)sea_setBackgroundImageWithURL:(NSString *)URL forState:(UIControlState)state options:(SeaImageCacheOptions *)options completion:(SeaImageCacheCompletionHandler)completion
{
    [self sea_setBackgroundImageWithURL:URL forState:state options:options completion:completion progress:nil];
}

- (void)sea_setBackgroundImageWithURL:(NSString *)URL forState:(UIControlState)state options:(SeaImageCacheOptions *)options completion:(SeaImageCacheCompletionHandler)completion progress:(SeaImageCacheProgressHandler)progress
{
    if(!options)
        options = [SeaImageCacheOptions defaultOptions];
    
    SeaImageCacheTool *cache = [SeaImageCacheTool sharedInstance];
    
    NSMutableDictionary *dic = [self sea_backgroundImageURLDictionary];
    
    //取消以前的下载
    NSString *oldURL = [dic objectForKey:@(state)];
    if(![oldURL isEqualToString:URL]){
        [cache cancelDownloadForURL:oldURL target:self];
    }
    
    //无效的URL
    if([NSString isEmpty:URL]){
        [dic removeObjectForKey:@(state)];
        [self setBackgroundImageLoading:YES forState:state options:options];
        !completion ?: completion(nil);
        
        return;
    }
    
    [self layoutIfNeeded];
    CGSize size = CGSizeZero;
    if(options.shouldAspectRatioFit){
        size = self.bounds.size;
    }
    
    [dic setObject:URL forKey:@(state)];
    
    //判断内存中是否有图片
    UIImage *image = [cache imageFromMemoryForURL:URL thumbnailSize:size];
    
    if(image){
        [self setBackgroundImage:image forState:state];
        [self setBackgroundImageLoading:NO forState:state options:options];
        !completion ?: completion(image);
    }
    
    if(!image){
        [self setBackgroundImageLoading:YES forState:state options:options];
        
        __weak UIButton *weakSelf = self;
        [cache imageForURL:URL thumbnailSize:size completion:^(UIImage *image){
            
            if(image){
                [weakSelf setBackgroundImageLoading:NO forState:state options:options];
                [weakSelf setBackgroundImage:image forState:state];
                weakSelf.backgroundColor = options.originalBackgroundColor;
            }
            
            !completion ?: completion(image);
        } target:self];
        
        if(progress){
            [cache addProgressHandler:progress forURL:URL target:self];
        }
    }
}

- (void)setBackgroundImageLoading:(BOOL) loading forState:(UIControlState) state options:(SeaImageCacheOptions*) options
{
    if(loading){
        if(options.placeholderColor){
            self.backgroundColor = options.placeholderColor;
        }
        
        if(options.placeholderImage){
            [self setBackgroundImage:options.placeholderImage forState:state];
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
