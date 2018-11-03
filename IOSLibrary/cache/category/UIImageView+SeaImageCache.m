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


- (void)sea_setLoading:(BOOL) loading options:(SeaImageCacheOptions*) options
{
    [super sea_setLoading:loading options:options];
    if(loading){
        if(options.placeholderImage){
            self.image = options.placeholderImage;
            self.contentMode = options.placeholderContentMode;
        }else{
            if(options.resetImage){
                self.image = nil;
            }
        }
    }
}

- (void)sea_imageDidLoad:(UIImage *)image
{
    self.image = image;
}

@end
