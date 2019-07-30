//
//  SeaPhotosPreviewCell.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/22.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosPreviewCell.h"
#import "UIView+Utils.h"
#import "UIImage+Utils.h"
#import "UIView+SeaAutoLayout.h"
#import <Photos/PHAsset.h>

@interface SeaPhotosPreviewCell()<UIScrollViewDelegate>

///图片
@property(nonatomic, strong) UIImageView *imageView;

///滚动视图，用于图片放大缩小
@property(nonatomic, strong) UIScrollView *scrollView;

///加载菊花
@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

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
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_scrollView addSubview:_imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

- (UIActivityIndicatorView*)indicatorView
{
    if(!_indicatorView){
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
        
        [_indicatorView sea_centerInSuperview];
    }
    
    return _indicatorView;
}

- (void)setLoading:(BOOL)loading
{
    if(_loading != loading){
        _loading = loading;
        if(_loading){
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = self.bounds.size;
            self.imageView.image = nil;
            [self.indicatorView startAnimating];
        }else{
            [_indicatorView stopAnimating];
        }
    }
}

//MARK: action

///双击
- (void)handleDoubleTap:(UITapGestureRecognizer*) tap
{
    if(_scrollView.zoomScale == 1.0){
        [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
    }else{
        [_scrollView setZoomScale:1.0 animated:YES];
    }
}

///单击
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if([self.delegate respondsToSelector:@selector(photosPreviewCellDidClick:)]){
        [self.delegate photosPreviewCellDidClick:self];
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

- (void)onLoadImage:(UIImage*) image
{
    self.loading = NO;
    if(image){
        _imageView.frame = [self rectFromImage:image];
        _scrollView.contentSize = CGSizeMake(_scrollView.width, MAX(_scrollView.height, _imageView.height));
    }else{
        _imageView.frame = CGRectMake(0, 0, _scrollView.width, _scrollView.height);
        _scrollView.contentSize = CGSizeZero;
    }
    self.imageView.image = image;
}

- (CGRect)rectFromImage:(UIImage*) image
{
    CGSize size = [UIImage sea_fitImageSize:CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight) size:_scrollView.bounds.size type:SeaImageFitTypeWidth];
    return CGRectMake(MAX(0, (self.bounds.size.width - size.width) / 2.0), MAX((self.bounds.size.height - size.height) / 2.0, 0), size.width, size.height);
}

@end
