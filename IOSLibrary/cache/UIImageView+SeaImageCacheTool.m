//
//  UIImageView+SeaImageCacheTool.m

//

#import "UIImageView+SeaImageCacheTool.h"
#import <objc/runtime.h>
#import "SeaBasic.h"

@implementation UIImageView (SeaImageCacheTool)

#pragma mark- property

- (void)setSea_imageURL:(NSString *)sea_imageURL
{
    objc_setAssociatedObject(self, &SeaImageCacheToolImageURL, sea_imageURL, OBJC_ASSOCIATION_RETAIN);
}

- (NSString*)sea_imageURL
{
    return objc_getAssociatedObject(self, &SeaImageCacheToolImageURL);
}


#pragma mark- getImage

/**设置图片路径
 *@param URL 图片路径
 */
- (void)sea_setImageWithURL:(NSString*) URL
{
    [self sea_setImageWithURL:URL completion:nil progress:nil];
}

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheToolCompletionHandler) completion
{
    [self sea_setImageWithURL:URL completion:completion progress:nil];
}

/**设置图片路径
 *@param URL 图片路径
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL progress:(SeaImageCacheToolProgressHandler) progress
{
    [self sea_setImageWithURL:URL completion:nil progress:progress];
}

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheToolCompletionHandler) completion progress:(SeaImageCacheToolProgressHandler) progress
{
    SeaImageCacheTool *cache = [SeaImageCacheTool sharedInstance];
    
    //无效的URL
    if([NSString isEmpty:URL])
    {
        [self setupLoading:NO];
        
        //优先使用预载图
        if(self.sea_placeHolderImage)
        {
            self.contentMode = self.sea_placeHolderContentMode;
            self.image = self.sea_placeHolderImage;
        }
        else
        {
            self.image = nil;
            self.backgroundColor = self.sea_placeHolderColor;
        }
        
        [cache cancelDownloadWithURL:self.sea_imageURL target:self];
        
        self.sea_imageURL = nil;
        if(completion)
        {
            completion(nil, NO);
        }
        return;
    }
    
    //此图片正在下载
    if([cache isRequestingWithURL:URL])
    {
        [self setupLoading:YES];
        [cache addCompletion:[self completionHandlerWithBlock:completion] thumbnailSize:self.sea_thumbnailSize target:self forURL:URL];
        return;
    }
    
    //取消以前的下载
    [cache cancelDownloadWithURL:self.sea_imageURL target:self];
    self.sea_imageURL = URL;
    
    //判断内存中是否有图片
    UIImage *thumbnail = [cache imageFromMemoryWithURL:URL thumbnailSize:self.sea_thumbnailSize];
    
    if(thumbnail)
    {
        self.contentMode = self.sea_originContentMode;
        self.image = thumbnail;
        [self setupLoading:NO];
        if(completion)
        {
            completion(thumbnail, NO);
        }
    }
    
    if(!thumbnail)
    {
        [self setupLoading:YES];
        //重新加载图片
        [cache getImageWithURL:URL thumbnailSize:self.sea_thumbnailSize completion:[self completionHandlerWithBlock:completion] target:self];
    }
}

///图片加载完成回调
- (SeaImageCacheToolCompletionHandler)completionHandlerWithBlock:(SeaImageCacheToolCompletionHandler) block
{
    //加载完成回调
    __weak UIImageView *weakSelf = self;
    SeaImageCacheToolCompletionHandler completionHandler = ^(UIImage *image , BOOL fromNetwork){
        
        [weakSelf setupLoading:NO];
        
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
            
            weakSelf.contentMode = weakSelf.sea_originContentMode;
            weakSelf.image = image;
            weakSelf.backgroundColor = weakSelf.sea_originBackgroundColor;
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
//    SeaImageCacheTool *cache = [SeaImageCacheTool sharedInstance];
//    [cache cancelDownloadWithURL:self.sea_imageURL target:self];
//}

@end
