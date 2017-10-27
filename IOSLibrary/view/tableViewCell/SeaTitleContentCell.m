//
//  SeaTitleContentCell.m

//

#import "SeaTitleContentCell.h"
#import "SeaBasic.h"

@implementation SeaTitleContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *font = _SeaTitleContentCellFont_;
        CGFloat y = (_SeaTitleContentCellHeight_ - font.lineHeight) / 2.0;
        
        self.titleWidth = _SeaTitleContentCellTitleWidth_;
        self.contentHeight = font.lineHeight;
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_SeaTitleContentCellMargin_, y, _SeaTitleContentCellTitleWidth_, font.lineHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = font;
        [self.contentView addSubview:_titleLabel];
        
        //内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + _SeaTitleContentCellControlInterval_, y, _width_ - _SeaTitleContentCellMargin_ * 2 - _SeaTitleContentCellArrowWidth_ - _SeaTitleContentCellControlInterval_ * 2 - _SeaTitleContentCellTitleWidth_, font.lineHeight)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = font;
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        //箭头
        UIImage *image = [UIImage imageNamed:@"arrow_gray"];
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_width_ - _SeaTitleContentCellMargin_ - _SeaTitleContentCellArrowWidth_, 0, _SeaTitleContentCellArrowWidth_, image.size.height)];
        _arrowImageView.contentMode = UIViewContentModeCenter;
        _arrowImageView.image = image;
        [self.contentView addSubview:_arrowImageView];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.width = _titleWidth;
    
    CGRect frame = _contentLabel.frame;
    frame.origin.x = _titleLabel.right + _SeaTitleContentCellControlInterval_;
    
    CGFloat width = _width_ - _SeaTitleContentCellMargin_ * 2 - _SeaTitleContentCellArrowWidth_ - _SeaTitleContentCellControlInterval_ * 2 - _titleWidth;
    
    //箭头隐藏
    if(_arrowImageView.hidden)
    {
        width += _SeaTitleContentCellControlInterval_ + _SeaTitleContentCellArrowWidth_;
    }
    else
    {
        _arrowImageView.top = (self.contentView.height - _arrowImageView.height) / 2.0;
    }
    
    frame.size.width = width;
    frame.size.height = _contentHeight;
    _contentLabel.frame = frame;
}

- (void)dealloc
{
    
}

@end
