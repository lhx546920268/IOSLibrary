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
    if(_viewController != viewController){
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

@end

@implementation SeaPageViewController
{
    SeaMenuBar *_menuBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (SeaMenuBar*)menuBar
{
    if(!_menuBar){
        _menuBar = [SeaMenuBar new];
        _menuBar.contentInset = UIEdgeInsetsMake(0, _menuBar.itemPadding, 0, _menuBar.itemPadding);
        _menuBar.delegate = self;
    }
    
    return _menuBar;
}

- (void)initialization
{
    [self.container setTopView:self.menuBar height:SeaMenuBarHeight];
    
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self registerClass:[SeaPageCollectionViewCell class]];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = NO;
    
    [super initialization];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.layout.itemSize = self.collectionView.frame.size;
}

#pragma mark- public method

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)setPage:(NSUInteger) page animate:(BOOL) animate
{
    [self.menuBar setSelectedIndex:page animated:animate];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (UIViewController*)viewControllerForIndex:(NSUInteger) index
{
    return nil;
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
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    if(indexPath.item != self.menuBar.selectedIndex){
        [self.menuBar setSelectedIndex:indexPath.item animated:YES];
    }
}

#pragma mark- UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuBar.titles.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SeaPageCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.parentViewController = self;
    cell.viewController = [self viewControllerForIndex:indexPath.item];
    
    return cell;
}

@end
