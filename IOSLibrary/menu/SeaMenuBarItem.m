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
        _button.titleLabel.numberOfLines = 0;
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
        
        [_separator sea_sizeToSelf:CGSizeMake(SeaSeparatorWidth, 15.0)];
        [_separator sea_rightToSuperview];
        [_separator sea_centerYInSuperview];
        
        [_numberBadge sea_rightToSuperview];
        [_numberBadge sea_topToSuperview:5];
    }
    return self;
}

- (void)setInfo:(SeaMenuItemInfo *)info
{
    _info = info;
    [_button setTitle:info.title forState:UIControlStateNormal];
    [_button setImage:info.icon forState:UIControlStateNormal];
    [_button setImage:info.selectedIcon forState:UIControlStateSelected];
    [_button setBackgroundImage:info.backgroundImage forState:UIControlStateNormal];
    
    [_button sea_setImagePosition:info.iconPosition margin:info.iconPadding];
    
    UIEdgeInsets insets = _button.titleEdgeInsets;
    insets.left += _info.titleInsets.left;
    insets.right += _info.titleInsets.right;
    insets.bottom += _info.titleInsets.bottom;
    insets.top += _info.titleInsets.top;
    _button.titleEdgeInsets = insets;
    
    _numberBadge.value = _info.badgeNumber;
    self.customView = _info.customView;
}

- (void)setTick:(BOOL)item_selected
{
    _tick = item_selected;
    _button.selected = _tick;
    _button.tintColor = [_button titleColorForState:_tick ? UIControlStateSelected : UIControlStateNormal];
}

- (void)setCustomView:(UIView *)customView
{
    if(_customView != customView){
        [_customView removeFromSuperview];
        _customView = customView;
        if(_customView){
            [self.contentView addSubview:_customView];
        }
    }
}

@end
