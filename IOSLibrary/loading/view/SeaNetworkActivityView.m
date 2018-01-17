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

//黑色半透明背景视图
@property(nonatomic,strong) UIView *translucentView;

@end

@implementation SeaNetworkActivityView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
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
    _translucentView = [[UIView alloc] init];
    _translucentView.layer.cornerRadius = 8.0;
    _translucentView.layer.masksToBounds = YES;
    _translucentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_translucentView];
    
    _contentView = [[UIView alloc] init];
    [_translucentView addSubview:_contentView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_activityIndicatorView startAnimating];
    [_contentView addSubview:_activityIndicatorView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.font = [UIFont fontWithName:SeaMainFontName size:14.0];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.text = @"加载中...";
    [_contentView addSubview:_textLabel];
    
    [_translucentView sea_widthToSelf:120.0];
    [_translucentView sea_heightToSelf:120.0];
    [_translucentView sea_centerInSuperview];
    
    [_contentView sea_leftToSuperview:10.0];
    [_contentView sea_rightToSuperview:10.0];
    [_contentView sea_centerYInSuperview];

    [_activityIndicatorView sea_centerXInSuperview];
    [_activityIndicatorView sea_topToSuperview:10.0];
    [_activityIndicatorView sea_leftToItem:_activityIndicatorView.superview margin:10 relation:NSLayoutRelationGreaterThanOrEqual];
    [_activityIndicatorView sea_rightToItemLeft:_activityIndicatorView.superview margin:10 relation:NSLayoutRelationGreaterThanOrEqual];
    
    [_textLabel sea_leftToItem:_textLabel.superview margin:10.0 relation:NSLayoutRelationGreaterThanOrEqual];
    [_textLabel sea_rightToItem:_textLabel.superview margin:10.0 relation:NSLayoutRelationGreaterThanOrEqual];
    [_textLabel sea_centerXInSuperview];
    [_textLabel sea_topToItemBottom:_activityIndicatorView margin:10.0];
    [_textLabel sea_bottomToSuperview:10.0];
}



#pragma mark- property

- (void)setMsg:(NSString *)msg
{
    _textLabel.text = msg;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if(self.hidden){
        [self stopAnimating];
    }else{
        [self startAnimating];
    }
}

#pragma mark- animate

- (void)stopAnimating
{
    [self.activityIndicatorView stopAnimating];
}

- (void)startAnimating
{
    [self.activityIndicatorView startAnimating];
}

@end
