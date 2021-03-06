//
//  SeaEmptyView.m
//  IOSLibrary
//
//  Created by 罗海雄 on 16/7/14.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import "SeaEmptyView.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaBasic.h"

@interface SeaEmptyView ()

///内容
@property(nonatomic,readonly) UIView *contentView;

@end

@implementation SeaEmptyView

@synthesize textLabel = _textLabel;
@synthesize iconImageView = _iconImageView;
@synthesize contentView = _contentView;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initlization];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initlization];
    }

    return self;
}

///初始化默认数据
- (void)initlization
{
    
}

- (UIView*)contentView
{
    if(!_contentView){
        self.clipsToBounds = YES;
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_contentView];
        
        [_contentView sea_leftToSuperview:10];
        [_contentView sea_rightToSuperview:10];
        [_contentView sea_centerYInSuperview];
    }
    return _contentView;
}

- (UILabel*)textLabel
{
    if(!_textLabel){
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor grayColor];
        _textLabel.font = [UIFont fontWithName:SeaMainFontName size:17.0];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        [self.contentView addSubview:_textLabel];

        if(_iconImageView){
            
            [self.contentView removeConstraint:_iconImageView.sea_bottomLayoutConstraint];
            [_textLabel sea_topToItemBottom:_iconImageView margin:10];
        }else{
            
            [_textLabel sea_topToSuperview];
        }
        [_textLabel sea_bottomToSuperview];
        [_textLabel sea_leftToSuperview];
        [_textLabel sea_rightToSuperview];
    }

    return _textLabel;
}

- (UIImageView*)iconImageView
{
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImageView];

        [_iconImageView sea_leftToItem:_iconImageView.superview margin:0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_iconImageView sea_rightToItem:_iconImageView.superview margin:0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_iconImageView sea_centerXInSuperview];
        [_iconImageView sea_topToSuperview];

        if(_textLabel){
            [self.contentView removeConstraint:_textLabel.sea_topLayoutConstraint];
            [_textLabel sea_topToItemBottom:_iconImageView margin:10];
        }else{
            [_iconImageView sea_bottomToSuperview];
        }
    }

    return _iconImageView;
}

- (void)setCustomView:(UIView *)customView
{
    if(_customView != customView){
        [_customView removeFromSuperview];
        _customView = customView;

        if(_customView){
            [_contentView removeFromSuperview];
            [self addSubview:_customView];
            [_customView sea_insetsInSuperview:UIEdgeInsetsZero];
        }
    }
}

@end

