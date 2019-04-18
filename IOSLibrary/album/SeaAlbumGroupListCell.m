//
//  SeaAlbumGroupListCell.m
//  WuMei
//
//  Created by 罗海雄 on 15/8/7.
//  Copyright (c) 2015年 luohaixiong. All rights reserved.
//

#import "SeaAlbumGroupListCell.h"
#import "UIView+Utils.h"
#import "UIColor+Utils.h"
#import "SeaBasic.h"

@implementation SeaAlbumGroupListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SeaAlbumGroupListCellMargin, SeaAlbumGroupListCellMargin, SeaAlbumGroupListCellImageSize, SeaAlbumGroupListCellImageSize)];
        [self.contentView addSubview:_iconImageView];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + SeaAlbumGroupListCellMargin, _iconImageView.top, UIScreen.screenWidth - SeaAlbumGroupListCellMargin * 3 - SeaAlbumGroupListCellImageSize, SeaAlbumGroupListCellImageSize)];
        _nameLabel.textColor = [UIColor sea_colorWithRed:153 green:153 blue:153 alpha:1.0];
        _nameLabel.font = [UIFont fontWithName:SeaMainFontName size:15.0];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

@end
