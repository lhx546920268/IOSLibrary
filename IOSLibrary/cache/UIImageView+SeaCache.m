//
//  UIImageView+SeaCache.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "UIImageView+SeaCache.h"
#import "SeaImageCacheTool.h"
#import <objc/runtime.h>
#import "SeaBasic.h"

/// originContentMode属性的key
static char SeaOriginContentModeKey;

/// placeHolderContentMode属性key
static char SeaPlaceHolderContentModeKey;

@implementation UIImageView (SeaCache)

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
    objc_setAssociatedObject(self, &SeaImageCacheToolPlaceHolderColor, sea_placeHolderColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor*)sea_placeHolderColor
{
    UIColor *color = objc_getAssociatedObject(self, &SeaImageCacheToolPlaceHolderColor);
    if(color == nil)
    {
        color = SeaImageBackgroundColorBeforeDownload;
    }
    
    return color;
}

- (void)setSea_originBackgroundColor:(UIColor *)sea_originBackgroundColor
{
    objc_setAssociatedObject(self, &SeaImageCacheToolOriginBackgroundColor, sea_originBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor*)sea_originBackgroundColor
{
    UIColor *color = objc_getAssociatedObject(self, &SeaImageCacheToolOriginBackgroundColor);
    if(color == nil)
        color = [UIColor clearColor];
    return color;
}

- (void)setSea_placeHolderImage:(UIImage *)sea_placeHolderImage
{
    objc_setAssociatedObject(self, &SeaImageCacheToolPlaceHolderImage, sea_placeHolderImage, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage*)sea_placeHolderImage
{
    if(self.sea_showLoadingActivity)
        return nil;

    UIImage *placeHolder = objc_getAssociatedObject(self, &SeaImageCacheToolPlaceHolderImage);
    if(placeHolder == nil)
    {
        return [UIImage imageNamed:@"placeHolder_image"];
    }
    return placeHolder;
}

- (void)setSea_originContentMode:(UIViewContentMode)sea_originContentMode
{
    objc_setAssociatedObject(self, &SeaOriginContentModeKey, [NSNumber numberWithInteger:sea_originContentMode], OBJC_ASSOCIATION_RETAIN);
}

- (UIViewContentMode)sea_originContentMode
{
    NSNumber *value = objc_getAssociatedObject(self, &SeaOriginContentModeKey);
    if(value)
    {
        return [value integerValue];
    }
    else
    {
        return UIViewContentModeScaleToFill;
    }
}

- (void)setSea_placeHolderContentMode:(UIViewContentMode)sea_placeHolderContentMode
{
    objc_setAssociatedObject(self, &SeaPlaceHolderContentModeKey, [NSNumber numberWithInteger:sea_placeHolderContentMode], OBJC_ASSOCIATION_RETAIN);
}

- (UIViewContentMode)sea_placeHolderContentMode
{
    NSNumber *value = objc_getAssociatedObject(self, &SeaPlaceHolderContentModeKey);
    if(value)
    {
        return [value integerValue];
    }
    else
    {
        return UIViewContentModeScaleAspectFit;
    }
}

- (void)setSea_actView:(UIActivityIndicatorView *)sea_actView
{
    objc_setAssociatedObject(self, &SeaImageCacheToolActivity, sea_actView, OBJC_ASSOCIATION_RETAIN);
}

- (UIActivityIndicatorView*)sea_actView
{
    return objc_getAssociatedObject(self, &SeaImageCacheToolActivity);
}

- (void)setSea_actStyle:(UIActivityIndicatorViewStyle)sea_actStyle
{
    objc_setAssociatedObject(self, &SeaImageCacheToolActivityStyle, [NSNumber numberWithInteger:sea_actStyle], OBJC_ASSOCIATION_RETAIN);
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

//设置加载状态
- (void)setupLoading:(BOOL) loading
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
            self.contentMode = self.sea_placeHolderContentMode;
            self.image = self.sea_placeHolderImage;
            self.backgroundColor = self.sea_placeHolderColor;
        }
        else
        {
            self.image = nil;
            self.backgroundColor = self.sea_placeHolderColor;
        }
    }
    
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

@end
