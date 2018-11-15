//
//  SeaPageViewController.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/10.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaPageViewController.h"
#import "SeaContainer.h"
#import "UIView+SeaAutoLayout.h"
#import "UIView+Utils.h"
#import "SeaWebViewController.h"

///翻页cell
@interface SeaPageCollectionViewCell : UICollectionViewCell

///要显示的viewController
@property(nonatomic, strong) UIViewController *viewController;

///父
@property(nonatomic, weak) UIViewController *parentViewController;

@end

@implementation SeaPageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    
    return self;
}

- (void)setViewController:(UIViewController *)viewController
{
    if(_viewController != viewController || _viewController.view.superview == nil){
        if(_viewController){
            [_viewController removeFromParentViewController];
            [_viewController.view removeFromSuperview];
        }
        
        _viewController = viewController;
        [_viewController willMoveToParentViewController:self.parentViewController];
        [self.contentView addSubview:_viewController.view];
        [_viewController.view sea_insetsInSuperview:UIEdgeInsetsZero];
        [self.parentViewController addChildViewController:_viewController];
        [_viewController didMoveToParentViewController:self.parentViewController];
        
    }
}

@end

@interface SeaPageViewController ()<UIScrollViewDelegate>

///起始滑动位置
@property(nonatomic, assign) CGPoint beginOffset;

///是否需要滚动到对应位置
@property(nonatomic, assign) BOOL shouldScrollToPage;

@end

@implementation SeaPageViewController

@synthesize menuBar = _menuBar;
@synthesize pageViewControllers = _pageViewControllers;

- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldUseMenuBar = YES;
    _shouldSetMenuBarTopView = YES;
    self.menuBarHeight = SeaMenuBarHeight;
}

- (SeaMenuBar*)menuBar
{
    if(!self.shouldUseMenuBar)
        return nil;
    
    if(!_menuBar){
        _menuBar = [SeaMenuBar new];
        _menuBar.contentInset = UIEdgeInsetsMake(0, _menuBar.itemPadding, 0, _menuBar.itemPadding);
        _menuBar.delegate = self;
    }
    
    return _menuBar;
}

- (NSMutableArray<UIViewController*>*)pageViewControllers
{
    if(!_pageViewControllers){
        _pageViewControllers = [NSMutableArray arrayWithCapacity:self.numberOfPage];
    }
    
    return _pageViewControllers;
}

- (void)initialization
{
    if(self.shouldUseMenuBar && self.shouldSetMenuBarTopView){
        [self.container setTopView:self.menuBar height:self.menuBarHeight];
    }
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self registerClass:[SeaPageCollectionViewCell class]];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.bounces = NO;
    
    [super initialization];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if(!CGSizeEqualToSize(self.collectionView.frame.size, CGSizeZero) && !CGSizeEqualToSize(self.collectionView.frame.size, self.flowLayout.itemSize)){
        self.flowLayout.itemSize = self.collectionView.frame.size;
        if(self.shouldScrollToPage || self.menuBar.selectedIndex != 0){
            self.shouldScrollToPage = NO;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.menuBar.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        
        if(self.menuBar.selectedIndex < [self numberOfPage]){
            [self onScrollTopPage:self.menuBar.selectedIndex];
        }
    }
}

#pragma mark- public method

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)setPage:(NSUInteger) page animate:(BOOL) animate
{
    if(page >= [self numberOfPage]){
        return;
    }
    
    _currentPage = page;
    [self.menuBar setSelectedIndex:page animated:animate];
    if(self.isViewDidLayoutSubviews){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else{
        self.shouldScrollToPage = YES;
    }
}

- (UIViewController*)viewControllerForIndex:(NSUInteger) index
{
    return self.pageViewControllers[index];
}

- (NSInteger)numberOfPage
{
    if(self.shouldUseMenuBar){
        return self.menuBar.titles.count;
    }else{
        return 0;
    }
}

- (void)onScrollTopPage:(NSInteger)page
{
    
}

#pragma mark- SeaMenuBarDelegate

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSUInteger)index
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self onScrollTopPage:index];
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginOffset = scrollView.contentOffset;
    [self setScrollEnable:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    if(offset <= 0 || offset >= scrollView.width * (self.menuBar.titles.count - 1)){
        return;
    }
    
    //是否是向右滑动
    BOOL toRight = scrollView.contentOffset.x >= self.beginOffset.x;
    
    CGFloat width = scrollView.width;
    int index = (toRight ? offset : (offset + width)) / width;
    if(index != self.menuBar.selectedIndex)
        return;
    
    offset = (int)offset % (int)width;
    if(!toRight){
        offset = width - offset;
    }
    float percent = offset / width;
    
    //向左还是向右
    NSUInteger willIndex = toRight ? self.menuBar.selectedIndex + 1 : self.menuBar.selectedIndex - 1;

    [self.menuBar setPercent:percent forIndex:willIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate){
        [self scrollToVisibleIndex];
        [self setScrollEnable:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollToVisibleIndex];
    [self setScrollEnable:YES];
}

///滑动到可见位置
- (void)scrollToVisibleIndex
{
    NSInteger index = floor(self.scrollView.bounds.origin.x / self.scrollView.width);
    
    if(index != _currentPage){
        _currentPage = index;
        if(self.shouldUseMenuBar){
            if(index != self.menuBar.selectedIndex){
                [self.menuBar setSelectedIndex:index animated:YES];
            }
        }
        [self onScrollTopPage:_currentPage];
    }
}

///设置是否可以滑动
- (void)setScrollEnable:(BOOL) enable
{
    for(UIViewController *viewController in _pageViewControllers){
        if([viewController isKindOfClass:[SeaScrollViewController class]]){
            SeaScrollViewController *vc = (SeaScrollViewController*)viewController;
            vc.scrollView.scrollEnabled = enable;
        }else if ([viewController isKindOfClass:[SeaWebViewController class]]){
            SeaWebViewController *web = (SeaWebViewController*)viewController;
            web.webView.scrollView.scrollEnabled = enable;
        }
    }
}

#pragma mark- UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfPage];
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SeaPageCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.parentViewController = self;
    cell.viewController = [self viewControllerForIndex:indexPath.item];
    
    return cell;
}

@end
