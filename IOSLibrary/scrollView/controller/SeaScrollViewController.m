//
//  SeaScrollViewController.m

//

#import "SeaScrollViewController.h"
#import "SeaBasic.h"
#import "UIView+SeaAutoLayout.h"

@interface SeaScrollViewController ()<UIScrollViewDelegate>

@end

@implementation SeaScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.curPage = 1;
    }
    return self;
}

#pragma mark- property

- (void)setScrollView:(UIScrollView *)scrollView
{
    if(_scrollView != scrollView){
        _scrollView = scrollView;
        self.contentView = _scrollView;
    }
}

//设置是否可以下拉刷新数据
- (void)setRefreshEnable:(int)refreshEnable
{
    if(_refreshEnable != refreshEnable)
    {
#if SeaDebug
        NSAssert(_scrollView != nil, @"%@ 设置下拉刷新 scrollView 不能为nil", NSStringFromClass([self class]));
#endif
        _refreshEnable = refreshEnable;
        if(_refreshEnable)
        {
            WeakSelf(self);
            [self.scrollView addRefreshControlUsingBlock:^(void){
                
                [weakSelf reloadDataSource];
            }];
        }
        else
        {
            [self.scrollView removeRefreshControl];
        }
    }
}

//设置是否可以上拉加载数据
- (void)setLoadMoreEnable:(BOOL)loadMoreEnable
{
    if(_loadMoreEnable != loadMoreEnable)
    {
#if SeaDebug
        NSAssert(_scrollView != nil, @"%@ 设置上拉加载 scrollView 不能为nil", NSStringFromClass([self class]));
#endif
        _loadMoreEnable = loadMoreEnable;
        
        if(_loadMoreEnable)
        {
            WeakSelf(self);
            [self.scrollView addLoadMoreControlUsingBlock:^(void){
                
                [weakSelf setLoadingMore:YES];
                [weakSelf onLoadMore];
            }];
        }
        else
        {
            [self.scrollView removeLoadMoreControl];
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
    return self.scrollView.loadMoreControl;
}

- (void)setShouldShowScrollToTopButton:(BOOL)shouldShowScrollToTopButton
{
    if(_shouldShowScrollToTopButton != shouldShowScrollToTopButton)
    {
        _shouldShowScrollToTopButton = shouldShowScrollToTopButton;
        if(_shouldShowScrollToTopButton)
        {
            [self scrollViewDidScroll:self.scrollView];
        }
        else
        {
            self.showScrollToTopButton = NO;
        }
    }
}

#pragma mark- dealloc

- (void)dealloc
{
    [_scrollView removeRefreshControl];
    [_scrollView removeLoadMoreControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _shouldShowScrollToTopButton = YES;
}

#pragma mark- public method

/**初始化视图 默认不做任何事 ，子类按需实现该方法
 */
- (void)initialization
{
    
}

///以下的两个方法默认不做任何事，子类按需实现

/**触发下拉刷新
 */
- (void)onRefesh{}

/**触发上拉加载
 */
- (void)onLoadMore{}

///以下的两个方法，刷新结束或加载结束时调用，如果子类重写，必须调用 super方法

- (void)stopRefresh
{
    [self stopRefreshWithMsg:nil];
}

/**结束下拉刷新
 *@param msg 提示的信息，nil则提示 “刷新成功”
 */
- (void)stopRefreshWithMsg:(NSString*) msg
{
    if(msg == nil)
    msg = @"刷新成功";
    self.refreshControl.finishText = msg;
    _refreshing = NO;
    self.loadMoreControl.hidden = NO;
    [self.refreshControl didFinishedLoading];
}

/**结束上拉加载
 *@param flag 是否还有更多信息
 */
- (void)stopLoadMoreWithMore:(BOOL) flag
{
    _loadingMore = NO;
    if(flag){
        [self.loadMoreControl didFinishedLoading];
    }else{
        
        [self.loadMoreControl noMoreInfo];
    }
}

#pragma mark- 刷新数据

// 加载数据
- (void)reloadDataSource
{
    _refreshing = YES;
    [self onRefesh];
}

#pragma mark- manually

/**手动调用下拉刷新，会有下拉动画
 */
- (void)refreshManually
{
    self.loadMoreControl.hidden = YES;
    [self.refreshControl beginRefresh];
}

/**手动上拉加载，会有上拉动画
 */
- (void)loadMoreManually
{
    [self.loadMoreControl beginRefresh];
}

#pragma mark- 键盘

/**添加键盘监听
 */
- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

/**移除键盘监听
 */
- (void)removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

/**键盘高度改变
 */
- (void)keyboardWillChangeFrame:(NSNotification*) notification
{
    UIEdgeInsets insets = self.contentInsets;
    if(!self.keyboardHidden)
    {
        _keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        insets.bottom += _keyboardFrame.size.height;
    }
    
    [UIView animateWithDuration:0.25 animations:^(void){
        
        self.scrollView.contentInset = insets;
    }];
}

- (void)keyboardDidChangeFrame:(NSNotification*) notification
{
    
}

//键盘隐藏
- (void)keyboardWillHide:(NSNotification*) notification
{
    _keyboardHidden = YES;
    
    [self keyboardWillChangeFrame:notification];
}

//键盘显示
- (void)keyboardWillShow:(NSNotification*) notification
{
    _keyboardHidden = NO;
    [self keyboardWillChangeFrame:notification];
}

- (UIButton*)scrollToTopButton
{
    if(!_scrollToTopButton)
    {
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
    if(_showScrollToTopButton != showScrollToTopButton)
    {
        _showScrollToTopButton = showScrollToTopButton;
        
        if(!self.scrollView)
            return;
        
        self.scrollToTopButton.hidden = !_showScrollToTopButton;
        [self.view bringSubviewToFront:self.scrollToTopButton];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.shouldShowScrollToTopButton)
    {
        self.showScrollToTopButton = scrollView.contentOffset.y >= self.scrollView.height * 3;
    }
}

///回到顶部
- (void)scrollToTop:(id) sender
{
    self.showScrollToTopButton = NO;
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

@end
