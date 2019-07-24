//
//  SeaPhotosPreviewCell.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/22.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosPreviewCell.h"
#import "SeaTiledImageView.h"
#import "UIView+Utils.h"
#import "UIImage+Utils.h"

@implementation SeaPhotosPreviewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 5.0;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.bouncesZoom = YES;
        [self.contentView addSubview:_scrollView];
        
        _imageView = [[SeaTiledImageView alloc] initWithFrame:self.bounds];
        [_scrollView addSubview:_imageView];
        
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

//MARK: action

//双击
- (void)handleDoubleTap:(UITapGestureRecognizer*) tap
{
    if(_scrollView.zoomScale == 1.0){
        [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
    }else{
        [_scrollView setZoomScale:1.0 animated:YES];
    }
}


//MARK: UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(_imageView.image){
        return self.imageView;
    }else{
        return nil;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //缩放完后把视图居中
    CGFloat x = (self.width - _imageView.width) / 2;
    x = x < 0 ? 0 : x;
    CGFloat y = (self.height - _imageView.height) / 2;
    y = y < 0 ? 0 : y;
    
    _imageView.center = CGPointMake(x + _imageView.width / 2.0, y + _imageView.height / 2.0);
}

- (void)layoutImageAfterLoad
{
    UIImage *image = self.imageView.image;
    if(image){
        _imageView.frame = [self rectFromImage:image];
        _scrollView.contentSize = CGSizeMake(_scrollView.width, MAX(_scrollView.height, _imageView.height));
    }else{
        _imageView.frame = CGRectMake(0, 0, _scrollView.width, _scrollView.height);
        _scrollView.contentSize = CGSizeZero;
    }
}

- (CGRect)rectFromImage:(UIImage*) image
{
    CGSize size = [image sea_fitWithSize:_scrollView.bounds.size type:SeaImageFitTypeWidth];
    return CGRectMake(MAX(0, (self.bounds.size.width - size.width) / 2.0), MAX((self.bounds.size.height - size.height) / 2.0, 0), size.width, size.height);
}

@end
