//
//  SeaNetworkActivityView.m

//

#import "SeaNetworkActivityView.h"
#import "SeaBasic.h"

@interface SeaNetworkActivityView ()

//加载指示器
@property(nonatomic,strong) UIActivityIndicatorView *actView;

///**加载logo
// */
//@property(nonatomic,strong) UIImageView *logo;
//
///**加载旋转圆环
// */
//@property(nonatomic,strong) UIImageView *circle;

//提示信息
@property(nonatomic,strong) UILabel *msgLabel;

@end

@implementation SeaNetworkActivityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        view.center = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
        [self addSubview:view];
        self.actView = view;
        
        //        UIImage *image = [UIImage imageNamed:@"loading_logo"];
        //        _logo = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - image.size.width) / 2.0, 0, image.size.width, image.size.height)];
        //        _logo.image = image;
        //        [self addSubview:_logo];
        //
        //        image = [UIImage imageNamed:@"loading_circle"];
        //        _circle = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - image.size.width) / 2.0, 0, image.size.width, image.size.height)];
        //        _circle.image = image;
        //        [self addSubview:_circle];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20.0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:MainFontName size:14.0];
        label.textColor = [UIColor whiteColor];
        label.text = @"加载中...";
        [self addSubview:label];
        self.msgLabel = label;
        
        [self.actView startAnimating];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //    CGFloat topMargin = 10.0;
    CGFloat interval = 10;
    CGSize size = [self.msgLabel.text stringSizeWithFont:self.msgLabel.font contraintWith:_width_];
    
    self.actView.center = CGPointMake(self.width / 2, (self.height - self.actView.height - size.height - interval) / 2 + self.actView.height / 2);
    CGRect frame = self.frame;
    
    //    frame.size.height = size.height + _circle.height + topMargin * 2 + interval;
    //    frame.size.width = MAX(size.width, self.circle.width) + margin * 2;
    //    frame.origin.x = (self.superview.width - frame.size.width) / 2.0;
    //
    //    if([self.superview isKindOfClass:[UIWindow class]])
    //    {
    //        frame.origin.y = (_height_ - frame.size.height) / 2.0;
    //    }
    //    else
    //    {
    //        frame.origin.y = (self.superview.height - frame.size.height) / 2.0;
    //    }
    //
    //    self.frame = frame;
    //
    //    self.circle.left = (self.width - _circle.width) / 2.0;
    //    self.circle.top = topMargin;
    //    self.logo.left = (self.width - _logo.width) / 2.0;
    //    self.logo.top = self.circle.top + (self.circle.height - self.logo.height) / 2.0;
    
    frame = self.msgLabel.frame;
    frame.origin.y = self.actView.bottom + interval;
    frame.origin.x = 0;
    frame.size.width = self.width;
    frame.size.height = size.height;
    self.msgLabel.frame = frame;
}



#pragma mark- property

- (void)setMsg:(NSString *)msg
{
    if([msg isEqualToString:_msgLabel.text])
        return;
    _msgLabel.text = msg;
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if(self.hidden)
    {
        [self stopAnimating];
    }
    else
    {
        [self startAnimating];
    }
}

#pragma mark- animate

- (void)stopAnimating
{
    [self.actView stopAnimating];
    //    [self.circle.layer removeAllAnimations];
}

- (void)startAnimating
{
    //旋转动画
    [self.actView startAnimating];
    //    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //    rotate.removedOnCompletion = FALSE;
    //    rotate.fillMode = kCAFillModeForwards;
    //
    //    [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
    //    rotate.repeatCount = HUGE_VALF;
    //
    //    rotate.duration = 0.25;
    //    rotate.cumulative = TRUE;
    //    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //    [_circle.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

@end
