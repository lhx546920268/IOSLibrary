//
//  SeaSeparatorTableViewCell.m

//

#import "SeaSeparatorTableViewCell.h"
#import "SeaBasic.h"

@implementation SeaSeparatorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _customSeparatorStyle = SeaTableViewCellSeparatorStyleSingleline;
        _separatorInsets = UIEdgeInsetsMake(0, 10.0, 0, 0);
        
        //分割线
        _separator = [[UIView alloc] initWithFrame:self.separatorFrame];
        _separator.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        [self.contentView addSubview:_separator];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (_customSeparatorStyle)
    {
        case SeaTableViewCellSeparatorStyleNone :
            _separator.hidden = YES;
            break;
        case SeaTableViewCellSeparatorStyleSingleline :
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

@end
