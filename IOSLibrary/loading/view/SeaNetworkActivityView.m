//
//  SeaNetworkActivityView.m

//

#import "SeaNetworkActivityView.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaBasic.h"

@interface SeaNetworkActivityView ()

//加载指示器
@property(nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

//提示信息
@property(nonatomic,strong) UILabel *textLabel;

//内容视图
@property(nonatomic,strong) UIView *contentView;

@end

@implementation SeaNetworkActivityView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 120, 120)];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
    }
    return self;
}

///初始化
- (void)initialization
{
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_contentView addSubview:_activityIndicatorView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.font = [UIFont fontWithName:SeaMainFontName size:14.0];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.text = @"加载中...";
    [_contentView addSubview:_textLabel];
    
    [_contentView sea_leftToSuperview:10.0];
    [_contentView sea_rightToSuperview:10.0];
    [_contentView sea_centerXInSuperview];

    [_activityIndicatorView sea_centerXInSuperview];
    [_activityIndicatorView sea_topToSuperview:10.0];
    [_activityIndicatorView sea_leftToView:_activityIndicatorView.superview margin:10 relation:NSLayoutRelationGreaterThanOrEqual];
    [_activityIndicatorView sea_rightToViewLeft:_activityIndicatorView.superview margin:10 relation:NSLayoutRelationGreaterThanOrEqual];
    
    [_textLabel sea_leftToView:_textLabel.superview margin:10.0 relation:NSLayoutRelationGreaterThanOrEqual];
    [_textLabel sea_rightToSuperview:10.0];
    [_textLabel sea_topToViewBottom:_activityIndicatorView margin:10.0];
    [_textLabel sea_bottomToSuperview:10.0];
}



#pragma mark- property

- (void)setMsg:(NSString *)msg
{
    if([msg isEqualToString:_msgLabel.text])
        return;
    _msgLabel.text = msg;
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
}

- (void)startAnimating
{
    [self.actView startAnimating];
}

@end
