//
//  SeaTableViewCell.m

//

#import "SeaTableViewCell.h"
#import "SeaBasic.h"

@implementation SeaTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _customSeparatorStyle = SeaTableViewCellStyleNone;
        _separatorInsets = UIEdgeInsetsMake(0, 10.0, 0, 0);
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (_customSeparatorStyle)
    {
        case SeaTableViewCellStyleNone :
            _separator.hidden = YES;
            break;
        case SeaTableViewCellStyleSingleline :
        {
            _separator.hidden = NO;
            _separator.frame = self.separatorFrame;
        }
            break;
    }
}

//分割线位置大小
- (CGRect)separatorFrame
{
    return CGRectMake(_separatorInsets.left, self.contentView.height - _separator.height, self.contentView.width - _separatorInsets.left - _separatorInsets.right, _separator.height);
}


#pragma mark- property setup 

- (void)setCustomSeparatorStyle:(SeaTableViewCellStyle)customSeparatorStyle
{
    if(_customSeparatorStyle == customSeparatorStyle)
        return;
    _customSeparatorStyle = customSeparatorStyle;
    switch (_customSeparatorStyle)
    {
        case SeaTableViewCellStyleSingleline :
        {
            //分割线
            _separator = [[UIView alloc] initWithFrame:self.separatorFrame];
            _separator.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            [self.contentView addSubview:_separator];
        }
            break;
            
        default:
            break;
    }
}

@end
