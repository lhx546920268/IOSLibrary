//
//  SeaImageBrowseViewController.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/17.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaImageBrowseViewController.h"
#import "UIImageView+SeaImageCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Utils.h"
#import "UIView+Utils.h"
#import "UIViewController+Utils.h"
#import "SeaBasic.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaContainer.h"

@implementation SeaImageBrowseInfo

+ (instancetype)infoWithImage:(UIImage *)image
{
    SeaImageBrowseInfo *info = [SeaImageBrowseInfo new];
    info.image = image;
    
    return info;
}

+ (instancetype)infoWithURL:(NSString *)URL
{
    SeaImageBrowseInfo *info = [SeaImageBrowseInfo new];
    info.URL = URL;
    
    return info;
}

+ (instancetype)infoWithAsset:(ALAsset *)asset
{
    SeaImageBrowseInfo *info = [SeaImageBrowseInfo new];
    info.asset = asset;
    
    return info;
}

@end

@implementation SeaImageBrowseCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 5.0;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
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

//双击
- (void)handleDoubleTap:(UITapGestureRecognizer*) tap
{
    if(_scrollView.zoomScale == 1.0){
        [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
    }else{
        [_scrollView setZoomScale:1.0 animated:YES];
    }
}

- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if([self.delegate respondsToSelector:@selector(imageBrowseCellDidTap:)]){
        [self.delegate imageBrowseCellDidTap:self];
    }
}

#pragma mark- UIScrollView delegate

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
    CGFloat x = (self.frame.size.width - _imageView.frame.size.width) / 2;
    x = x < 0 ? 0 : x;
    CGFloat y = (self.frame.size.height - _imageView.frame.size.height) / 2;
    y = y < 0 ? 0 : y;
    
    _imageView.center = CGPointMake(x + _imageView.frame.size.width / 2.0, y + _imageView.frame.size.height / 2.0);
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

@interface SeaImageBrowseViewController ()<SeaImageBrowseCellDelegate>
{
    /**
     要显示的位置
     */
    NSInteger _visibleIndex;
}

/**
 是否正在动画
 */
@property(nonatomic,assign) BOOL isAnimating;

/**
 图片数量及正在显示的位置
 */
@property(nonatomic,readonly) UILabel *pageLabel;

/**
 是否需要动画显示图片
 */
@property(nonatomic,assign) BOOL shouldShowAnimate;

/**
 背景
 */
@property(nonatomic,readonly) UIView *backgroundView;

/**
 是否滑动到可见位置
 */
@property(nonatomic,assign) BOOL shouldScrollToVisible;

@end

@implementation SeaImageBrowseViewController

- (instancetype)initWithImages:(NSArray<UIImage *> *)images visibleIndex:(NSInteger)visibleIndex
{
    self = [super init];
    if(self){
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:images.count];
        for(UIImage *image in images){
            [infos addObject:[SeaImageBrowseInfo infoWithImage:image]];
        }
        _infos = [infos copy];
        _visibleIndex = visibleIndex;
    }
    
    return self;
}

- (instancetype)initWithURLs:(NSArray<NSString *> *)URLs visibleIndex:(NSInteger)visibleIndex
{
    self = [super init];
    if(self){
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:URLs.count];
        for(NSString *URL in URLs){
            [infos addObject:[SeaImageBrowseInfo infoWithURL:URL]];
        }
        _infos = [infos copy];
        _visibleIndex = visibleIndex;
    }
    
    return self;
}

- (instancetype)initWithAssets:(NSArray<ALAsset *> *)assets visibleIndex:(NSInteger)visibleIndex
{
    self = [super init];
    if(self){
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:assets.count];
        for(ALAsset *asset in assets){
            [infos addObject:[SeaImageBrowseInfo infoWithAsset:asset]];
        }
        _infos = [infos copy];
        _visibleIndex = visibleIndex;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.container.safeLayoutGuide = SeaSafeLayoutGuideNone;
    self.animateDuration = 0.25;
    _backgroundView = [UIView new];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.userInteractionEnabled = NO;
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];
    
    [_backgroundView sea_insetsInSuperview:UIEdgeInsetsZero];
    
    self.shouldScrollToVisible = YES;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self registerClass:[SeaImageBrowseCell class]];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.pagingEnabled = YES;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [super initialization];
    
    _pageLabel = [UILabel new];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.font = [UIFont fontWithName:SeaMainFontName size:14.0];
    _pageLabel.shadowColor = [UIColor blackColor];
    _pageLabel.text = [NSString stringWithFormat:@"%d/%d", (int)_visibleIndex + 1, (int)self.infos.count];
    _pageLabel.hidden = YES;
    [self.view addSubview:_pageLabel];
    
    [_pageLabel sea_leftToSuperview];
    [_pageLabel sea_rightToSuperview];
    [_pageLabel sea_bottomToSuperview:20];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(self.shouldScrollToVisible && _visibleIndex > 0){
        self.shouldScrollToVisible = NO;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_visibleIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

#pragma mark- property

- (NSUInteger)visibleIndex
{
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    if(indexPath){
        return indexPath.item;
    }else{
        return _visibleIndex;
    }
}

#pragma mark- public method

- (void)showAnimate:(BOOL) animate
{
    UIViewController *viewController = [[UIApplication sharedApplication].keyWindow.rootViewController sea_topestPresentedViewController];
    ///设置使背景透明
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [viewController presentViewController:self animated:NO completion:nil];
    
    if([self.delegate respondsToSelector:@selector(imageBrowseViewControllerWillEnterFullScreen:)]){
        [self.delegate imageBrowseViewControllerWillEnterFullScreen:self];
    }
    
    self.shouldShowAnimate = animate;
    if(!animate){
        [self showCompletion];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return self.sea_statusBarHidden;
}

///显示完成
- (void)showCompletion
{
    if([self.delegate respondsToSelector:@selector(imageBrowseViewControllerDidEnterFullScreen:)]){
        [self.delegate imageBrowseViewControllerDidEnterFullScreen:self];
    }
    
    self.view.userInteractionEnabled = YES;
    self.isAnimating = NO;
    self.pageLabel.hidden = NO;
    self.sea_statusBarHidden = YES;
}

- (void)dismissAimate:(BOOL)animate
{
    self.sea_statusBarHidden = NO;
    SeaImageBrowseCell *cell = (SeaImageBrowseCell*)[self.collectionView.visibleCells firstObject];
    self.backgroundView.hidden = YES;
    self.pageLabel.hidden = YES;
    
    CGRect rect = [self animatedRect];
    
    
    if(cell.imageView.image && animate){
        if([self.delegate respondsToSelector:@selector(imageBrowseViewControllerWillExistFullScreen:)]){
            [self.delegate imageBrowseViewControllerWillExistFullScreen:self];
        }

        if(!CGRectIntersectsRect(self.view.frame, rect)){
            self.isAnimating = YES;
            [UIView animateWithDuration:self.animateDuration animations:^(void){
                
                cell.scrollView.zoomScale = 1.5;
                self.view.alpha = 0;
            }completion:^(BOOL finish){
                
                self.isAnimating = NO;
                [self dismiss];
                if([self.delegate respondsToSelector:@selector(imageBrowseViewControllerDidExistFullScreen:)]){
                    [self.delegate imageBrowseViewControllerDidExistFullScreen:self];
                }
            }];
        }else{
            self.isAnimating = YES;
            [UIView animateWithDuration:self.animateDuration animations:^(void){
                
                cell.imageView.frame = rect;
     
            }completion:^(BOOL finish){
                
                self.isAnimating = NO;
                [self dismiss];
                if([self.delegate respondsToSelector:@selector(imageBrowseViewControllerDidExistFullScreen:)]){
                    [self.delegate imageBrowseViewControllerDidExistFullScreen:self];
                }
            }];
        }
    }else{
        [self dismiss];
        if([self.delegate respondsToSelector:@selector(imageBrowseViewControllerDidExistFullScreen:)]){
            [self.delegate imageBrowseViewControllerDidExistFullScreen:self];
        }
    }
}

///获取当前动画需要的rect
- (CGRect)animatedRect
{
    CGRect rect = CGRectZero;
    if(self.animatedViewHandler){
        UIView *view = self.animatedViewHandler(self.visibleIndex);
        if(view.superview){
            rect = [view.superview convertRect:view.frame toView:self.view];
        }
    }
    
    return rect;
}

/**隐藏
 */
- (void)dismiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaImageBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SeaImageBrowseCell class]) forIndexPath:indexPath];
    
    cell.scrollView.zoomScale = 1.0;
    cell.scrollView.contentSize = cell.bounds.size;
    
    SeaImageBrowseInfo *info = [self.infos objectAtIndex:indexPath.item];
    WeakSelf(self);
    
    if(info.image){
        [cell.imageView sea_cancelDownloadImage];
        cell.imageView.image = info.image;
    }else if(info.asset){
        UIImage *image = [UIImage sea_imageFromAsset:info.asset];
        info.image = image;
        [cell.imageView sea_cancelDownloadImage];
        cell.imageView.image = image;
    }else{
        SeaImageCacheOptions *options = [SeaImageCacheOptions defaultOptions];
        options.shouldShowLoadingActivity = YES;
        options.shouldAspectRatioFit = NO;
        options.originalContentMode = UIViewContentModeScaleAspectFill;
        options.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        [cell.imageView sea_setImageWithURL:info.URL options:options completion:^(UIImage *image){
            
            if(!weakSelf.shouldShowAnimate)
            {
                [cell layoutImageAfterLoad];
            }
        }];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.shouldShowAnimate){
        self.shouldShowAnimate = NO;
        
        UIImage *image = nil;
        SeaImageBrowseInfo *info = [self.infos objectAtIndex:indexPath.item];
        if(info.image){
            image = info.image;
        }else if (info.asset){
            image = [UIImage sea_imageFromAsset:info.asset];
            info.image = image;
        }else{
            image = [[SeaImageCacheTool sharedInstance] imageFromMemoryForURL:info.URL thumbnailSize:CGSizeZero];
            if(!image){
                image = [[SeaImageCacheTool sharedInstance] imageFromDiskForURL:info.URL thumbnailSize:CGSizeZero];
            }
        }
        
        SeaImageBrowseCell *cell1 = (SeaImageBrowseCell*)cell;
        
        if(!image){
            image = [SeaImageCacheOptions defaultOptions].placeholderImage;
        }
        if(image){
            self.view.userInteractionEnabled = NO;
            
            CGRect frame = [cell1 rectFromImage:image];
            CGRect rect = [self animatedRect];
            
            cell1.imageView.frame = rect;
            
            self.isAnimating = YES;
            [UIView animateWithDuration:self.animateDuration animations:^(void){
                
                cell1.imageView.image = image;
                self.backgroundView.alpha = 1.0;
                cell1.imageView.frame = frame;
            }completion:^(BOOL finish){
                
                [cell1 layoutImageAfterLoad];
                [self showCompletion];
            }];
        }else{
            self.backgroundView.alpha = 1.0;
        }
    }
}

#pragma mark- UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.bounds.origin.x / scrollView.width;
    _pageLabel.text = [NSString stringWithFormat:@"%d/%d", (int)index + 1, (int)self.infos.count];
}

#pragma mark- SeaImageBrowseCell delegate

- (void)imageBrowseCellDidTap:(SeaImageBrowseCell *)cell
{
    if(self.isAnimating)
        return;
    
    if(cell.scrollView.zoomScale == 1.0){
        [self dismissAimate:YES];
    }else{
        [cell.scrollView setZoomScale:1.0 animated:YES];
    }
}

@end
