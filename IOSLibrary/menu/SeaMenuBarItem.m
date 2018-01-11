//
//  SeaMenuBarItem.m

//

#import "SeaMenuBarItem.h"
#import "SeaNumberBadge.h"
#import "SeaBasic.h"
#import "UIButton+Utils.h"
#import "SeaMenuBar.h"
#import "UIView+SeaAutoLayout.h"

@implementation SeaMenuBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        _button.userInteractionEnabled = NO;
        [self.contentView addSubview:_button];
        
        _separator = [UIView new];
        _separator.backgroundColor = SeaSeparatorColor;
        _separator.userInteractionEnabled = NO;
        [self.contentView addSubview:_separator];
        
        _numberBadge = [SeaNumberBadge new];
        _numberBadge.font = [UIFont fontWithName:SeaMainFontName size:10.0];
        _numberBadge.value = @"0";
        [self.contentView addSubview:_numberBadge];
        
        [_button sea_insetsInSuperview:UIEdgeInsetsZero];
        
        [_separator sea_sizeToSelf:CGSizeMake(SeaSeparatorHeight, 15.0)];
        [_separator sea_rightToSuperview];
        [_separator sea_centerInSuperview];
        
        [_numberBadge sea_rightToSuperview];
        [_numberBadge sea_centerYInSuperview];
        [_numberBadge sea_sizeToSelf:CGSizeMake(44.0, 40)];
    }
    return self;
}

- (void)setInfo:(SeaMenuItemInfo *)info
{
    _info = info;
    [_button setTitle:info.title forState:UIControlStateNormal];
    [_button setImage:info.icon forState:UIControlStateNormal];
    [_button setBackgroundImage:info.backgroundImage forState:UIControlStateNormal];
    
    [_button sea_setImagePosition:info.iconPosition margin:info.iconPadding];
    
    _numberBadge.value = _info.badgeNumber;
}

- (void)setTick:(BOOL)item_selected
{
    _tick = item_selected;
    _button.selected = _tick;
    _button.tintColor = [_button titleColorForState:_tick ? UIControlStateSelected : UIControlStateNormal];
}

@end
