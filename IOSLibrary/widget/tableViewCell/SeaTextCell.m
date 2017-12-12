//
//  SeaTextCell.m

//

#import "SeaTextCell.h"
#import "SeaBasic.h"

@implementation SeaTextCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *font = _SeaTextCellFont_;
        self.contentHeight = font.lineHeight;
        
        //内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_SeaTextCellMargin_, _SeaTextCellMargin_, SeaScreenWidth - _SeaTextCellMargin_ * 2 , font.lineHeight)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = font;
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentLabel.height = _contentHeight;
}

- (void)dealloc
{
   
}

@end
