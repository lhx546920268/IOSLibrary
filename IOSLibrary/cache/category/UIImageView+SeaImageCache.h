//
//  UIImageView+SeaImageCache.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UIView+SeaImageCache.h"

///图片缩略图
static char SeaImageCacheToolThumbnailSize;
/**
 加载图片类目
 */
@interface UIImageView (SeaImageCache)

/**缩略图大小 default is 'self.bounds.size',如果值 为CGSizeZero表示不使用缩略图，可设置bounds.size
 */
@property(nonatomic,assign) CGSize sea_thumbnailSize;

@end
