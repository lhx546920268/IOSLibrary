//
//  UIImageView+SeaImageCache.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UIImageView+SeaImageCache.h"
#import <objc/runtime.h>

@implementation UIImageView (SeaImageCache)

- (void)setSea_thumbnailSize:(CGSize)sea_thumbnailSize
{
    objc_setAssociatedObject(self, &SeaImageCacheToolThumbnailSize, [NSValue valueWithCGSize:sea_thumbnailSize], OBJC_ASSOCIATION_RETAIN);
}

- (CGSize)sea_thumbnailSize
{
    NSValue *value = objc_getAssociatedObject(self, &SeaImageCacheToolThumbnailSize);

    return [value CGSizeValue];
}

- (void)sea_setLoading:(BOOL) loading options:(SeaImageCacheOptions*) options
{
    [super sea_setLoading:loading options:options];
    if(loading){
        if(options.placeholderImage){
            self.image = options.placeholderImage;
            self.contentMode = options.placeholderContentMode;
        }else{
            self.image = nil;
        }
    }
}

- (void)sea_imageDidLoad:(UIImage *)image
{
    self.image = image;
}

@end
