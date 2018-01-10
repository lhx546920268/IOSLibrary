//
//  SeaHighlightView.m

//

#import "SeaHighlightView.h"


@interface SeaHighlightView ()

//正在动画中
@property(nonatomic,assign) BOOL isAnimating;

//方法
@property(nonatomic,weak) id target;
@property(nonatomic,assign) SEL selector;

@end

@implementation SeaHighlightView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _highlightView = [[UIView alloc] initWithFrame:self.bounds];
        _highlightView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        _highlightView.userInteractionEnabled = NO;
        _highlightView.hidden = YES;
        [self addSubview:_highlightView];
        self.isAnimating = NO;
    }
    
    return self;
}

- (void)dealloc
{
    self.selector = nil;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _highlightView.frame = self.bounds;
}

#pragma mark- public method

/**开始点击 当手势为UITapGestureRecognizer时， 在处理手势的方法中调用该方法
 */
- (void)touchBegan
{
    if(!_highlightView.hidden)
        return;
    [self bringSubviewToFront:_highlightView];
    _highlightView.alpha = 1.0;
    _highlightView.hidden = NO;
}

/**结束点击 当手势为UITapGestureRecognizer时， 在处理手势的方法中调用该方法
 */
- (void)touchEnded
{
    if(self.isAnimating)
        return;
    self.isAnimating = YES;
    [UIView animateWithDuration:0.5 animations:^(void){
        _highlightView.alpha = 0;
    }completion:^(BOOL finish){
        _highlightView.hidden = YES;
        self.isAnimating = NO;
    }];
}

/**添加单击手势
 */
- (void)addTarget:(id)target action:(SEL)selector
{
    self.target = target;
    self.selector = selector;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
}


#pragma mark- touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchBegan];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEnded];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEnded];
}

#pragma mark- private method

- (void)handleTap:(UITapGestureRecognizer*) tap
{
    [self touchBegan];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
    [self touchEnded];
}


@end
