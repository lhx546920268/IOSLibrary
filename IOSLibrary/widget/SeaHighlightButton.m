//
//  SeaHighlightButton.m

//

#import "SeaHighlightButton.h"
#import "SeaBasic.h"

@implementation SeaHighlightButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.normalColor = [UIColor blackColor];
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont fontWithName:SeaMainFontName size:15.0];
        _titleLabel.textColor = self.normalColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)dealloc
{
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _titleLabel.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected
{
    if(_selected != selected)
    {
        _selected = selected;
        if(_selected)
        {
            self.layer.borderWidth = SeaSeparatorWidth;
            self.layer.borderColor = self.selectedColor.CGColor;
            _titleLabel.textColor = self.selectedColor;
        }
        else
        {
            self.layer.borderWidth = 0;
            self.layer.borderColor = [UIColor clearColor].CGColor;
            _titleLabel.textColor = self.normalColor;
        }
    }
}

@end
