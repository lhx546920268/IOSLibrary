//
//  SeaScrollView.m

//

#import "SeaScrollView.h"
#import "SeaBasic.h"


#define _startTag_ 3000

@interface SeaScrollView ()

///是否reloadData
@property(nonatomic,assign) BOOL isReloadData;

///起始位置
@property(nonatomic,assign) CGFloat contentOffsetX;

@end

@implementation SeaScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _enableScrollCircularly = NO;
        _showPageControl = NO;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scrollView.bounces = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator= NO;
        _scrollView.showsVerticalScrollIndicator= NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        _recyleCells = [[NSMutableSet alloc] init];
        _visibleCells = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _scrollView.frame = self.bounds;
}

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
                _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 20, self.width, 20)];
                _pageControl.hidesForSinglePage = YES;
                [_pageControl addTarget:self action:@selector(pageDidChange:) forControlEvents:UIControlEventValueChanged];
                [self addSubview:_pageControl];
            }
        }
        self.pageControl.hidden = !_showPageControl;
    }
}

//点击pageControl
- (void)pageDidChange:(UIPageControl*) pageControl
{
    [self scrollToIndex:pageControl.currentPage animated:YES];
}

#pragma mark- 内存管理

- (void)dealloc
{
    _scrollView.delegate = nil;
}

#pragma mark- property

- (NSInteger)visibleIndex
{
    UIView *cell = [_visibleCells anyObject];
    if(cell)
    {
        return [self getActualIndexFromIndex:cell.tag - _startTag_];
    }
    return NSNotFound;
}


#pragma mark- public method

//重新加载数据
- (void)reloadData
{
    self.isReloadData = YES;
    if([self.delegate respondsToSelector:@selector(numberOfCellsInScrollView:)])
    {
        _numberOfCells = [self.delegate numberOfCellsInScrollView:self];
    }
    else
    {
        _numberOfCells = 0;
    }
    
    if(self.enableScrollCircularly)
    {
        self.scrollView.contentSize = CGSizeMake(self.width * (self.numberOfCells > 0 ? self.numberOfCells + 2 : 0), self.height);
    }
    else
    {
         self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.numberOfCells, self.scrollView.height);
    }
    
    self.pageControl.numberOfPages = _numberOfCells;
    self.pageControl.currentPage = 0;
    
    if(_numberOfCells > 0)
    {
        if(_enableScrollCircularly)
        {
            [self scrollToIndex:1 animated:NO];
        }
        else
        {
            [self tilesPage];
        }
    }
    else
    {
        //移出cell
        for(UIView *view in self.subviews)
        {
            if(view.tag >= _startTag_)
            {
                [view removeFromSuperview];
            }
        }
        [_visibleCells removeAllObjects];
        [_recyleCells removeAllObjects];
    }
    self.isReloadData = NO;
}

//获取可复用的cell
- (id)dequeueRecycledCell
{
    UIView *cell = [_recyleCells anyObject];
    if (cell) {
        [_recyleCells removeObject:cell];
    }
    return cell;
}

/**滚动到指定的cell
 */
- (void)scrollToIndex:(NSInteger) index animated:(BOOL) flag
{
    [self.scrollView scrollRectToVisible:CGRectMake(index * self.width, 0, self.width, self.height) animated:flag];
    [self tilesPage];
}

- (BOOL)dragging
{
    return self.scrollView.dragging;
}

- (BOOL)decelerating
{
    return self.scrollView.decelerating;
}

/**通过下标获取 cell 如果cell是在可见范围内
 */
- (id)cellForIndex:(NSInteger) index
{
    for(UIView *cell in _visibleCells)
    {
        if(cell.tag - _startTag_ == index)
            return cell;
    }
    return nil;
}


#pragma mark- scrollView 代理

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.contentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.enableScrollCircularly)
    {
        CGFloat pagewidth = scrollView.width;
        int page = floor(scrollView.contentOffset.x / pagewidth);
        if(page == 0)
        {
            if(self.contentOffsetX > scrollView.contentOffset.x)
            {
                [self.scrollView scrollRectToVisible:CGRectMake(self.width * (_numberOfCells + 1), 0, pagewidth, scrollView.height) animated:NO]; // 最后+1,循环到第1页
                self.contentOffsetX = self.width * (_numberOfCells + 1);
            }
        }
        else if (page == (_numberOfCells + 1))
        {
            if(self.contentOffsetX < scrollView.contentOffset.x)
            {
                [self.scrollView scrollRectToVisible:CGRectMake(self.width, 0, pagewidth, scrollView.height) animated:NO]; // 最后+1,循环第1页
            }
        }
    }
    [self tilesPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(scrollView:didEndDeceleratingAndDraggingAtIndex:)])
    {
        NSInteger index = floorf(self.scrollView.contentOffset.x / self.width);
        [self.delegate scrollView:self didEndDeceleratingAndDraggingAtIndex:index];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        if([self.delegate respondsToSelector:@selector(scrollView:didEndDeceleratingAndDraggingAtIndex:)])
        {
            NSInteger index = floorf(self.scrollView.contentOffset.x / self.width);
            [self.delegate scrollView:self didEndDeceleratingAndDraggingAtIndex:index];
        }
    }
}

#pragma mark- private method


//加载cell
- (void)tilesPage
{
    if(_numberOfCells == 0)
        return;
    
    CGRect visibleBounds = _scrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds) - 1) / CGRectGetWidth(visibleBounds));
    
    firstNeededPageIndex = (int)MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = (int)MIN(lastNeededPageIndex, _enableScrollCircularly ? _numberOfCells + 1 : _numberOfCells - 1);
    
    
    // 复用不再可见的cell
    for (UIView *cell in _visibleCells) {
        
        if (cell.tag - _startTag_ < firstNeededPageIndex || cell.tag - _startTag_ > lastNeededPageIndex) {
            [_recyleCells addObject:cell];
            [cell removeFromSuperview];
        }
    }
    [_visibleCells minusSet:_recyleCells];
    
    // add missing pages
    if([self.delegate respondsToSelector:@selector(scrollView:cellForIndex:)])
    {
        for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++)
        {
            if (![self isDisplayingPageForIndex:index])
            {
                NSInteger pageIndex = [self getActualIndexFromIndex:index];
                
                UIView *cell = [self.delegate scrollView:self cellForIndex:pageIndex];
                
                [self configurePage:cell forIndex:index];
                
                [_scrollView addSubview:cell];
                
                [_visibleCells addObject:cell];
            }
        }
        
        //设置当前页码
        int page = _scrollView.contentOffset.x / _scrollView.width;
        self.pageControl.currentPage = [self getActualIndexFromIndex:page];
    }
    
}

//判断cell是否在可见范围内
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (UIView *cell in _visibleCells)
    {
        if (cell.tag - _startTag_ == index)
        {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

//设置cell的frame
- (void)configurePage:(UIView*)cell forIndex:(NSUInteger)index
{
    cell.left = cell.width * index;
    cell.tag = index + _startTag_;
    
    if([cell isKindOfClass:[SeaScrollViewCell class]])
    {
       SeaScrollViewCell *cell1 = (SeaScrollViewCell*)cell;
        if(cell1.enableGesture)
        {
            [cell1 addTarget:self action:@selector(cellDidSelect:)];
        }
    }
    
}


//点击cell
- (void)cellDidSelect:(id) sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    if([tap isKindOfClass:[UITapGestureRecognizer class]] && [self.delegate respondsToSelector:@selector(scrollView:didSelectCellAtIndex:)])
    {
        [self.delegate scrollView:self didSelectCellAtIndex:[self getActualIndexFromIndex:tap.view.tag - _startTag_]];
    }
}

//双击cell
- (void)cellDidDoubleTap:(id) sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    if([tap isKindOfClass:[UITapGestureRecognizer class]] && [self.delegate respondsToSelector:@selector(scrollView:didDoubleTapCellAtIndex:)])
    {
        [self.delegate scrollView:self didDoubleTapCellAtIndex:[self getActualIndexFromIndex:tap.view.tag - _startTag_]];
    }
}

//获取实际的内容下标
- (NSInteger)getActualIndexFromIndex:(NSInteger) index
{
    NSInteger pageIndex = index;
    if(_enableScrollCircularly)
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

@end
