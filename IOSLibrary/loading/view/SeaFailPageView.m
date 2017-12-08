//
//  SeaFailPageView.m

//

#import "SeaFailPageView.h"
#import "SeaBasic.h"
#import "UIView+SeaAutoLayout.h"

@interface SeaFailPageView ()

//内容视图
@property(nonatomic,strong) UIView *contentView;

@end

@implementation SeaFailPageView

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
    self.backgroundColor = SeaViewControllerBackgroundColor;
    
    
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    
    _imageView = [[UIImageView alloc] init];
    [_contentView addSubview:_imageView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.font = [UIFont fontWithName:SeaMainFontName size:15.0];
    _textLabel.textColor = [UIColor grayColor];
    _textLabel.text = @"加载失败\n轻触屏幕重新加载";
    _textLabel.numberOfLines = 0;
    [_contentView addSubview:_textLabel];
    
    [_contentView sea_leftToSuperview:10.0];
    [_contentView sea_rightToSuperview:10.0];
    [_contentView sea_centerXInSuperview];
    
    [_imageView sea_centerXInSuperview];
    [_imageView sea_topToSuperview:10.0];
    [_imageView sea_leftToView:_imageView.superview margin:10 relation:NSLayoutRelationGreaterThanOrEqual];
    [_imageView sea_rightToViewLeft:_imageView.superview margin:10 relation:NSLayoutRelationGreaterThanOrEqual];
    
    [_textLabel sea_leftToView:_textLabel.superview margin:10.0 relation:NSLayoutRelationGreaterThanOrEqual];
    [_textLabel sea_rightToSuperview:10.0];
    [_textLabel sea_topToViewBottom:_imageView margin:10.0];
    [_textLabel sea_bottomToSuperview:10.0];
}

@end
