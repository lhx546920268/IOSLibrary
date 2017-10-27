//
//  UIButton+SeaImageCacheTool.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/30.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "UIButton+SeaImageCacheTool.h"
#import <objc/runtime.h>
#import "SeaBasic.h"

@implementation UIButton (SeaImageCacheTool)

#pragma mark- property


- (NSString*)sea_imageURL
{
    return [self.sea_imageURLDictionary objectForKey:@(self.state)];
}

- (NSString*)sea_backgroundImageURL
{
    return [self.sea_backgroundImageURLDictionary objectForKey:@(self.state)];
}

- (void)setSea_thumbnailSize:(CGSize)sea_thumbnailSize
{
    objc_setAssociatedObject(self, &SeaImageCacheToolThumbnailSize, [NSValue valueWithCGSize:sea_thumbnailSize], OBJC_ASSOCIATION_RETAIN);
}

- (CGSize)sea_thumbnailSize
{
    NSValue *value = objc_getAssociatedObject(self, &SeaImageCacheToolThumbnailSize);
//    if(value == nil)
//    {
//        return self.bounds.size;
//    }
//    else
    {
        return [value CGSizeValue];
    }
}

- (void)setSea_showLoadingActivity:(BOOL)sea_showLoadingActivity
{
    objc_setAssociatedObject(self, &SeaImageCacheToolShowLoadingActivity, [NSNumber numberWithBool:sea_showLoadingActivity], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)sea_showLoadingActivity
{
    return [objc_getAssociatedObject(self, &SeaImageCacheToolShowLoadingActivity) boolValue];
}

- (void)setSea_placeHolderColor:(UIColor *)sea_placeHolderColor
{
    objc_setAssociatedObject(self, &SeaImageCacheToolPlaceHolderColor, sea_placeHolderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor*)sea_placeHolderColor
{
    return objc_getAssociatedObject(self, &SeaImageCacheToolPlaceHolderColor);
}

- (void)setSea_placeHolderImage:(UIImage *)sea_placeHolderImage
{
    objc_setAssociatedObject(self, &SeaImageCacheToolPlaceHolderImage, sea_placeHolderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage*)sea_placeHolderImage
{
    UIImage *placeHolder = objc_getAssociatedObject(self, &SeaImageCacheToolPlaceHolderImage);
    if(placeHolder == nil)
    {
        CGSize size = self.bounds.size;
        
        /**正方形
         */
        if(size.width == size.height)
        {
            //大的
            if(size.width > 150)
            {
                placeHolder = [UIImage imageNamed:@"placeHolder_square_big"];
            }
            else
            {
                placeHolder = [UIImage imageNamed:@"placeHolder_square_small"];
            }
        }
        else
        {
            placeHolder = [UIImage imageNamed:@"placeHolder_rect"];
        }
    }
    return placeHolder;
}

- (void)setSea_actView:(UIActivityIndicatorView *)sea_actView
{
    objc_setAssociatedObject(self, &SeaImageCacheToolActivity, sea_actView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView*)sea_actView
{
    return objc_getAssociatedObject(self, &SeaImageCacheToolActivity);
}

- (void)setSea_actStyle:(UIActivityIndicatorViewStyle)sea_actStyle
{
    objc_setAssociatedObject(self, &SeaImageCacheToolActivityStyle, [NSNumber numberWithInteger:sea_actStyle], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.sea_actView != nil)
    {
        self.sea_actView.activityIndicatorViewStyle = sea_actStyle;
    }
}

- (UIActivityIndicatorViewStyle)sea_actStyle
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaImageCacheToolActivityStyle);
    if(number == nil)
    {
        return UIActivityIndicatorViewStyleGray;
    }
    else
    {
        return [number integerValue];
    }
}

#pragma mark- getImage

///设置加载状态
- (void)setupImageLoading:(BOOL) loading forState:(UIControlState) state
{
    BOOL _loading = [objc_getAssociatedObject(self, &SeaImageCacheToolLoading) boolValue];
    
    if(loading == _loading)
        return;
    
    objc_setAssociatedObject(self, &SeaImageCacheToolLoading, [NSNumber numberWithBool:loading], OBJC_ASSOCIATION_RETAIN);
    
    if(loading)
    {
        //优先使用预载图
        if(self.sea_placeHolderImage)
        {
            [self setImage:self.sea_placeHolderImage forState:state];
        }
        else
        {
            [self setImage:nil forState:state];
            self.backgroundColor = self.sea_placeHolderColor;
        }
    }
    
    [self setupActivityWithLoading:loading];
}

///设置背景图片加载状态
- (void)setupBackgroundImageLoading:(BOOL) loading forState:(UIControlState) state
{
    BOOL _loading = [objc_getAssociatedObject(self, &SeaImageCacheToolLoading) boolValue];
    
    if(loading == _loading)
        return;
    
    objc_setAssociatedObject(self, &SeaImageCacheToolLoading, [NSNumber numberWithBool:loading], OBJC_ASSOCIATION_RETAIN);
    
    if(loading)
    {
        //优先使用预载图
        if(self.sea_placeHolderImage)
        {
            [self setBackgroundImage:self.sea_placeHolderImage forState:state];
        }
        else
        {
            [self setBackgroundImage:nil forState:state];
            self.backgroundColor = self.sea_placeHolderColor;
        }
    }
    
    [self setupActivityWithLoading:loading];
}

///设置activity
- (void)setupActivityWithLoading:(BOOL) loading
{
    if(self.sea_showLoadingActivity)
    {
        if(loading)
        {
            if(!self.sea_actView)
            {
                UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.sea_actStyle];
                view.center = CGPointMake(self.width / 2.0, self.height / 2.0);
                [self addSubview:view];
                self.sea_actView = view;
            }
            
            [self.sea_actView startAnimating];
        }
        else
        {
            [self.sea_actView stopAnimating];
        }
    }
}

/**获取下载的图片路径
 */
- (NSString*)sea_imageURLForState:(UIControlState) state
{
    return [self.sea_imageURLDictionary objectForKey:@(state)];
}


/**图片路径存储器
 */
- (NSMutableDictionary*)sea_imageURLDictionary
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &SeaImageCacheToolImageURLDictionary);
    
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &SeaImageCacheToolImageURLDictionary, dic, OBJC_ASSOCIATION_RETAIN);
    }
    
    return dic;
}

/**设置图片路径
 *@param URL 图片路径
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState)state
{
    [self sea_setImageWithURL:URL forState:state completion:nil progress:nil];
}

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState)state completion:(SeaImageCacheToolCompletionHandler) completion
{
    [self sea_setImageWithURL:URL forState:state completion:completion progress:nil];
}

/**设置图片路径
 *@param URL 图片路径
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state progress:(SeaImageCacheToolProgressHandler) progress
{
    [self sea_setImageWithURL:URL forState:state completion:nil progress:progress];
}

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheToolCompletionHandler) completion progress:(SeaImageCacheToolProgressHandler) progress
{
    SeaImageCacheTool *cache = [SeaImageCacheTool sharedInstance];
    
    NSMutableDictionary *dic = [self sea_imageURLDictionary];

    //无效的URL
    if([NSString isEmpty:URL])
    {
        [cache cancelDownloadWithURL:[dic objectForKey:@(state)] target:self];
        
        [dic removeObjectForKey:@(state)];
        
        [self setupImageLoading:NO forState:state];
        if(completion)
        {
            completion(nil, NO);
        }
        if(self.sea_placeHolderImage)
        {
            [self setImage:self.sea_placeHolderImage forState:state];
        }
        else
        {
            [self setImage:nil forState:state];
            self.backgroundColor = self.sea_placeHolderColor;
        }
        
        return;
    }

    //此图片正在下载
    if([cache isRequestingWithURL:URL])
    {
        [self setupImageLoading:YES forState:state];
        [cache addCompletion:[self imageLoadingCompletionHandlerWithBlock:completion forState:state] thumbnailSize:self.sea_thumbnailSize target:self forURL:URL];
        return;
    }
    
    //取消以前的下载
    [cache cancelDownloadWithURL:[dic objectForKey:@(state)] target:self];
    [dic setObject:URL forKey:@(state)];
    
    //判断内存中是否有图片
    UIImage *thumbnail = [cache imageFromMemoryWithURL:URL thumbnailSize:self.sea_thumbnailSize];
    
    if(thumbnail)
    {
        [self setImage:thumbnail forState:state];
        [self setupImageLoading:NO forState:state];
        if(completion)
        {
            completion(thumbnail, NO);
        }
    }
    
    if(!thumbnail)
    {
        [self setupImageLoading:YES forState:state];
        //重新加载图片
        [cache getImageWithURL:URL thumbnailSize:self.sea_thumbnailSize completion:[self imageLoadingCompletionHandlerWithBlock:completion forState:state] target:self];
    }
}

///图片加载完成回调
- (SeaImageCacheToolCompletionHandler)imageLoadingCompletionHandlerWithBlock:(SeaImageCacheToolCompletionHandler) block forState:(UIControlState) state
{
    //加载完成回调
    __weak UIButton *weakSelf = self;
    SeaImageCacheToolCompletionHandler completionHandler = ^(UIImage *image , BOOL fromNetwork){
        
        [weakSelf setupImageLoading:NO forState:state];
        
        //渐变效果
        if(image)
        {
//            if(fromNetwork)
//            {
//                CATransition *animation = [CATransition animation];
//                animation.duration = 0.25;
//                animation.type = kCATransitionFade;
//                [weakSelf.layer addAnimation:animation forKey:nil];
//            }
            
            [weakSelf setImage:image forState:state];
            weakSelf.backgroundColor = [UIColor clearColor];
        }
        
        if(block)
        {
            block(image, fromNetwork);
        }
    };
    
    return completionHandler;
}

#pragma mark- backgroundImage

/**获取下载的背景图片路径
 */
- (NSString*)sea_backgroundImageURLForState:(UIControlState) state
{
    return [self.sea_backgroundImageURLDictionary objectForKey:@(state)];
}

/**背景图片路径存储器
 */
- (NSMutableDictionary*)sea_backgroundImageURLDictionary
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &SeaImageCacheToolBackgroundImageURLDictionary);
    
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &SeaImageCacheToolBackgroundImageURLDictionary, dic, OBJC_ASSOCIATION_RETAIN);
    }
    
    return dic;
}

/**设置图片路径
 *@param URL 图片路径
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state
{
    [self sea_setBackgroundImageWithURL:URL forState:state completion:nil progress:nil];
}

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheToolCompletionHandler) completion
{
    [self sea_setBackgroundImageWithURL:URL forState:state completion:completion progress:nil];
}

/**设置图片路径
 *@param URL 图片路径
 *@param progress 加载进度回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state progress:(SeaImageCacheToolProgressHandler) progress
{
    [self sea_setBackgroundImageWithURL:URL forState:state completion:nil progress:progress];
}

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheToolCompletionHandler) completion progress:(SeaImageCacheToolProgressHandler) progress
{
    SeaImageCacheTool *cache = [SeaImageCacheTool sharedInstance];
    
    NSMutableDictionary *dic = [self sea_backgroundImageURLDictionary];
   
    //无效的URL
    if([NSString isEmpty:URL])
    {
        [cache cancelDownloadWithURL:[dic objectForKey:@(state)] target:self];
        [dic removeObjectForKey:@(state)];
        
        [self setupBackgroundImageLoading:NO forState:state];
        if(completion)
        {
            completion(nil, NO);
        }
        
        //优先使用预载图
        if(self.sea_placeHolderImage)
        {
            [self setBackgroundImage:self.sea_placeHolderImage forState:state];
        }
        else
        {
            [self setBackgroundImage:nil forState:state];
            self.backgroundColor = self.sea_placeHolderColor;
        }
        
        return;
    }
    
    //此图片正在下载
    if([cache isRequestingWithURL:URL])
    {
        [self setupBackgroundImageLoading:YES forState:state];
        [cache addCompletion:[self backgroundImageLoadingCompletionHandlerWithBlock:completion forState:state] thumbnailSize:self.sea_thumbnailSize target:self forURL:URL];
        return;
    }
    
    //取消以前的下载
    [cache cancelDownloadWithURL:[dic objectForKey:@(state)] target:self];
    [dic setObject:URL forKey:@(state)];
    
    //判断内存中是否有图片
    UIImage *thumbnail = [cache imageFromMemoryWithURL:URL thumbnailSize:self.sea_thumbnailSize];
    
    if(thumbnail)
    {
        [self setBackgroundImage:thumbnail forState:state];
        [self setupBackgroundImageLoading:NO forState:state];
        if(completion)
        {
            completion(thumbnail, NO);
        }
    }
    
    if(!thumbnail)
    {
        [self setupBackgroundImageLoading:YES forState:state];
        //重新加载图片
        [cache getImageWithURL:URL thumbnailSize:self.sea_thumbnailSize completion:[self backgroundImageLoadingCompletionHandlerWithBlock:completion forState:state] target:self];
    }
}

///图片加载完成回调
- (SeaImageCacheToolCompletionHandler)backgroundImageLoadingCompletionHandlerWithBlock:(SeaImageCacheToolCompletionHandler) block forState:(UIControlState) state
{
    //加载完成回调
    __weak UIButton *weakSelf = self;
    SeaImageCacheToolCompletionHandler completionHandler = ^(UIImage *image , BOOL fromNetwork){
        
        [weakSelf setupImageLoading:NO forState:state];
        
        //渐变效果
        if(image)
        {
//            if(fromNetwork)
//            {
//                CATransition *animation = [CATransition animation];
//                animation.duration = 0.25;
//                animation.type = kCATransitionFade;
//                [weakSelf.layer addAnimation:animation forKey:nil];
//            }
            
            [weakSelf setBackgroundImage:image forState:state];
            weakSelf.backgroundColor = [UIColor clearColor];
        }
        
        if(block)
        {
            block(image, fromNetwork);
        }
    };
    
    return completionHandler;
}

///会影响父类的dealloc
//- (void)dealloc
//{
//    //取消下载
//    SeaImageCacheTool *cache = [SeaImageCacheTool sharedInstance];
//    
//    [[self sea_backgroundImageURLDictionary] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
//       
//        [cache cancelDownloadWithURL:obj target:self];
//    }];
//    
//    [[self sea_imageURLDictionary] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
//        
//        [cache cancelDownloadWithURL:obj target:self];
//    }];
//}

@end
