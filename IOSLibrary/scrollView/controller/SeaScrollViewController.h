//
//  SeaScrollViewController.h
//  Sea


#import "SeaViewController.h"
#import "UIScrollView+SeaDataControl.h"
#import "SeaEmptyView.h"

@protocol SeaEmptyViewDelegate;

/**滚动视图控制器，具有加载更多和下拉刷新，键盘弹出时设置contentInset功能，防止键盘挡住输入框
 */
@interface SeaScrollViewController : SeaViewController<SeaEmptyViewDelegate>

/**滚动视图 default is 'nil'
 */
@property(nonatomic,strong) UIScrollView *scrollView;

/**scroll view 原始的contentInsets
 */
@property(nonatomic,assign) UIEdgeInsets contentInsets;

/**是否可以下拉刷新数据
 */
@property(nonatomic,assign) BOOL refreshEnable;

/**下拉刷新视图 如果 enableDropDown = NO，nil
 */
@property(nonatomic,readonly) SeaRefreshControl *refreshControl;

/**
 加载更多和下拉刷是否可以共存 default is 'NO'
 */
@property(nonatomic,assign) BOOL coexistRefreshAndLoadMore;

/**是否可以加载更多数据 default is 'NO'
 */
@property(nonatomic,assign) BOOL loadMoreEnable;

/**加载更多时的指示视图 如果 enablePullUp = NO，nil
 */
@property(nonatomic,readonly) SeaLoadMoreControl *loadMoreControl;

/**当前第几页 default is '1'
 */
@property(nonatomic,assign) int curPage;

/**总数
 */
@property(nonatomic,assign) int totalCount;

/**是否正在刷新数据
 */
@property(nonatomic,readonly) BOOL refreshing;

/**是否正在加载更多
 */
@property(nonatomic,readonly) BOOL loadingMore;

/**显示回到顶部的按钮，滚动超过两屏后显示，否则隐藏
 */
@property(nonatomic,assign) BOOL showScrollToTopButton;

/**关键时刻是否需要显示回到顶部按钮 default is 'YES'
 */
@property(nonatomic,assign) BOOL shouldShowScrollToTopButton;

/**回到顶部按钮 图标 scroll_to_top
 */
@property(nonatomic,strong) UIButton *scrollToTopButton;

/**是否已初始化
 */
@property(nonatomic,readonly) BOOL isInit;

/**初始化视图 默认不做任何事 ，子类按需实现该方法
 */
- (void)initialization NS_REQUIRES_SUPER;

///以下的两个方法默认不做任何事，子类按需实现

/**触发下拉刷新
 */
- (void)onRefesh;

/**触发加载更多
 */
- (void)onLoadMore;

///以下的两个方法，刷新结束或加载结束时调用，如果子类重写，必须调用 super方法

- (void)stopRefresh NS_REQUIRES_SUPER;

/**结束下拉刷新
 *@param msg 提示的信息，nil则提示 “刷新成功”
 */
- (void)stopRefreshWithMsg:(NSString*) msg NS_REQUIRES_SUPER;

/**
 结束加载更多
 *@param flag 是否还有更多信息
 */
- (void)stopLoadMoreWithMore:(BOOL) flag NS_REQUIRES_SUPER;

/**
 加载更多失败
 */
- (void)stopLoadMoreWithFail NS_REQUIRES_SUPER;

/**手动调用下拉刷新，会有下拉动画
 */
- (void)refreshManually NS_REQUIRES_SUPER;

/**手动加载更多，会有上拉动画
 */
- (void)loadMoreManually NS_REQUIRES_SUPER;

///回到顶部
- (void)scrollToTop:(id) sender;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView NS_REQUIRES_SUPER;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView NS_REQUIRES_SUPER;

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_REQUIRES_SUPER;

@end
