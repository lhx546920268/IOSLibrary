//
//  SeaLoadMoreControl.m
//  Sea

//

#import "SeaLoadMoreControl.h"
#import "SeaBasic.h"

/**加载临界点 contentOffset
 */
static const CGFloat SeaLoadMoreControlCriticalPoint = 45.0;

/**文字提示内容改变
 */
static NSString *const SeaLoadMoreControlText = @"text";

/**UIScrollView 的内容大小
 */
static NSString *const SeaDataControlContentSize = @"contentSize";

@implementation SeaLoadMoreControl

- (id)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super initWithScrollView:scrollView];
    if(self)
    {;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityIndicatorView];
        
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _remindLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _remindLabel.font = [UIFont fontWithName:SeaMainFontName size:15.0];
        _remindLabel.backgroundColor = [UIColor clearColor];
        _remindLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_remindLabel addGestureRecognizer:tap];
        
        [self addSubview:_remindLabel];
        
        //添加文字改变kvo
        [_remindLabel addObserver:self forKeyPath:SeaLoadMoreControlText options:NSKeyValueObservingOptionNew context:NULL];
        
        [self setState:SeaDataControlStateNoData];
        
        self.autoLoadMore = YES;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //调整内容
    CGFloat margin = 5.0;
    CGFloat minHeight = SeaLoadMoreControlCriticalPoint;
    
    CGRect frame = self.frame;
    frame.size.height = MAX(minHeight, self.scrollView.contentOffset.y + self.scrollView.height - self.scrollView.contentSize.height);
    frame.origin.y = self.scrollView.contentSize.height;
    
    self.frame = frame;
    
    _activityIndicatorView.center = CGPointMake((self.width - _activityIndicatorView.width - _remindLabel.width - margin) / 2.0 + _activityIndicatorView.width / 2.0, minHeight / 2.0);
    
    frame = _remindLabel.frame;
    frame.origin.x = _activityIndicatorView.right + margin;
    frame.size.height = minHeight;
    _remindLabel.frame = frame;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if(newSuperview)
    {
        //添加 内容大小监听
        [newSuperview addObserver:self forKeyPath:SeaDataControlContentSize options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeFromSuperview
{
    [_remindLabel removeObserver:self forKeyPath:SeaLoadMoreControlText];
    [self.superview removeObserver:self forKeyPath:SeaDataControlContentSize];
    [super removeFromSuperview];
}

#pragma mark- dealloc

- (void)dealloc
{
    
}

#pragma mark- kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:SeaDataControlOffset])
    {
      
        if(self.state == SeaDataControlStateNoData || self.state == SeaDataControlLoading || self.hidden)
            return;
        
        if(CGSizeEqualToSize(self.scrollView.contentSize, CGSizeZero) && !self.loadMoreEnableWhileZeroContent)
        {
            return;
        }
        
        if(self.autoLoadMore)
        {
            
            if(self.scrollView.contentOffset.y >= self.scrollView.contentSize.height - self.scrollView.height - SeaLoadMoreControlCriticalPoint)
            {
                [self beginLoadMore:NO];
            }
        }
        else
        {
            if(self.scrollView.contentSize.height == 0 || self.scrollView.contentOffset.y < self.scrollView.contentSize.height - self.scrollView.height || self.scrollView.contentSize.height < self.scrollView.height)
                return;
            
            if(self.scrollView.contentOffset.y >= self.scrollView.contentSize.height - self.scrollView.height)
            {
                if(self.scrollView.dragging)
                {
                    if (self.scrollView.contentOffset.y == self.scrollView.contentSize.height - self.scrollView.height)
                    {
                        [self setState:SeaDataControlNormal];
                    }
                    else if (self.scrollView.contentOffset.y < self.scrollView.contentSize.height - self.scrollView.height + SeaLoadMoreControlCriticalPoint)
                    {
                        [self setState:SeaDataControlPulling];
                    }
                    else
                    {
                        [self setState:SeaDataControlReachCirticalPoint];
                    }
                }
                else if(self.scrollView.contentOffset.y >= self.scrollView.contentSize.height - self.scrollView.height + SeaLoadMoreControlCriticalPoint)
                {
                    if(!self.animating)
                    {
                        [self beginLoadMore:YES];
                    }
                }
            }
        }
        
        
        if(!self.animating)
        {
            [self setNeedsLayout];
        }
    }
    else if ([keyPath isEqualToString:SeaLoadMoreControlText])
    {
        //调整内容
        CGFloat margin = 5.0;
        CGFloat textWidth = [_remindLabel.text stringSizeWithFont:_remindLabel.font contraintWith:self.width - _activityIndicatorView.width - margin].width;
        _remindLabel.width = textWidth;
        [self setNeedsLayout];
    }
    else if ([keyPath isEqualToString:SeaDataControlContentSize])
    {
        [self setNeedsLayout];
    }
}

- (void)beginRefresh
{
    self.animating = NO;
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self beginLoadMore:YES];
}

/**开始加载更多
 */
- (void)beginLoadMore:(BOOL) animate
{
    if(self.animating)
        return;
    
    if(animate){
        self.animating = YES;
        [UIView animateWithDuration:0.25 animations:^(void){
            
            UIEdgeInsets inset = self.originalContentInset;
            inset.bottom += SeaLoadMoreControlCriticalPoint;
            self.scrollView.contentInset = inset;
        }completion:^(BOOL finish){
            
            [self setState:SeaDataControlLoading];
            self.animating = NO;
        }];
    }else{
        [self setState:SeaDataControlLoading];
        UIEdgeInsets inset = self.originalContentInset;
        inset.bottom += SeaLoadMoreControlCriticalPoint;
        self.scrollView.contentInset = inset;
        self.animating = NO;
    }
}

#pragma mark- 设置滑动状态

- (void)setState:(SeaDataControlState)state
{
    [self setState:state animated:NO];
}

- (void)setState:(SeaDataControlState) aState animated:(BOOL) flag
{
    switch (aState)
    {
        case SeaDataControlNormal :
        {
            self.remindLabel.hidden = NO;
            self.remindLabel.userInteractionEnabled = YES;
            self.remindLabel.text = @"加载更多";
            [self.activityIndicatorView stopAnimating];
            self.scrollView.contentInset = self.originalContentInset;
        }
            break;
        case SeaDataControlLoading :
        {
            if(self.shouldDisableScrollViewWhenLoading)
            {
                self.scrollView.userInteractionEnabled = NO;
            }
            if(self.autoLoadMore)
            {
                [self startRefresh];
            }
            else
            {
                [self performSelector:@selector(startRefresh) withObject:nil afterDelay:self.refreshDelay];
            }
        }
            break;
        case SeaDataControlPulling :
        {
            
        }
            break;
        case SeaDataControlReachCirticalPoint :
        {
            
        }
            break;
        case SeaDataControlStateNoData :
        {
            [_activityIndicatorView stopAnimating];
            self.remindLabel.text = @"已到底部";
            self.remindLabel.userInteractionEnabled = NO;
            self.remindLabel.hidden = YES;
            
            UIEdgeInsets inset = self.originalContentInset;
            inset.top = self.scrollView.contentInset.top;
            // inset.bottom = SeaLoadMoreControlCriticalPoint;
            if(flag)
            {
                [UIView animateWithDuration:0.25 animations:^(void){
                    
                    self.scrollView.contentInset = inset;
                }];
            }
            else
            {
                self.scrollView.contentInset = inset;
            }
        }
            break;
    }
    
    [super setState:aState];
}

/**数据加载完成
 */
- (void)didFinishedLoading
{
    [self stopRefresh];
}

/**已经没有更多信息可以加载
 */
- (void)noMoreInfo
{
    [self stopRefreshWithNoInfo];
    //[self performSelector:@selector(stopRefreshWithNoInfo) withObject:nil afterDelay:self.stopDelay];
}

- (void)stopRefreshWithNoInfo
{
    self.scrollView.userInteractionEnabled = YES;
    [self setState:SeaDataControlStateNoData animated:NO];
}

//停止刷新
- (void)stopRefresh
{
    self.scrollView.userInteractionEnabled = YES;
    self.remindLabel.userInteractionEnabled = YES;
    
    [self.scrollView setContentInset:self.originalContentInset];
    [self setState:SeaDataControlNormal animated:NO];
}

//开始加载
- (void)startRefresh
{
    [self layoutSubviews];
    _remindLabel.hidden = NO;
    _remindLabel.userInteractionEnabled = NO;
    _remindLabel.text = @"加载中...";
    [_activityIndicatorView startAnimating];
    !self.handler ?: self.handler();
}

#pragma mark- private method

- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if(self.state != SeaDataControlLoading)
    {
        [self setState:SeaDataControlLoading animated:YES];
    }
}

@end
