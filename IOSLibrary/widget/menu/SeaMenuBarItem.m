//
//  SeaMenuBarItem.m

//

#import "SeaMenuBarItem.h"
#import "SeaNumberBadge.h"
#import "SeaBasic.h"

@implementation SeaMenuBarItem

/**构造方法
 *@param frame 位置大小
 *@return 已初始化的 SeaMenuBarItem
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = self.bounds;
        _button.titleLabel.numberOfLines = 0;
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        _button.userInteractionEnabled = NO;
        [self.contentView addSubview:_button];
        
        CGFloat height = 15.0;
        _separator = [[UIView alloc] initWithFrame:CGRectMake(_button.right - SeaSeparatorHeight, (self.height - height) / 2.0, SeaSeparatorHeight, height)];
        _separator.backgroundColor = [UIColor clearColor];
        _separator.backgroundColor = SeaSeparatorColor;
        [self.contentView addSubview:_separator];
        
        CGFloat width = 44.0;
        height = 40.0;
        _numberBadge = [[SeaNumberBadge alloc] initWithFrame:CGRectMake(self.contentView.width - width + 12.0, - 12.0, width, height)];
        _numberBadge.font = [UIFont fontWithName:SeaMainFontName size:10.0];
        _numberBadge.value = @"0";
        [self.contentView addSubview:_numberBadge];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _button.frame = self.contentView.bounds;
    _numberBadge.left = self.contentView.width - _numberBadge.width;
    _separator.left = self.contentView.width - _separator.width;
}

- (void)setInfo:(SeaMenuItemInfo *)info
{
    _info = info;
    [_button setTitle:info.title forState:UIControlStateNormal];
    [_button setImage:info.icon forState:UIControlStateNormal];
    [_button setBackgroundImage:info.backgroundImage forState:UIControlStateNormal];
    
    if(info.icon != nil && info.title != nil && _info.iconPosition == SeaMenuItemIconPositionRight)
    {
        [_button setButtonIconToRightWithInterval:5.0];
    }
    else
    {
        _button.titleEdgeInsets = UIEdgeInsetsZero;
        _button.imageEdgeInsets = UIEdgeInsetsZero;
    }
    
    _numberBadge.value = _info.badgeNumber;
}

- (void)setItem_selected:(BOOL)item_selected
{
    _item_selected = item_selected;
    _button.selected = _item_selected;
    _button.tintColor = [_button titleColorForState:_item_selected ? UIControlStateSelected : UIControlStateNormal];
}

@end
