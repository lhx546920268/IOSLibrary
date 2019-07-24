//
//  SeaPhotosPreviewHeader.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/22.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosPreviewHeader.h"
#import "SeaPhotosCheckBox.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaBasic.h"

@implementation SeaPhotosPreviewHeader

@synthesize titleLabel = _titleLabel;

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat statusHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        _backButton.tintColor = UIColor.whiteColor;
        _backButton.contentEdgeInsets = UIEdgeInsetsMake(0, SeaNavigationBarMargin, 0, SeaNavigationBarMargin);
        [self addSubview:_backButton];
        
        [_backButton sea_leftToSuperview];
        [_backButton sea_topToSuperview:statusHeight];
        [_backButton sea_bottomToSuperview];
        
        _checkBox = [SeaPhotosCheckBox new];
        _checkBox.contentInsets = UIEdgeInsetsMake(12, SeaNavigationBarMargin, 12, SeaNavigationBarMargin);
        [self addSubview:_checkBox];
        
        [_checkBox sea_rightToSuperview];
        [_checkBox sea_topToSuperview:statusHeight];
        [_checkBox sea_bottomToSuperview];
    }
    
    return self;
}

- (UILabel*)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        [_titleLabel sea_centerInSuperview];
    }
    
    return _titleLabel;
}

@end
