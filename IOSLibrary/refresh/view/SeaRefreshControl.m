//
//  SeaRefreshControl.m
//  IOSLibrary
//
//

#import "SeaRefreshControl.h"
#import "SeaBasic.h"
#import "UIView+Utils.h"
#import "NSDate+Utils.h"
#import "NSString+Utils.h"

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

@interface SeaRefreshControl ()

@end

@implementation SeaRefreshControl

- (id)initWithScrollView:(UIScrollView*) scrollView
{
    self = [super initWithScrollView:scrollView];
    if(self){
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.criticalPoint = 60;
        [self setTitle:@"下拉刷新" forState:SeaDataControlStateNormal];
        [self setTitle:@"加载中..." forState:SeaDataControlStateLoading];
        [self setTitle:@"松开即可刷新" forState:SeaDataControlStateReachCirticalPoint];
        [self setState:SeaDataControlStateNormal];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.height = MAX(self.criticalPoint, - self.scrollView.contentOffset.y + self.originalContentInset.top);
    
    frame.origin.y = - frame.size.height;
    self.frame = frame;
}

#pragma mark kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat y = self.scrollView.contentOffset.y;
    if(y <= 0.0f  && [keyPath isEqualToString:SeaDataControlOffset]){
        
        if(self.state != SeaDataControlStateLoading){
            
            if(!self.animating){
                if(self.scrollView.dragging){
                    if (y == 0.0f){
                        
                        [self setState:SeaDataControlStateNormal];
                    }else if (y > - self.criticalPoint){
                        
                        [self setState:SeaDataControlStatePulling];
                    }else{
                        
                        [self setState:SeaDataControlStateReachCirticalPoint];
                    }
                }else if(y <= - self.criticalPoint || self.state == SeaDataControlStateReachCirticalPoint){
                    
                    [self startLoading];
                }
            }
        }
        
        if(!self.animating){
            [self setNeedsLayout];
        }
    }
}

#pragma mark super method

- (void)startLoading
{
    [super startLoading];
    if(self.animating)
        return;
    
    self.animating = YES;
    [UIView animateWithDuration:0.25 animations:^(void){
        
        UIEdgeInsets inset = self.originalContentInset;
        inset.top = self.criticalPoint;
        self.scrollView.contentInset = inset;
        self.scrollView.contentOffset = CGPointMake(0, - self.criticalPoint);
        
    }completion:^(BOOL finish){
         [self setState:SeaDataControlStateLoading];
         self.animating = NO;
    }];
}

- (void)onStateChange:(SeaDataControlState)state
{
    [super onStateChange:state];
    switch (state) {
        case SeaDataControlStateLoading : {
            if(self.loadingDelay > 0){
                [self performSelector:@selector(onStartLoading) withObject:nil afterDelay:self.loadingDelay];
            }else{
                [self onStartLoading];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
