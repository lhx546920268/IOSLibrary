//
//  SeaLoadMoreControl.m
//  Sea

//

#import "SeaLoadMoreControl.h"
#import "SeaBasic.h"
#import "UIView+Utils.h"
#import "NSString+Utils.h"

/**
 UIScrollView 的内容大小
 */
static NSString *const SeaDataControlContentSize = @"contentSize";

@interface SeaLoadMoreControl()

///是否需要动画
@property(nonatomic, assign) BOOL shouldAnimate;

@end

@implementation SeaLoadMoreControl

- (id)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super initWithScrollView:scrollView];
    if(self){
  
        self.criticalPoint = 45;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        
        [self setState:SeaDataControlStateNoData];
        self.autoLoadMore = YES;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //调整内容
    CGFloat minHeight = self.criticalPoint;
    
    CGRect frame = self.frame;
    frame.size.height = MAX(minHeight, self.scrollView.contentOffset.y + self.scrollView.height - self.scrollView.contentSize.height);
    frame.origin.y = self.scrollView.contentSize.height;
    
    self.frame = frame;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if(newSuperview){
        //添加 内容大小监听
        [newSuperview addObserver:self forKeyPath:SeaDataControlContentSize options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeFromSuperview
{
    [self.superview removeObserver:self forKeyPath:SeaDataControlContentSize];
    [super removeFromSuperview];
}

#pragma mark- kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:SeaDataControlOffset]){
      
        if(self.state == SeaDataControlStateNoData || self.state == SeaDataControlLoading || self.hidden)
            return;
        
        if(!self.loadMoreEnableWhileZeroContent && CGSizeEqualToSize(self.scrollView.contentSize, CGSizeZero)){
            return;
        }
        
        if(self.autoLoadMore){
            
            if(self.scrollView.contentOffset.y >= self.scrollView.contentSize.height - self.scrollView.height - self.criticalPoint){
                
                [self beginLoadMore:NO];
            }
        }else{
            if(self.scrollView.contentSize.height == 0 || self.scrollView.contentOffset.y < self.scrollView.contentSize.height - self.scrollView.height || self.scrollView.contentSize.height < self.scrollView.height)
                return;
            
            if(self.scrollView.contentOffset.y >= self.scrollView.contentSize.height - self.scrollView.height){
                
                if(self.scrollView.dragging){
                    if (self.scrollView.contentOffset.y == self.scrollView.contentSize.height - self.scrollView.height){
                        
                        [self setState:SeaDataControlNormal];
                    }else if (self.scrollView.contentOffset.y < self.scrollView.contentSize.height - self.scrollView.height + self.criticalPoint){
                        
                        [self setState:SeaDataControlPulling];
                    }else{
                        [self setState:SeaDataControlReachCirticalPoint];
                    }
                }else if(self.scrollView.contentOffset.y >= self.scrollView.contentSize.height - self.scrollView.height + self.criticalPoint){
                    
                    [self beginLoadMore:YES];
                }
            }
        }
        
        if(!self.animating){
            [self setNeedsLayout];
        }
    }else if ([keyPath isEqualToString:SeaDataControlContentSize]){
        
        [self setNeedsLayout];
    }
}

#pragma mark super method

- (void)startLoading
{
    [super startLoading];
    
    self.animating = NO;
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self beginLoadMore:YES];
    [self setNeedsLayout];
}

- (void)stopLoading
{
    [self.scrollView setContentInset:self.originalContentInset];
    [self setState:SeaDataControlNormal];
    self.scrollView.userInteractionEnabled = YES;
}

/**
 开始加载更多
 */
- (void)beginLoadMore:(BOOL) animate
{
    if(self.animating)
        return;
    
    if(animate){
        self.animating = YES;
        [UIView animateWithDuration:0.25 animations:^(void){
            
            UIEdgeInsets inset = self.originalContentInset;
            inset.bottom += self.criticalPoint;
            self.scrollView.contentInset = inset;
        }completion:^(BOOL finish){
            
            [self setState:SeaDataControlLoading];
            self.animating = NO;
        }];
    }else{
        
        [self setState:SeaDataControlLoading];
        UIEdgeInsets inset = self.originalContentInset;
        inset.bottom += self.criticalPoint;
        self.scrollView.contentInset = inset;
        self.animating = NO;
    }
}

- (void)onStateChange:(SeaDataControlState)state
{
    [super onStateChange:state];

    switch (state) {
        case SeaDataControlLoading : {
            if(self.autoLoadMore || self.loadingDelay <= 0){
                [self onStartLoading];
            }else{
                [self performSelector:@selector(onStartLoading) withObject:nil afterDelay:self.loadingDelay];
            }
        }
            break;
        case SeaDataControlStateNoData : {
            UIEdgeInsets inset = self.originalContentInset;
            inset.top = self.scrollView.contentInset.top;
            if(self.shouldStayWhileNoData){
                inset.bottom = self.criticalPoint;
            }
            if(self.shouldAnimate){
                [UIView animateWithDuration:0.25 animations:^(void){
                    
                    self.scrollView.contentInset = inset;
                }];
            }else{
                self.scrollView.contentInset = inset;
            }
        }
        default:
            break;
    }
}


- (void)noMoreInfo
{
    [self stopRefreshWithNoInfo];
}

- (void)stopRefreshWithNoInfo
{
    self.scrollView.userInteractionEnabled = YES;
    [self setState:SeaDataControlStateNoData];
}

#pragma mark action

- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if(self.state != SeaDataControlLoading && self.state != SeaDataControlStateNoData)    {
        [self setState:SeaDataControlLoading];
    }
}

@end
