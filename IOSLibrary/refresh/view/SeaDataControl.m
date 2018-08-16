//
//  SeaDataControl.m

//

#import "SeaDataControl.h"

@interface SeaDataControl()

///标题
@property(nonatomic, strong) NSMutableDictionary<NSNumber*, NSString*> *titles;

@end

@implementation SeaDataControl

- (id)initWithScrollView:(UIScrollView*) scrollView
{
    CGRect frame = scrollView.bounds;
    frame.size.height = 0;
    
    self = [super initWithFrame:frame];
    if(self){
        _scrollView = scrollView;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _originalContentInset = _scrollView.contentInset;
    self.loadingDelay = 0.4;
    self.stopDelay = 0.25;
    self.shouldDisableScrollViewWhenLoading = NO;
    self.backgroundColor = _scrollView.backgroundColor;
    
    self.titles = [NSMutableDictionary dictionary];
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
    if(self.stopDelay){
        [self performSelector:@selector(onStopLoading) withObject:nil afterDelay:self.stopDelay];
    }else{
        [self onStopLoading];
    }
}

- (void)onStopLoading
{
    [UIView animateWithDuration:0.25 animations:^(void){
        
         [self.scrollView setContentInset:self.originalContentInset];
     }completion:^(BOOL finish){
         
         [self setState:SeaDataControlStateNormal];
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
            case SeaDataControlStateLoading : {
                if(self.shouldDisableScrollViewWhenLoading){
                    self.scrollView.userInteractionEnabled = NO;
                }
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

- (void)setTitle:(NSString *)title forState:(SeaDataControlState)state
{
    [self.titles setObject:title forKey:@(state)];
    [self onStateChange:self.state];
}

- (NSString*)titleForState:(SeaDataControlState)state
{
    NSString *title = [self.titles objectForKey:@(state)];
    if(!title){
        return [self.titles objectForKey:@(SeaDataControlStateNormal)];
    }
    return title;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}

@end
