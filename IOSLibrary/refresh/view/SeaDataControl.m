//
//  SeaDataControl.m

//

#import "SeaDataControl.h"

@implementation SeaDataControl

- (id)initWithScrollView:(UIScrollView*) scrollView
{
    CGRect frame = scrollView.bounds;
    frame.size.height = 0;
    
    self = [super initWithFrame:frame];
    if(self){
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _originalContentInset = scrollView.contentInset;
        self.loadingDelay = 0.4;
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
    
    if(newSuperview){
        //添加 滚动位置更新监听
        [newSuperview addObserver:self forKeyPath:SeaDataControlOffset options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeFromSuperview
{
    [self.superview removeObserver:self forKeyPath:SeaDataControlOffset];
    [super removeFromSuperview];
}

#pragma mark dealloc

- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark public method

- (void)startLoading
{
    
}

- (void)stopLoading
{
    [self performSelector:@selector(onStopLoading) withObject:nil afterDelay:self.stopDelay];
}

- (void)onStopLoading
{
    [UIView animateWithDuration:0.25 animations:^(void){
        
         [self.scrollView setContentInset:self.originalContentInset];
     }completion:^(BOOL finish){
         
         [self setState:SeaDataControlNormal];
         self.scrollView.userInteractionEnabled = YES;
     }];
}

- (void)onStartLoading
{
    !self.handler ?: self.handler();
}

- (void)setState:(SeaDataControlState)state
{
    if(_state != state){
        _state = state;
        [self onStateChange:state];
        
        switch (_state) {
            case SeaDataControlPulling : {
                if(self.shouldDisableScrollViewWhenLoading){
                    self.scrollView.userInteractionEnabled = NO;
                }
                [self performSelector:@selector(onStartLoading) withObject:nil afterDelay:self.loadingDelay];
            }
                break;
            default:
                break;
        }
    }
}

- (void)onStateChange:(SeaDataControlState)state
{
    
}

@end
