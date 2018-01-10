//
//  SeaAutoScrollView.m

//

#import "SeaAutoScrollView.h"
#import "SeaBasic.h"
#import "UIView+Utils.h"

@implementation SeaPageControl

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    return CGSizeMake(10, 10);
}

@end

@interface SeaAutoScrollView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/**自动滚动计时器
 */
@property(nonatomic,strong) NSTimer *timer;

///起始位置
@property(nonatomic,assign) CGFloat contentOffsetX;

/**是否需要循环滚动
 */
@property(nonatomic,assign) BOOL shouldScrollCircularly;

@end

@implementation SeaAutoScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _animatedTimeInterval = 5.0;
        _enableScrollCircularly = YES;
        _showPageControl = NO;
        _enableAutoScroll = YES;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator= NO;
        _collectionView.showsVerticalScrollIndicator= NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(!CGRectEqualToRect(_collectionView.frame, self.bounds))
    {
        _collectionView.frame = self.bounds;
        _pageControl.top = self.height - _pageControl.height;
        [_collectionView reloadData];
    }
}

- (void)dealloc
{
    [self stopAnimate];
}

#pragma mark- public method

/**开始动画
 */
- (void)startAnimate
{
    if(!self.shouldScrollCircularly || !self.enableAutoScroll)
    {
        [self stopAnimate];
        return;
    }
    
    if(!self.timer)
    {
        self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:_animatedTimeInterval] interval:_animatedTimeInterval target:self selector:@selector(scrollAnimated:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

/**结束动画
 */
- (void)stopAnimate
{
    if(self.timer && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//重新加载数据
- (void)reloadData
{
    if([self.delegate respondsToSelector:@selector(numberOfCellsInScrollView:)])
    {
        _numberOfCells = [self.delegate numberOfCellsInScrollView:self];
    }
    else
    {
        _numberOfCells = 0;
    }
    
    
    self.pageControl.numberOfPages = _numberOfCells;
    self.pageControl.currentPage = 0;
    
    self.shouldScrollCircularly = _numberOfCells > 1 && self.enableScrollCircularly;
    
    [self.collectionView reloadData];
    
    if(_numberOfCells > 0)
    {
       [self scrollToIndex:0 animated:NO];
    }
}

/**滚动到指定的cell
 */
- (void)scrollToIndex:(NSInteger) index animated:(BOOL) flag
{
    NSInteger count = _numberOfCells;
    if(self.shouldScrollCircularly)
    {
        index ++;
        count += 2;
    }
    
    if(index < count)
    {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:flag];
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

/**通过下标获取 cell 如果cell是在可见范围内
 */
- (UICollectionViewCell*)cellForIndex:(NSInteger) index
{
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

#pragma mark- property

//设置是否可以循环滚动
- (void)setEnableScrollCircularly:(BOOL)enableScrollCircularly
{
    if(_enableScrollCircularly != enableScrollCircularly)
    {
        _enableScrollCircularly = enableScrollCircularly;
        [self reloadData];
    }
}

//设置是否显示页码
- (void)setShowPageControl:(BOOL)showPageControl
{
    if(_showPageControl != showPageControl)
    {
        _showPageControl = showPageControl;
        if(_showPageControl)
        {
            if(!self.pageControl)
            {
                _pageControl = [[SeaPageControl alloc] initWithFrame:CGRectMake(0, self.height - 20, self.width, 20)];
                _pageControl.hidesForSinglePage = YES;
                [_pageControl addTarget:self action:@selector(pageDidChange:) forControlEvents:UIControlEventValueChanged];
                [self addSubview:_pageControl];
            }
        }
        self.pageControl.hidden = !_showPageControl;
    }
}

- (void)setEnableAutoScroll:(BOOL)enableAutoScroll
{
    if(_enableAutoScroll != enableAutoScroll)
    {
        _enableAutoScroll = enableAutoScroll;
        if(_enableAutoScroll && !self.decelerating && !self.dragging)
        {
            [self startAnimate];
        }
        else
        {
            [self stopAnimate];
        }
    }
}

- (NSInteger)visibleIndex
{
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    if(indexPath)
    {
        return [self getActualIndexFromIndex:indexPath.item];
    }
    return NSNotFound;
}

#pragma mark- private method

//点击pageControl
- (void)pageDidChange:(UIPageControl*) pageControl
{
    [self scrollToIndex:pageControl.currentPage animated:YES];
}

//获取实际的内容下标
- (NSInteger)getActualIndexFromIndex:(NSInteger) index
{
    NSInteger pageIndex = index;
    
    if(_shouldScrollCircularly)
    {
        pageIndex = index - 1;
        if(pageIndex < 0)
        {
            pageIndex = _numberOfCells - 1;
        }
        if(pageIndex >= _numberOfCells)
        {
            pageIndex = 0;
        }
    }
    return pageIndex;
}

//计时器滚动
- (void)scrollAnimated:(id) sender
{
    if(self.numberOfCells == 0)
        return;
    [self pageChangedWithAnimated:YES];
}

//滚动动画
- (void)pageChangedWithAnimated:(BOOL) flag
{
    NSInteger page = self.visibleIndex; // 获取当前的page
    if(page < self.numberOfCells)
    {
        [self scrollToIndex:page + 1 animated:flag];
    }
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = _numberOfCells;
    if(self.shouldScrollCircularly)
    {
        count += 2;
    }
    
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(scrollView:cellForIndexPath:atIndex:)])
    {
        return [self.delegate scrollView:self cellForIndexPath:indexPath atIndex:[self getActualIndexFromIndex:indexPath.item]];
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if([self.delegate respondsToSelector:@selector(scrollView:didSelectCellAtIndex:)])
    {
        [self.delegate scrollView:self didSelectCellAtIndex:[self getActualIndexFromIndex:indexPath.item]];
    }
}

#pragma mark- UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAnimate];
    self.contentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self startAnimate];
        self.contentOffsetX = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(!scrollView.dragging)
    {
        [self startAnimate];
        self.contentOffsetX = 0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.shouldScrollCircularly)
    {
        CGFloat pagewidth = scrollView.width;
        int page = floor(scrollView.contentOffset.x / pagewidth);

        if(page == 0)
        {
            if(self.contentOffsetX > scrollView.contentOffset.x)
            {
                [self.collectionView scrollRectToVisible:CGRectMake(self.width * (_numberOfCells + 1), 0, pagewidth, scrollView.height) animated:NO]; // 最后+1,循环到第1页
                self.contentOffsetX = self.width * (_numberOfCells + 1);
                self.pageControl.currentPage = _numberOfCells - 1;
            }
        }
        else if (page >= (_numberOfCells + 1))
        {
            if(self.contentOffsetX < scrollView.contentOffset.x)
            {
                [self.collectionView scrollRectToVisible:CGRectMake(self.width, 0, pagewidth, scrollView.height) animated:NO]; // 最后+1,循环第1页
                self.pageControl.currentPage = 0;
            }
        }
        else
        {
            self.pageControl.currentPage = [self getActualIndexFromIndex:page];
        }
    }
}

@end
