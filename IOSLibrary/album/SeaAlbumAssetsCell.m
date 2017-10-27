//
//  SeaAlbumAssetsCell.m

//

#import "SeaAlbumAssetsCell.h"
#import "SeaCheckBox.h"

@implementation SeaAlbumAssetsOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = NO;
        CGFloat size = 30.0;
        CGFloat margin = 5.0;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        _checkBox = [[SeaCheckBox alloc] initWithFrame:CGRectMake(frame.size.width - size - margin, frame.size.height - size - margin, size, size)];
        _checkBox.selected = YES;
        _checkBox.userInteractionEnabled = NO;
        [self addSubview:_checkBox];
    }
    
    return self;
}


@end


@implementation SeaAlbumAssetsThumbnail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
        
        _overlay = [[SeaAlbumAssetsOverlay alloc] initWithFrame:self.bounds];
        _overlay.hidden = YES;
        [self.contentView addSubview:_overlay];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL) animated
{
    [super setSelected:selected];
    _overlay.hidden = !self.selected;
    if(selected)
    {
        [_overlay.checkBox setSelected:selected];
    }
}

@end


