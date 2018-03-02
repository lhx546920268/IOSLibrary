//
//  SeaTiledImageView+SeaImageCache.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/3/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaTiledImageView+SeaImageCache.h"

@implementation SeaTiledImageView (SeaImageCache)

- (void)sea_setLoading:(BOOL) loading options:(SeaImageCacheOptions*) options
{
    [super sea_setLoading:loading options:options];
    if(loading){
        if(options.placeholderImage){
            self.contentMode = options.placeholderContentMode;
            self.image = options.placeholderImage;
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
