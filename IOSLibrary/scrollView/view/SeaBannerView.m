//
//  SeaBannerView.m

//

#import "SeaBannerView.h"
#import "SeaBasic.h"
#import "UIView+Utils.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaCountDownTimer.h"
#import "UICollectionView+Utils.h"
#import <objc/message.h>

@implementation SeaPageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _pointSize = CGSizeMake(10, 10);
    }
    
    return self;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    return _pointSize;
}

@end

///布局
@interface SeaCollectionViewBannerLayout : UICollectionViewFlowLayout

/*
 两边图片大小比例 默认 1.0
 */
@property(nonatomic, assign) CGFloat bothScale;

/**
 两端透明度 default 1.0
 */
@property(nonatomic, assign) CGFloat bothAlpha;

@end

@implementation SeaCollectionViewBannerLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if([self shouldConfigAttributes]){
        //目标区域中包含的cell
        CGFloat width = self.collectionView.superview.frame.size.width * self.bothScale + self.minimumLineSpacing;
        
        NSArray *layoutAttributes = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
        CGRect visibleRect = CGRectZero;
        visibleRect.origin = self.collectionView.contentOffset;
        visibleRect.size = self.collectionView.bounds.size;
        
        //让中间的保持 1:1 两边的缩小
        for(UICollectionViewLayoutAttributes *attr in layoutAttributes){
            CGFloat distance = CGRectGetMidX(visibleRect) - attr.center.x;
            CGFloat normalizedDistance = distance / width / 2.0;
            CGFloat zoom = 1.0 - (1 - self.bothScale) * fabs(normalizedDistance);
            CGFloat alpha = 1.0 - (1 - self.bothAlpha) * fabs(normalizedDistance);
            attr.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0);
            attr.alpha = alpha;
            attr.zIndex = 1;
        }
        
        return layoutAttributes;
    }else{
        return [super layoutAttributesForElementsInRect:rect];
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    //滑动放大缩小  需要实时刷新layout
    return [self shouldConfigAttributes] ? YES : [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

///是否需要配置布局属性
- (BOOL)shouldConfigAttributes
{
    return self.bothAlpha != 1.0 || self.bothScale != 1.0;
}


@end

@interface SeaBannerView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/**
 计时器
 */
@property(nonatomic,strong) SeaCountDownTimer *timer;

/**
 起始位置
 */
@property(nonatomic,assign) CGPoint contentOffset;

/**
 是否需要循环滚动
 */
@property(nonatomic,assign) BOOL shouldScrollCircularly;

/**
 是否已经计算了
 */
@property(nonatomic,assign) BOOL isLayoutSubviews;

/**
 layout
 */
@property(nonatomic,strong) SeaCollectionViewBannerLayout *layout;

@end

@implementation SeaBannerView

- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection) scrollDirection
{
    self = [super initWithFrame:CGRectZero];
    if(self){
        _scrollDirection = scrollDirection;
        [self initialization];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}

- (void)initialization
{
    if(!_collectionView){
        _animatedTimeInterval = 5.0;
        _enableScrollCircularly = YES;
        _showPageControl = NO;
        _enableAutoScroll = YES;
        _bothScale = 1.0;
        _widthRatio = 1.0;
        _bothAlpha = 1.0;
        
        SeaCollectionViewBannerLayout *layout = [SeaCollectionViewBannerLayout new];
        layout.bothScale = _bothScale;
        layout.bothAlpha = _bothAlpha;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = _scrollDirection;
        self.layout = layout;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator= NO;
        _collectionView.showsVerticalScrollIndicator= NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        [self addSubview:_collectionView];
    }
}

//设置翻页范围
- (void)setPageRange
{
    if(self.isLayoutSubviews){
        CGFloat width = self.collectionView.frame.size.width;
        CGFloat interpageSpacing = -(1.0 - self.widthRatio) * width;
        
        //scrollView 宽度 - 翻页宽度
        ((void(*)(id, SEL, CGSize))objc_msgSend)(self.collectionView, NSSelectorFromString(@"_setInterpageSpacing:"), CGSizeMake(interpageSpacing + self.bothSpacing, 0));
        
        //interpageSpacing / 2
        ((void(*)(id, SEL, CGPoint))objc_msgSend)(self.collectionView, NSSelectorFromString(@"_setPagingOrigin:"), CGPointMake(interpageSpacing / 2.0, 0));
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if(_scrollDirection != scrollDirection){
        _scrollDirection = scrollDirection;
        self.layout.scrollDirection = _scrollDirection;
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if(self.isLayoutSubviews){
        if(newWindow){
            [self startAnimate];
        }else{
            [self stopAnimate];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.isLayoutSubviews = YES;
    
    CGRect frame = self.bounds;
    if(!CGRectEqualToRect(self.collectionView.frame, frame)){
        self.collectionView.frame = frame;
        [self setPageRange];
        [self fetchData];
    }
}

- (void)setWidthRatio:(CGFloat)widthRatio
{
    if(_widthRatio != widthRatio){
        _widthRatio = widthRatio;
        [self setPageRange];
        [self setNeedsLayout];
    }
}

- (void)setBothScale:(CGFloat)bothScale
{
    if(_bothScale != bothScale){
        _bothScale = bothScale;
        self.layout.bothScale = _bothScale;
        [self reloadData];
    }
}

- (void)setBothAlpha:(CGFloat)bothAlpha
{
    if(_bothAlpha != bothAlpha){
        _bothAlpha = bothAlpha;
        self.layout.bothAlpha = _bothAlpha;
        [self reloadData];
    }
}

- (void)setBothSpacing:(CGFloat)bothSpacing
{
    if(_bothSpacing != bothSpacing){
        _bothSpacing = bothSpacing;
        self.layout.minimumLineSpacing = bothSpacing;
        [self setPageRange];
    }
}

#pragma mark- public method

- (void)registerNib:(Class)clazz
{
    [self.collectionView registerNib:clazz];
}

- (void)registerClass:(Class)cellClas
{
    [self.collectionView registerClass:cellClas];
}

- (__kindof UICollectionViewCell*)dequeueReusableCellWithClass:(Class) cellClass forIndexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
}

- (__kindof UICollectionViewCell*)dequeueReusableCellWithReuseIdentifier:(NSString*) identifier forIndexPath:(nonnull NSIndexPath *)indexPath
{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData
{
    if(self.isLayoutSubviews){
        [self fetchData];
    }
}

- (void)fetchData
{
    if([self.delegate respondsToSelector:@selector(numberOfCellsInBannerView:)]){
        _numberOfCells = [self.delegate numberOfCellsInBannerView:self];
    }else{
        _numberOfCells = 0;
    }
    
    self.pageControl.numberOfPages = _numberOfCells;
    self.pageControl.currentPage = 0;
    
    self.shouldScrollCircularly = _numberOfCells > 1 && self.enableScrollCircularly;
    
    [self.collectionView reloadData];
    
    if(_numberOfCells > 0){
        [self scrollToIndex:0 animated:NO];
    }
    [self startAnimate];
}

- (void)scrollToIndex:(NSInteger) index animated:(BOOL) flag
{
    NSInteger count = _numberOfCells;
    if(self.shouldScrollCircularly){
        index += self.extensionCount / 2;
        count += self.extensionCount;
    }
    
    if(index < count){
        switch (_scrollDirection) {
            case UICollectionViewScrollDirectionHorizontal :
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:flag];
                break;
            case UICollectionViewScrollDirectionVertical :
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:flag];
                break;
        }
    }
}

- (BOOL)dragging
{
    return self.collectionView.dragging;
}

- (BOOL)decelerating
{
    return self.collectionView.decelerating;
}

- (UICollectionViewCell*)cellForIndex:(NSInteger) index
{
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

#pragma mark- timer

/**
 开始动画
 */
- (void)startAnimate
{
    if(!self.shouldScrollCircularly || !self.enableAutoScroll){
        [self stopAnimate];
        return;
    }
    
    if(!self.timer){
        WeakSelf(self);
        self.timer = [SeaCountDownTimer timerWithTime:SeaCountDownUnlimited interval:self.animatedTimeInterval];
        self.timer.tickHandler = ^(NSTimeInterval timeLeft){
            [weakSelf scrollAnimated];
        };
    }
    if(!self.timer.isExcuting){
        [self.timer start];
    }
}

/**
 结束动画
 */
- (void)stopAnimate
{
    if(self.timer && self.timer.isExcuting)
    {
        [self.timer stop];
    }
}

#pragma mark- property

- (void)setAnimatedTimeInterval:(NSTimeInterval)animatedTimeInterval
{
    if(_animatedTimeInterval != animatedTimeInterval){
        _animatedTimeInterval = animatedTimeInterval;
        BOOL excuting = self.timer.isExcuting;
        self.timer.timeInterval = animatedTimeInterval;
        if(excuting){
            [self.timer start];
        }
    }
}

- (void)setEnableScrollCircularly:(BOOL)enableScrollCircularly
{
    if(_enableScrollCircularly != enableScrollCircularly){
        _enableScrollCircularly = enableScrollCircularly;
        [self reloadData];
    }
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    if(_showPageControl != showPageControl){
        _showPageControl = showPageControl;
        if(_showPageControl){
            if(!self.pageControl){
                _pageControl = [SeaPageControl new];
                _pageControl.hidesForSinglePage = YES;
                [_pageControl addTarget:self action:@selector(pageDidChange:) forControlEvents:UIControlEventValueChanged];
                [self addSubview:_pageControl];
                
                [_pageControl sea_leftToSuperview:10];
                [_pageControl sea_rightToSuperview:10];
                [_pageControl sea_heightToSelf:20];
                [_pageControl sea_bottomToSuperview];
            }
        }
        self.pageControl.hidden = !_showPageControl;
    }
}

- (void)setEnableAutoScroll:(BOOL)enableAutoScroll
{
    if(_enableAutoScroll != enableAutoScroll){
        _enableAutoScroll = enableAutoScroll;
        if(_enableAutoScroll && !self.decelerating && !self.dragging){
            [self startAnimate];
        }else{
            [self stopAnimate];
        }
    }
}

- (NSInteger)visibleIndex
{
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    if(indexPath){
        return [self getActualIndexFromIndex:indexPath.item];
    }
    return NSNotFound;
}

#pragma mark private method

//点击pageControl
- (void)pageDidChange:(UIPageControl*) pageControl
{
    [self scrollToIndex:pageControl.currentPage animated:YES];
}

//获取实际的内容下标
- (NSInteger)getActualIndexFromIndex:(NSInteger) index
{
    NSInteger pageIndex = index;
    
    if(_shouldScrollCircularly){
        pageIndex = index - self.extensionCount / 2;
        if(pageIndex < 0){
            pageIndex += _numberOfCells;
        }
        
        if(pageIndex >= _numberOfCells){
            pageIndex = _numberOfCells - pageIndex;
        }
    }
    
    return pageIndex;
}

//扩展数量
- (NSInteger)extensionCount
{
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        return self.widthRatio == 1.0 ? 2 : 4;
    }else{
        return 2;
    }
}

//计时器滚动
- (void)scrollAnimated
{
    if(self.numberOfCells == 0)
        return;
    [self pageChangedWithAnimated:YES];
}

//滚动动画
- (void)pageChangedWithAnimated:(BOOL) flag
{
    NSInteger page = self.visibleIndex; // 获取当前的page
    if(page < self.numberOfCells){
        [self scrollToIndex:page + 1 animated:flag];
    }
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = _numberOfCells;
    if(self.shouldScrollCircularly){
        count += [self extensionCount];
    }
    
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = collectionView.bounds.size;
    size.width *= self.widthRatio;
    return size;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(bannerView:cellForIndexPath:atIndex:)]){
        return [self.delegate bannerView:self cellForIndexPath:indexPath atIndex:[self getActualIndexFromIndex:indexPath.item]];
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if([self.delegate respondsToSelector:@selector(bannerView:didSelectCellAtIndex:)]){
        [self.delegate bannerView:self didSelectCellAtIndex:[self getActualIndexFromIndex:indexPath.item]];
    }
}

#pragma mark- UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAnimate];
    self.contentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate){
        [self startAnimate];
      //  self.contentOffset = CGPointZero;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(!scrollView.dragging){
        [self startAnimate];
       // self.contentOffset = CGPointZero;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    switch (_scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal : {
            
            CGFloat pagewidth = scrollView.width * self.widthRatio + self.bothSpacing;
            CGFloat offsetX = (scrollView.width - scrollView.width * self.widthRatio) / 2.0;
            NSInteger page = floor((offsetX + scrollView.contentOffset.x) / pagewidth);
            
            if(self.shouldScrollCircularly){
                if(page == 0){
                    if(self.contentOffset.x > scrollView.contentOffset.x){
                        self.contentOffset = CGPointMake(pagewidth * (_numberOfCells + 1) - offsetX, 0);
                        [self.collectionView setContentOffset:self.contentOffset animated:NO];// 最后+1,循环到第1页
                        self.pageControl.currentPage = _numberOfCells - 1;
                    }
                }else if (page >= (_numberOfCells + [self extensionCount] / 2)){
                    if(self.contentOffset.x < floor(scrollView.contentOffset.x)){
                        [self.collectionView scrollRectToVisible:CGRectMake(pagewidth * [self extensionCount] / 2  - offsetX, 0, pagewidth, scrollView.height) animated:NO]; // 最后+1,循环第1页
                        self.pageControl.currentPage = 0;
                    }
                }else{
                    page = [self getActualIndexFromIndex:page];
                    self.pageControl.currentPage = page;
                }
            }else{
                self.pageControl.currentPage = page;
            }
        }
            break;
        case UICollectionViewScrollDirectionVertical : {
            CGFloat pageHeight = scrollView.height;
            int page = floor(scrollView.contentOffset.y / pageHeight);
            if(self.shouldScrollCircularly){
                if(page == 0){
                    if(self.contentOffset.y > scrollView.contentOffset.y){
                        [self.collectionView scrollRectToVisible:CGRectMake(0, pageHeight * (_numberOfCells + 1), scrollView.width, pageHeight) animated:NO]; // 最后+1,循环到第1页
                        self.contentOffset = CGPointMake(0, self.height * (_numberOfCells + 1));
                        self.pageControl.currentPage = _numberOfCells - 1;
                    }
                }else if (page >= (_numberOfCells + 1)){
                    if(self.contentOffset.y < scrollView.contentOffset.y){
                        [self.collectionView scrollRectToVisible:CGRectMake(0, pageHeight, scrollView.width, pageHeight) animated:NO]; // 最后+1,循环第1页
                        self.pageControl.currentPage = 0;
                    }
                }else{
                    self.pageControl.currentPage = [self getActualIndexFromIndex:page];
                }
            }else{
                self.pageControl.currentPage = page;
            }
        }
            break;
    }
}

@end
