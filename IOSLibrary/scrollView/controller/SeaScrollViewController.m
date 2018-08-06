//
//  SeaScrollViewController.m

//

#import "SeaScrollViewController.h"
#import "SeaBasic.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaRefreshControl.h"
#import "SeaLoadMoreControl.h"
#import "UIView+Utils.h"
#import "UIViewController+Keyboard.h"
#import "SeaPageViewController.h"

@interface SeaScrollViewController ()<UIScrollViewDelegate>

@end

@implementation SeaScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        self.curPage = 1;
    }
    return self;
}

#pragma mark- property

- (void)setScrollView:(UIScrollView *)scrollView
{
    if(_scrollView != scrollView){
        _scrollView = scrollView;
        if (@available(iOS 11.0, *)) {
            [_scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }
}

- (void)setRefreshEnable:(BOOL) refreshEnable
{
    if(_refreshEnable != refreshEnable){
#if SeaDebug
        NSAssert(_scrollView != nil, @"%@ 设置下拉刷新 scrollView 不能为nil", NSStringFromClass([self class]));
#endif
        _refreshEnable = refreshEnable;
        if(_refreshEnable){
            WeakSelf(self);
            [self.scrollView sea_addRefreshWithHandler:^(void){
               
                [weakSelf willRefresh];
            }];
        }else{
            [self.scrollView sea_removeRefreshControl];
        }
    }
}

- (void)setLoadMoreEnable:(BOOL)loadMoreEnable
{
    if(_loadMoreEnable != loadMoreEnable){
#if SeaDebug
        NSAssert(_scrollView != nil, @"%@ 设置上拉加载 scrollView 不能为nil", NSStringFromClass([self class]));
#endif
        _loadMoreEnable = loadMoreEnable;
        
        if(_loadMoreEnable){
            WeakSelf(self);
            [self.scrollView sea_addLoadMoreWithHandler:^(void){
               
                [weakSelf willLoadMore];
            }];
        }else{
            [self.scrollView sea_removeLoadMoreControl];
        }
    }
}

- (void)setLoadingMore:(BOOL)loadingMore
{
    _loadingMore = loadingMore;
}

//获取下拉属性控制视图
- (SeaRefreshControl*)refreshControl
{
    return self.scrollView.sea_refreshControl;
}

//获取上拉加载时的指示视图
- (SeaLoadMoreControl*)loadMoreControl
{
    return self.scrollView.sea_loadMoreControl;
}

- (void)setShouldShowScrollToTopButton:(BOOL)shouldShowScrollToTopButton
{
    if(_shouldShowScrollToTopButton != shouldShowScrollToTopButton){
        _shouldShowScrollToTopButton = shouldShowScrollToTopButton;
        if(_shouldShowScrollToTopButton){
            [self scrollViewDidScroll:self.scrollView];
        }else{
            self.showScrollToTopButton = NO;
        }
    }
}

#pragma mark- dealloc

- (void)dealloc
{
    [_scrollView sea_removeRefreshControl];
    [_scrollView sea_removeLoadMoreControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _shouldShowScrollToTopButton = YES;
}

- (BOOL)isInit
{
    return self.scrollView.superview != nil;
}

#pragma mark- public method

/**初始化视图 默认不做任何事 ，子类按需实现该方法
 */
- (void)initialization
{
    
}

#pragma mark- refresh

///将要触发下拉刷新
- (void)willRefresh
{
    if(self.loadingMore && !self.coexistRefreshAndLoadMore){
        self.curPage --;
        [self stopLoadMoreWithMore:true];
    }
    _refreshing = YES;
    [self onRefesh];
}

- (void)stopRefresh
{
    [self stopRefreshWithMsg:nil];
}

- (void)stopRefreshWithMsg:(NSString*) msg
{
    if(msg == nil)
        msg = @"刷新成功";
    self.refreshControl.finishText = msg;
    _refreshing = NO;
    [self.refreshControl stopLoading];
}

- (void)refreshManually
{
    [self.refreshControl startLoading];
}

- (void)onRefesh{}

#pragma mark- load more

///将要触发加载更多
- (void)willLoadMore
{
    if(self.refreshing && !self.coexistRefreshAndLoadMore){
        [self stopRefresh];
    }
    _loadingMore = YES;
    [self onLoadMore];
}

- (void)stopLoadMoreWithMore:(BOOL) flag
{
    _loadingMore = NO;
    if(flag){
        [self.loadMoreControl stopLoading];
    }else{
        
        [self.loadMoreControl noMoreInfo];
    }
}

- (void)loadMoreManually
{
    [self.loadMoreControl startLoading];
}

- (void)onLoadMore{}

#pragma mark- 键盘

/**
 键盘高度改变
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    [super keyboardWillChangeFrame:notification];
    UIEdgeInsets insets = self.contentInsets;
    if(!self.keyboardHidden){
        insets.bottom += self.keyboardFrame.size.height;
    }
    
    [UIView animateWithDuration:0.25 animations:^(void){
        
        self.scrollView.contentInset = insets;
    }];
}


- (UIButton*)scrollToTopButton
{
    if(!_scrollToTopButton){
        CGFloat margin = 15.0;
        UIImage *image = [UIImage imageNamed:@"scroll_to_top"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(scrollToTop:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.hidden = YES;
        [self.view addSubview:btn];
        
        [btn sea_rightToItem:_scrollView margin:margin];
        [btn sea_bottomToItem:_scrollView margin:margin];
        
        _scrollToTopButton = btn;
    }
    return _scrollToTopButton;
}

///设置是否显示回到顶部的按钮
- (void)setShowScrollToTopButton:(BOOL)showScrollToTopButton
{
    if(_showScrollToTopButton != showScrollToTopButton){
        _showScrollToTopButton = showScrollToTopButton;
        
        if(!self.scrollView)
            return;
        
        self.scrollToTopButton.hidden = !_showScrollToTopButton;
        [self.view bringSubviewToFront:self.scrollToTopButton];
    }
}

///回到顶部
- (void)scrollToTop:(id) sender
{
    self.showScrollToTopButton = NO;
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.shouldShowScrollToTopButton){
        self.showScrollToTopButton = scrollView.contentOffset.y >= self.scrollView.height * 3;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    ///防止左右滑动时触发上下滑动
    if([self.parentViewController isKindOfClass:[SeaPageViewController class]]){
        SeaPageViewController *page = (SeaPageViewController*)self.parentViewController;
        page.scrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self.loadMoreControl scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    
    if([self.parentViewController isKindOfClass:[SeaPageViewController class]]){
        SeaPageViewController *page = (SeaPageViewController*)self.parentViewController;
        page.scrollView.scrollEnabled = YES;
    }
}

@end
