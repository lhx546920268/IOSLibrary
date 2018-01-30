//
//  SeaTabBarItem.m

//

#import "SeaTabBarItem.h"
#import "SeaNumberBadge.h"
#import "SeaBasic.h"
#import "UIView+Utils.h"
#import "UIView+SeaAutoLayout.h"

@interface SeaTabBarItem ()

@property(nonatomic, strong) UIView *contentView;

@end

@implementation SeaTabBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.clipsToBounds = NO;
        UIView *contentView = [UIView new];
        contentView.userInteractionEnabled = NO;
        [self addSubview:contentView];
        
        _imageView = [UIImageView new];
        [contentView addSubview:_imageView];
        
        _textLabel = [UILabel new];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        [contentView addSubview:_textLabel];
        
        [contentView sea_bottomToSuperview:1];
        [contentView sea_leftToSuperview];
        [contentView sea_rightToSuperview];
        
        
        [_imageView sea_centerXInSuperview];
        [_imageView sea_topToSuperview];
        
        [_textLabel sea_topToItemBottom:_imageView margin:2];
        [_textLabel sea_bottomToSuperview];
        [_textLabel sea_centerXInSuperview];
        
        self.contentView = contentView;
    }
    return self;
}

#pragma mark- property

- (void)setBadgeValue:(NSString *)badgeValue
{
    if(_badgeValue != badgeValue){
        _badgeValue = badgeValue;
        
        if(!_badge){
 
            _badge = [SeaNumberBadge new];
            _badge.font = [UIFont fontWithName:SeaMainNumberFontName size:13];
            [self addSubview:_badge];
            _badge.sea_alb.centerXToRight(_imageView).margin(0).build();
            [_badge sea_topToSuperview:5];
        }
        
        if([_badgeValue isEqualToString:@""]){
            _badge.point = YES;
        }else{
            _badge.point = NO;
            _badge.value = _badgeValue;
        }
    }
}

@end
