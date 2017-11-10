//
//  SeaRefreshControl.m
//  Sea
//
//

#import "SeaRefreshControl.h"
#import "SeaBasic.h"

@implementation SeaRefreshCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        _progress = 0.0;
    }
    
    return self;
}

- (void)setProgress:(float)progress
{
    if(_progress != progress)
    {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    //绘制圆环
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, SeaAppMainColor.CGColor);
    CGFloat startAngle = -M_PI / 3;
    CGFloat step = 11 * M_PI / 6 * self.progress; // 保留部分空白
    CGContextAddArc(context, self.bounds.size.width / 2, self.bounds.size.height / 2, self.bounds.size.width / 2 - 3, startAngle, startAngle+step, 0);
    CGContextStrokePath(context);
}

@end

/**刷新临界点 contentOffset
 */
static const CGFloat SeaRefreshControlCriticalPoint = 60.0f;

@interface SeaRefreshControl ()

/**是否加载完成 用于更新下拉状态信息
 */
@property(nonatomic,assign) BOOL finish;

@end

@implementation SeaRefreshControl

/**构造方法
 *@param scrollView x
 *@return 一个实例，frame和 scrollView的frame一样
 */
- (id)initWithScrollView:(UIScrollView*) scrollView
{
    self = [super initWithScrollView:scrollView];
    if(self)
    {
        // UIColor *textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
    //        _lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, self.frame.size.width, 20.0f)];
    //        _lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //        _lastUpdatedLabel.font = [UIFont fontWithName:12.0f];
    //        _lastUpdatedLabel.textColor = textColor;
    //        _lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    //        _lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    //        _lastUpdatedLabel.backgroundColor = [UIColor clearColor];
    //        [_lastUpdatedLabel setTextAlignment:NSTextAlignmentCenter];
    //        [self addSubview:_lastUpdatedLabel];
        
        
//        UIImage *image = [UIImage imageNamed:@"refresh_logo"];
//        _logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 20.0)];
//        _logo.contentMode = UIViewContentModeCenter;
//        _logo.image = image;
//        [self addSubview:_logo];
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indicatorView];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_indicatorView.right, 0, self.frame.size.width - _indicatorView.right, _indicatorView.height)];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont fontWithName:SeaMainFontName size:13.0f];
        _statusLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
//        _statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//        _statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _statusLabel.backgroundColor = [UIColor clearColor];
        [_statusLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_statusLabel];
        
        [self updatePosition];
        
        //        _circle = [[SeaRefreshCircle alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
        //        [self addSubview:_circle];
        
        [self setState:SeaDataControlNormal];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = (SeaRefreshControlCriticalPoint - _indicatorView.height) / 2.0;
    
    CGRect frame = self.bounds;
    frame.size.height = MAX(SeaRefreshControlCriticalPoint, - self.scrollView.contentOffset.y + self.originalContentInset.top);
    
    frame.origin.y = - frame.size.height;
    self.frame = frame;
    
    //  _statusLabel.top = self.height - _statusLabel.height - margin;
    //    _lastUpdatedLabel.top = _statusLabel.top - _lastUpdatedLabel.height;
    //    _circle.top = self.height - _circle.height - margin;
    
    _indicatorView.top = self.height - _statusLabel.height - margin;
   // _logo.top = self.height - _statusLabel.height - margin;
    _statusLabel.top = _indicatorView.top;
}

#pragma mark- kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat y = self.scrollView.contentOffset.y;
    if(y <= 0.0f  && [keyPath isEqualToString:SeaDataControlOffset])
    {
        if(self.state != SeaDataControlLoading)
        {
            if(self.scrollView.dragging)
            {
                if (y == 0.0f)
                {
                    [self setState:SeaDataControlNormal];
                }
                else if (y > - SeaRefreshControlCriticalPoint)
                {
                    [self setState:SeaDataControlPulling];
                }
                else
                {
                    [self setState:SeaDataControlReachCirticalPoint];
                }
            }
            else if(y <= - SeaRefreshControlCriticalPoint || self.state == SeaDataControlReachCirticalPoint)
            {
                if (self.isRefresh) {
                    
                    self.finish = YES;
                    
                    [self setState:SeaDataControlNormal];
                    
                    [self startRefresh];
                                        
                    return;
                }
                
                if(!self.animating)
                {
                    self.animating = YES;
                    [UIView animateWithDuration:0.25 animations:^(void){
                        
                        UIEdgeInsets inset = self.originalContentInset;
                        inset.top += SeaRefreshControlCriticalPoint;
                        self.scrollView.contentInset = inset;
                    }completion:^(BOOL finish){
                        
                        [self setState:SeaDataControlLoading];
                        self.animating = NO;
                    }];
                }
            }
        }
        
        if(!self.animating)
        {
            [self setNeedsLayout];
        }
    }
}

#pragma mark- dealloc

- (void)dealloc
{
    
}

#pragma mark- public method

/**用于后台主动刷新
 */
- (void)beginRefresh
{
    if(self.animating)
        return;
    self.animating = YES;
    [UIView animateWithDuration:0.25 animations:^(void){
        
        UIEdgeInsets inset = self.originalContentInset;
        inset.top = SeaRefreshControlCriticalPoint;
        self.scrollView.contentInset = inset;
        self.scrollView.contentOffset = CGPointMake(0, - SeaRefreshControlCriticalPoint);
        
    }completion:^(BOOL finish)
     {
         [self setState:SeaDataControlLoading];
         self.animating = NO;
     }];
}

/**更新刷新时间
 */
- (void)refreshLastUpdatedDate
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:DateFormatYMdHms];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:BeiJingTimeZone]];
    
    _lastUpdatedLabel.text = [NSString stringWithFormat:@"最后刷新: %@", [NSDate datetime:[formatter stringFromDate:date] formatString:DateFormatYMdHms]];
    
    NSString *key = self.lastUpdateDateKey;
    
    if(key == nil)
        key = @"SeaRefreshControl_LastRefresh";
    
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setState:(SeaDataControlState)aState
{
    
    switch (aState) {
        case SeaDataControlPulling :
        {
            //            float moveY = fabs(self.scrollView.contentOffset.y);
            //            if (moveY > SeaRefreshControlCriticalPoint)
            //                moveY = SeaRefreshControlCriticalPoint;
            //
            //            _circle.progress = moveY / SeaRefreshControlCriticalPoint;
            if (self.isRefresh) {
                
                _statusLabel.text = @"下拉回到商品详情";
            }
            else{
                
                _statusLabel.text = @"下拉刷新";
            }
            
            [self updatePosition];
        }
            break;
        case SeaDataControlReachCirticalPoint :
        {
            //            _circle.progress = 1.0; ///防止用户快速下拉 导致圆圈没有圆满
            if (self.isRefresh) {
                
                _statusLabel.text = @"释放回到商品详情";
            }
            else{
                
                _statusLabel.text = @"松开即可刷新";
            }
            [self updatePosition];
        }
            break;
        case SeaDataControlNormal :
        {
            //            if (self.state != SeaDataControlPulling)
            //            {
            //                _circle.progress = 0;
            //            }
            //
            if(!self.finish)
            {
                _statusLabel.text = @"下拉刷新";
                [self updatePosition];
            }
            //
            //            [self refreshLastUpdatedDate];
        }
            
            break;
        case SeaDataControlLoading :
        {
            _statusLabel.text = @"加载中...";
            
            [_indicatorView startAnimating];
            [self updatePosition];
            
            //旋转动画
//            CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            rotate.removedOnCompletion = FALSE;
//            rotate.fillMode = kCAFillModeForwards;
//            
//            [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
//            rotate.repeatCount = HUGE_VALF;
//            
//            rotate.duration = 0.25;
//            rotate.cumulative = TRUE;
//            rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//            [_logo.layer addAnimation:rotate forKey:@"rotateAnimation"];
            
            if(self.shouldDisableScrollViewWhenLoading)
            {
                self.scrollView.userInteractionEnabled = NO;
            }
            [self performSelector:@selector(startRefresh) withObject:nil afterDelay:self.refreshDelay];
        }
            break;
        case SeaDataControlStateNoData :
        {
            
        }
            break;
    }
    
    [super setState:aState];
}

//更新位置
- (void)updatePosition
{
    CGFloat width = _indicatorView.isAnimating ? _indicatorView.width : 0;
    CGSize size = [_statusLabel.text stringSizeWithFont:_statusLabel.font contraintWith:self.frame.size.width - width];
    _indicatorView.left = (self.frame.size.width - size.width - width) / 2.0;
    
    CGRect frame = _indicatorView.frame;
    frame.origin.x = _indicatorView.left + width + 3.0;
    frame.size.width = self.frame.size.width - _indicatorView.left - width;
    _statusLabel.frame = frame;
}

/**数据加载完成
 */
- (void)didFinishedLoading
{
//    double delayInSeconds = 0.2;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//       // [_logo.layer removeAllAnimations];
//    });
    
    [_indicatorView stopAnimating];
    self.finish = YES;
    _statusLabel.text = self.finishText;
    [self updatePosition];
    
    //[self setState:SeaDataControlNormal];
    
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:self.stopDelay];
}

//停止刷新
- (void)stopRefresh
{
    
    [UIView animateWithDuration:0.25 animations:^(void)
     {
         [self.scrollView setContentInset:self.originalContentInset];
     }
     completion:^(BOOL finish)
     {
         self.finish = NO;
         [self setState:SeaDataControlNormal];
         self.scrollView.userInteractionEnabled = YES;
     }];
}

//开始加载
- (void)startRefresh
{
    if(self.refreshBlock)
    {
        self.refreshBlock();
    }
}

@end
