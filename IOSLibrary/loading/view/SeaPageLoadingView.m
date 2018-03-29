//
//  SeaPageLoadingView.m

//
//

#import "SeaPageLoadingView.h"
#import "SeaBasic.h"
#import "UIView+SeaAutoLayout.h"

@interface SeaPageLoadingView ()

//内容视图
@property(nonatomic,strong) UIView *contentView;

@end

@implementation SeaPageLoadingView

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
    self.backgroundColor = SeaGrayBackgroundColor;
    
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_contentView addSubview:_activityIndicatorView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.text = @"正在载入...";
    _textLabel.textColor = [UIColor grayColor];
    _textLabel.font = [UIFont fontWithName:SeaMainFontName size:14.0];
    _textLabel.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_textLabel];
    
    [_contentView sea_centerInSuperview];
    
    [_activityIndicatorView sea_centerYInSuperview];
    [_activityIndicatorView sea_leftToSuperview:10.0];

    [_activityIndicatorView sea_topToItem:_activityIndicatorView.superview margin:10 relation:NSLayoutRelationGreaterThanOrEqual];
    [_activityIndicatorView sea_bottomToItem:_activityIndicatorView.superview margin:10 relation:NSLayoutRelationGreaterThanOrEqual];
    
    [_textLabel sea_topToItem:_textLabel.superview margin:10.0 relation:NSLayoutRelationGreaterThanOrEqual];
    [_textLabel sea_bottomToSuperview:10.0];
    [_textLabel sea_leftToItemRight:_activityIndicatorView margin:5.0];
    [_textLabel sea_rightToSuperview:10.0];
    
    [_activityIndicatorView startAnimating];
}

#pragma mark- property

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if(!hidden){
        [self.activityIndicatorView startAnimating];
    }else{
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)setTitle:(NSString *)title
{
    _textLabel.text = title;
}

@end
