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

@interface SeaPageViewController ()<SeaMenuBarDelegate, UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation SeaPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuBar = [SeaMenuBar new];
    _menuBar.delegate = self;
    [self.container setTopView:_menuBar height:SeaMenuBarHeight];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.contentView = scrollView;
    self.scrollView = scrollView;
}

- (void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(self.view.width * 3, self.view.height);
}

#pragma mark- SeaMenuBarDelegate

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSUInteger)index
{
    
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
