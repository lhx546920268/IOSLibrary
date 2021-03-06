//
//  SeaAlbumAssetsCell.m

//

#import "SeaAlbumAssetsCell.h"
#import "SeaCheckBox.h"
#import "UIView+SeaAutoLayout.h"

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
        
        _checkBox = [[SeaCheckBox alloc] init];
        _checkBox.selected = YES;
        _checkBox.userInteractionEnabled = NO;
        [self addSubview:_checkBox];
        
        [_checkBox sea_sizeToSelf:CGSizeMake(size, size)];
        [_checkBox sea_rightToSuperview:margin];
        [_checkBox sea_topToSuperview:margin];
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
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        
        _overlay = [[SeaAlbumAssetsOverlay alloc] init];
        _overlay.hidden = YES;
        [self.contentView addSubview:_overlay];
        
        [_imageView sea_insetsInSuperview:UIEdgeInsetsZero];
        [_overlay sea_insetsInSuperview:UIEdgeInsetsZero];
    }
    return self;
}

- (void)setTick:(BOOL)tick
{
    if(_tick != tick){
        _tick = tick;
        _overlay.hidden = !_tick;
        [_overlay.checkBox setSelected:_tick];
    }
}


@end


