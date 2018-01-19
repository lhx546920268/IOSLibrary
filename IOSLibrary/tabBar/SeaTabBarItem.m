//
//  SeaTabBarItem.m

//

#import "SeaTabBarItem.h"
#import "SeaNumberBadge.h"
#import "SeaBasic.h"
#import "UIView+Utils.h"
#import "UIView+SeaAutoLayout.h"

@interface SeaTabBarItem ()

@end

@implementation SeaTabBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.clipsToBounds = YES;
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
    }
    return self;
}

#pragma mark- property

- (void)setBadgeValue:(NSString *)badgeValue
{
    if(_badgeValue != badgeValue){
        _badgeValue = badgeValue;
        
        if(!self.badge){
 
            SeaNumberBadge *badge = [SeaNumberBadge new];
            [self addSubview:badge];
            self.badge = badge;
            [badge sea_leftToItemCenterX:_imageView];
            [badge sea_topToItemCenterY:_imageView];
        }
        
        if([_badgeValue isEqualToString:@""]){
            self.badge.point = YES;
        }else{
            self.badge.point = NO;
            self.badge.value = _badgeValue;
        }
    }
}

@end
