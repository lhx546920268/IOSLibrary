//
//  SeaPhotosPreviewCell.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/22.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaTiledImageView, PHAsset;

///相册预览
@interface SeaPhotosPreviewCell : UICollectionViewCell

///滚动视图，用于图片放大缩小
@property(nonatomic,readonly) UIScrollView *scrollView;

///图片
@property(nonatomic,readonly) SeaTiledImageView *imageView;

///asset标识符
@property(nonatomic, strong) PHAsset *asset;

///重新布局图片当图片加载完成时
- (void)layoutImageAfterLoad;

///计算imageView的位置大小
- (CGRect)rectFromImage:(UIImage*) image;

@end

