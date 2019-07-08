//
//  SeaPhotosListCell.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/2.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosListCell.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaBasic.h"

@implementation SeaPhotosListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _thumbnailImageView = [UIImageView new];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailImageView.clipsToBounds = YES;
        [self.contentView addSubview:_thumbnailImageView];
        
        [_thumbnailImageView sea_leftToSuperview:15];
        [_thumbnailImageView sea_topToSuperview:10];
        [_thumbnailImageView sea_bottomToSuperview:10];
        [_thumbnailImageView sea_aspectRatio:1.0];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel sea_leftToItemRight:_thumbnailImageView margin:15];
        [_titleLabel sea_centerYInSuperview];
        
        _countLabel = [UILabel new];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.textColor = UIColor.darkGrayColor;
        [_countLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh - 1 forAxis:UILayoutConstraintAxisHorizontal];
        [_countLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1 forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_countLabel];
        
        [_countLabel sea_leftToItemRight:_titleLabel margin:5];
        [_countLabel sea_centerYInSuperview];
        [_countLabel sea_rightToSuperview:15];
        
        UIView *divider = [UIView new];
        divider.backgroundColor = SeaSeparatorColor;
        [self.contentView addSubview:divider];
        
        [divider sea_rightToSuperview];
        [divider sea_leftToItem:_titleLabel];
        [divider sea_bottomToSuperview];
        [divider sea_heightToSelf:SeaSeparatorWidth];
    }
    return self;
}

@end
