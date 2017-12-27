//
//  SeaImageBrowser.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import "SeaImageBrowser.h"
#import "UIImageView+SeaImageCacheTool.h"
#import "UIImageView+SeaCache.h"
#import "UIImage+Utilities.h"
#import "SeaBasic.h"

@implementation SeaImageBrowserCell

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

        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.sea_showLoadingActivity = YES;
        _imageView.sea_actStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _imageView.backgroundColor = [UIColor clearColor];
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
    if(_scrollView.zoomScale == 1.0)
    {
        [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
    }
    else
    {
        [_scrollView setZoomScale:1.0 animated:YES];
    }
}

- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if([self.delegate respondsToSelector:@selector(imageBrowserCellDidTap:)])
    {
        [self.delegate imageBrowserCellDidTap:self];
    }
}

#pragma mark- UIScrollView delegate


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(_imageView.image)
    {
        return self.imageView;
    }
    else
    {
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


/**重新布局图片当图片加载完成时
 */
- (void)layoutImageAfterLoad
{
    UIImage *image = self.imageView.image;
    if(image)
    {
        _imageView.frame = [self rectFromImage:image];
        _scrollView.contentSize = CGSizeMake(_scrollView.width, MAX(_scrollView.height, _imageView.height));
    }
    else
    {
        _imageView.frame = CGRectMake(0, 0, _scrollView.width, _scrollView.height);
        _scrollView.contentSize = CGSizeZero;
    }
}

/**计算imageView的位置大小
 */
- (CGRect)rectFromImage:(UIImage*) image
{
    CGSize size = [image shrinkWithSize:_scrollView.bounds.size type:SeaImageShrinkTypeWidth];
   return CGRectMake(MAX(0, (self.bounds.size.width - size.width) / 2.0), MAX((self.bounds.size.height - size.height) / 2.0, 0), size.width, size.height);
}

@end

@interface SeaImageBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,SeaImageBrowserCellDelegate>
{
    ///要显示的位置
    NSInteger _visibleIndex;
}
///图片集合
@property(nonatomic,readonly) UICollectionView *collectionView;

//是否正在动画
@property(nonatomic,assign) BOOL isAnimating;

///图片数量及正在显示的位置
@property(nonatomic,readonly) UILabel *msgLabel;

///是否需要动画显示图片
@property(nonatomic,assign) BOOL needShowWithAnimate;

///背景
@property(nonatomic,readonly) UIView *backgroundView;

/**以前的ViewController
 */
@property(nonatomic,weak) UIViewController *previousPresentViewController;

/**以前的弹出样式
 */
@property(nonatomic,assign) UIModalPresentationStyle previousPresentationStyle;

@end

@implementation SeaImageBrowser

/**构造方法
 *@param source 图片路径集合 ，数组元素是 NSString
 *@param index 当前显示的图片下标
 *@return 一个初始化的 SeaFullImagePreviewView 对象
 */
- (id)initWithSource:(NSArray*) source visibleIndex:(NSInteger) index
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.source = source;
        _visibleIndex = index;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SeaScreenWidth, SeaScreenHeight)];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.userInteractionEnabled = NO;
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = self.backgroundView.bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.backgroundView.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[SeaImageBrowserCell class] forCellWithReuseIdentifier:@"SeaImageBrowserCell"];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    if(index > 0)
    {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_visibleIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.backgroundView.height - 40.0, self.backgroundView.width, 20.0)];
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.textColor = [UIColor whiteColor];
    _msgLabel.font = [UIFont fontWithName:SeaMainFontName size:14.0];
    _msgLabel.shadowColor = [UIColor blackColor];
    _msgLabel.text = [NSString stringWithFormat:@"%d/%d", (int)_visibleIndex + 1, (int)self.source.count];
    _msgLabel.hidden = YES;
    [self.view addSubview:_msgLabel];
}

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark- property

- (NSInteger)visibleIndex
{
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    return indexPath.item;
}

#pragma mark- public method

/**显示全屏预览
 *@param show 是否显示
 *@param rect 起始位置大小，可以通过- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view 方法来获取
 *@param flag 是否动画
 */
- (void)setShowFullScreen:(BOOL) show fromRect:(CGRect) rect animate:(BOOL) flag
{
    CGFloat animatedDuration = 0.4;
    if(show)
    {
        UINavigationController *nav = [self createdInNavigationController];
        nav.navigationBar.translucent = YES;
        [nav setNavigationBarHidden:YES];
        
        UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        ///设置使背景透明
        if(_ios8_0_)
        {
            nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        else
        {
            self.previousPresentViewController = viewController;
            self.previousPresentationStyle = self.previousPresentViewController.modalPresentationStyle;
            self.previousPresentViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
        
        [viewController presentViewController:nav animated:NO completion:nil];
        
        self.previousFrame = rect;

        if([self.delegate respondsToSelector:@selector(imageBrowserWillEnterFullScreen:)])
        {
            [self.delegate imageBrowserWillEnterFullScreen:self];
        }

        self.needShowWithAnimate = flag;
        if(!flag)
        {
            [self showCompletion];
        }
    }
    else
    {
        self.statusBarHidden = NO;
        SeaImageBrowserCell *cell = (SeaImageBrowserCell*)[_collectionView.visibleCells firstObject];
        self.backgroundView.hidden = YES;
        self.msgLabel.hidden = YES;
        
        if(cell.imageView.image && flag)
        {
            if([self.delegate respondsToSelector:@selector(imageBrowserWillExistFullScreen:)])
            {
                [self.delegate imageBrowserWillExistFullScreen:self];
            }
            
            if(!CGRectIntersectsRect(self.view.frame, self.previousFrame))
            {
                self.isAnimating = YES;
                [UIView animateWithDuration:animatedDuration animations:^(void){

                    cell.scrollView.zoomScale = 1.5;
                    self.view.alpha = 0;
                }completion:^(BOOL finish){

                    self.isAnimating = NO;
                    [self dismiss];
                    if([self.delegate respondsToSelector:@selector(imageBrowserDidExistFullScreen:)])
                    {
                        [self.delegate imageBrowserDidExistFullScreen:self];
                    }
                }];
            }
            else
            {
                self.isAnimating = YES;
                [UIView animateWithDuration:animatedDuration animations:^(void){

                    if(self.previousImage)
                    {
                        cell.imageView.image = self.previousImage;
                    }
                    cell.imageView.frame = self.previousFrame;
                }completion:^(BOOL finish){

                    self.isAnimating = NO;
                    [self dismiss];
                    if([self.delegate respondsToSelector:@selector(imageBrowserDidExistFullScreen:)])
                    {
                        [self.delegate imageBrowserDidExistFullScreen:self];
                    }
                }];
            }
        }
        else
        {
            [self dismiss];
            if([self.delegate respondsToSelector:@selector(imageBrowserDidExistFullScreen:)])
            {
                [self.delegate imageBrowserDidExistFullScreen:self];
            }
        }
    }
}

///显示完成
- (void)showCompletion
{
    if([self.delegate respondsToSelector:@selector(imageBrowserDidEnterFullScreen:)])
    {
        [self.delegate imageBrowserDidEnterFullScreen:self];
    }

    self.view.userInteractionEnabled = YES;
    self.isAnimating = NO;
    self.msgLabel.hidden = NO;
    self.statusBarHidden = YES;
}

/**隐藏
 */
- (void)dismiss
{
    self.previousPresentViewController.modalPresentationStyle = self.previousPresentationStyle;
    [self dismissViewControllerAnimated:NO completion:nil];
}


/**重新加载数据
 */
- (void)reloadData
{
    [self.collectionView reloadData];
}


#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.source.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SeaImageBrowserCell" forIndexPath:indexPath];


    cell.scrollView.zoomScale = 1.0;
    cell.scrollView.contentSize = cell.bounds.size;

    cell.delegate = self;

    WeakSelf(self);
    [cell.imageView sea_setImageWithURL:[self.source objectAtIndex:indexPath.item] completion:^(UIImage *image, BOOL fromNetwork){

        if(!weakSelf.needShowWithAnimate)
        {
            [cell layoutImageAfterLoad];
        }
    }];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.needShowWithAnimate)
    {
        self.needShowWithAnimate = NO;

        NSString *url = [self.source objectAtIndex:indexPath.item];
        UIImage *image = [[SeaImageCacheTool sharedInstance] imageFromMemoryForURL:url thumbnailSize:CGSizeZero];
        if(!image)
        {
            image = [[SeaImageCacheTool sharedInstance] imageFromDiskForURL:url thumbnailSize:CGSizeZero];
        }
        
        SeaImageBrowserCell *cell1 = (SeaImageBrowserCell*)cell;
        
        if(!image)
        {
            image = cell1.imageView.sea_placeHolderImage;
        }
        self.view.userInteractionEnabled = NO;
        
        
        CGRect frame = [cell1 rectFromImage:image];
        cell1.imageView.frame = self.previousFrame;
        
        self.isAnimating = YES;
        [UIView animateWithDuration:0.4 animations:^(void){
            
            cell1.imageView.image = image;
            self.backgroundView.alpha = 1.0;
            cell1.imageView.frame = frame;
        }completion:^(BOOL finish){
            
            [cell1 layoutImageAfterLoad];
            [self showCompletion];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.bounds.origin.x / scrollView.width;
    _msgLabel.text = [NSString stringWithFormat:@"%d/%d", (int)index + 1, (int)self.source.count];
}


#pragma mark- SeaImageBrowserCell delegate

- (void)imageBrowserCellDidTap:(SeaImageBrowserCell *)cell
{
    if(self.isAnimating)
        return;

    if(cell.scrollView.zoomScale == 1.0)
    {
        [self setShowFullScreen:NO fromRect:CGRectZero animate:YES];
    }
    else
    {
        [cell.scrollView setZoomScale:1.0 animated:YES];
    }
}

@end
