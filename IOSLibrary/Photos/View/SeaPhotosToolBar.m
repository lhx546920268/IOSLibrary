//
//  SeaPhotosToolBar.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/11.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosToolBar.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaBasic.h"

@implementation SeaPhotosToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColor.whiteColor;
        
        UIView *divider = [UIView new];
        divider.backgroundColor = SeaSeparatorColor;
        [self addSubview:divider];
        
        [divider sea_leftToSuperview];
        [divider sea_rightToSuperview];
        [divider sea_topToSuperview];
        [divider sea_heightToSelf:SeaSeparatorWidth];
        
        _previewButton = [UIButton new];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        _previewButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _previewButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        _previewButton.enabled = NO;
        [_previewButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_previewButton setTitleColor:UIColor.grayColor forState:UIControlStateDisabled];
        [_previewButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateHighlighted];
        [self addSubview:_previewButton];
        
        [_previewButton sea_leftToSuperview];
        [_previewButton sea_topToSuperview];
        [_previewButton sea_bottomToSuperview];
        
        _useButton = [UIButton new];
        [_useButton setTitle:@"使用" forState:UIControlStateNormal];
        _useButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _useButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        _useButton.enabled = NO;
        [_useButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_useButton setTitleColor:UIColor.grayColor forState:UIControlStateDisabled];
        [_useButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateHighlighted];
        [self addSubview:_useButton];
        
        [_useButton sea_rightToSuperview];
        [_useButton sea_topToSuperview];
        [_useButton sea_bottomToSuperview];
        
        _countLabel = [UILabel new];
        _countLabel.text = @"已选0张图片";
        _countLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_countLabel];
        
        [_countLabel sea_centerInSuperview];
    }
    return self;
}

- (void)setCount:(int)count
{
    if(_count != count){
        _count = count;
        _countLabel.text = [NSString stringWithFormat:@"已选%d张图片", _count];
        self.previewButton.enabled = _count > 0;
        self.useButton.enabled = _count > 0;
    }
}

@end
