//
//  SeaDataControl.m

//

#import "SeaDataControl.h"

@implementation SeaDataControl

/**构造方法
 *@param scrollView x
 *@return 一个实例，frame和 scrollView的frame一样
 */
- (id)initWithScrollView:(UIScrollView*) scrollView
{
    CGRect frame = scrollView.bounds;
    frame.size.height = 0;
    
    self = [super initWithFrame:frame];
    if(self)
    {
        _originalContentInset = scrollView.contentInset;
        self.refreshDelay = 0.4;
        self.stopDelay = 0.25;
        self.shouldDisableScrollViewWhenLoading = NO;
        _scrollView = scrollView;
        self.backgroundColor = _scrollView.backgroundColor;
    }
    return self;
}

//将要添加到父视图中
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if(newSuperview)
    {
        //添加 滚动位置更新监听
        [newSuperview addObserver:self forKeyPath:SeaDataControlOffset options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeFromSuperview
{
    [self.superview removeObserver:self forKeyPath:SeaDataControlOffset];
    [super removeFromSuperview];
}

#pragma mark- dealloc

- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
}



#pragma mark- public method

/**用于后台主动刷新
 */
- (void)beginRefresh
{
    
}

/**数据加载完成
 */
- (void)didFinishedLoading
{
    
}


@end
