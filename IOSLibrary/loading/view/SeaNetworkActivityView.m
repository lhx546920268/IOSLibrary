//
//  SeaNetworkActivityView.m

//

#import "SeaNetworkActivityView.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaBasic.h"

@interface SeaNetworkActivityView ()

//是否已延迟显示
@property(nonatomic,assign) BOOL delaying;

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
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}

///初始化
- (void)initialization
{
    if(!_translucentView){
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
        [_activityIndicatorView sea_rightToItem:_activityIndicatorView.superview margin:10 relation:NSLayoutRelationGreaterThanOrEqual];
        
        [_textLabel sea_leftToItem:_textLabel.superview margin:10.0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_textLabel sea_rightToItem:_textLabel.superview margin:10.0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_textLabel sea_centerXInSuperview];
        [_textLabel sea_topToItemBottom:_activityIndicatorView margin:10.0];
        [_textLabel sea_bottomToSuperview:10.0];
    }
}

- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayShow) object:nil];
}

///延迟显示
- (void)delayShow
{
    self.delaying = NO;
    [self initialization];
    _translucentView.hidden = NO;
    [self startAnimating];
}

#pragma mark- property

- (void)setMsg:(NSString *)msg
{
    if(_msg != msg){
        _msg = [msg copy];
        if(_textLabel){
            _textLabel.text = msg;
        }
    }
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    [self updateStatus];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [self updateStatus];
}

///更新菊花状态
- (void)updateStatus
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayShow) object:nil];
    if(self.window && !self.hidden){
        if(self.delaying){
            return;
        }
        if(self.delay > 0){
            self.delaying = YES;
            _translucentView.hidden = YES;
            [self performSelector:@selector(delayShow) withObject:nil afterDelay:self.delay];
        }else{
            [self delayShow];
        }
    }else{
        [self stopAnimating];
    }
}

#pragma mark- animate

- (void)stopAnimating
{
    _animating = YES;
    [self.activityIndicatorView stopAnimating];
}

- (void)startAnimating
{
    _animating = NO;
    [self.activityIndicatorView startAnimating];
}


@end
