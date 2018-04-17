//
//  SeaPageViewController.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/10.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaPageViewController.h"
#import "SeaMenuBar.h"
#import "SeaContainer.h"
#import "UIView+SeaAutoLayout.h"
#import "UIView+Utils.h"

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
        [_viewController didMoveToParentViewController:self.parentViewController];
    }
}

@end

@interface SeaPageViewController ()<SeaMenuBarDelegate, UIScrollViewDelegate>

///起始滑动位置
@property(nonatomic, assign) CGPoint beginOffset;

///是否需要滚动到对应位置
@property(nonatomic, assign) BOOL shouldScrollToPage;

@end

@implementation SeaPageViewController

@synthesize menuBar = _menuBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldUseMenuBar = YES;
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

- (void)initialization
{
    if(self.shouldUseMenuBar){
        [self.container setTopView:self.menuBar height:SeaMenuBarHeight];
    }
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self registerClass:[SeaPageCollectionViewCell class]];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.scrollsToTop = NO;
    
    [super initialization];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.flowLayout.itemSize = self.collectionView.frame.size;
    if(self.shouldScrollToPage){
        self.shouldScrollToPage = NO;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.menuBar.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
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
    return nil;
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
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginOffset = scrollView.contentOffset;
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
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollToVisibleIndex];
}

///滑动到可见位置
- (void)scrollToVisibleIndex
{
    //是否是向右滑动
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    if(indexPath.item != _currentPage){
        _currentPage = indexPath.item;
        if(self.shouldUseMenuBar){
            if(indexPath.item != self.menuBar.selectedIndex){
                [self.menuBar setSelectedIndex:indexPath.item animated:YES];
            }
        }
        [self onScrollTopPage:_currentPage];
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
    _currentViewController = [self viewControllerForIndex:indexPath.item];
    cell.viewController = _currentViewController;
    
    return cell;
}

@end
