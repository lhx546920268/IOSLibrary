//
//  SeaDefaultLoadMoreControl.m
//  IOSLibrary
//
//  Created by luohaixiong on 2018/7/20.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaDefaultLoadMoreControl.h"
#import "NSString+Utils.h"
#import "UIView+Utils.h"
#import "SeaBasic.h"

@implementation SeaDefaultLoadMoreControl

- (id)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super initWithScrollView:scrollView];
    if(self){
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indicatorView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _textLabel.font = [UIFont fontWithName:SeaMainFontName size:14.0];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
        _showIndicatorView = YES;
        
        [self setState:SeaDataControlStateNoData];
    }
    
    return self;
}

- (void)setIsHorizontal:(BOOL)isHorizontal
{
    [super setIsHorizontal:isHorizontal];
    _textLabel.numberOfLines = self.isHorizontal ? 0 : 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if(self.isHorizontal){
        CGFloat contentWidth = (_indicatorView.isAnimating ? (_indicatorView.width + + 3.0) : 0) + _textLabel.width;
        _indicatorView.left = (self.criticalPoint - contentWidth) / 2;
        _textLabel.left = (_indicatorView.isAnimating ? _indicatorView.right + 3.0 : _indicatorView.left);
    }else{
        _indicatorView.top = (self.criticalPoint - _indicatorView.height) / 2;
        _textLabel.top = (self.criticalPoint - _textLabel.height) / 2;
    }
}


#pragma mark super method

- (void)onStateChange:(SeaDataControlState)state
{
    [super onStateChange:state];
    switch (state){
        case SeaDataControlStateNormal : {
            _textLabel.text = [self titleForState:state];
            [_indicatorView stopAnimating];
            [self updatePosition];
        }
            break;
        case SeaDataControlStatePulling : {
            _textLabel.text = [self titleForState:state];
            [_indicatorView stopAnimating];
            [self updatePosition];
        }
            break;
        case SeaDataControlStateNoData :
        {
            [_indicatorView stopAnimating];
            _textLabel.text = [self titleForState:state];
            _textLabel.hidden = !self.shouldStayWhileNoData;
            [self updatePosition];
        }
            break;
        case SeaDataControlStateLoading : {
            _textLabel.text = [self titleForState:state];
            if(_showIndicatorView){
                [_indicatorView startAnimating];
            }
            [self updatePosition];
        }
            break;
        case SeaDataControlStateReachCirticalPoint : {
            _textLabel.text = [self titleForState:state];
            [self updatePosition];
        }
            break;
        default:
            break;
    }
}

///更新位置
- (void)updatePosition
{
    if(self.isHorizontal){
        CGFloat height = _indicatorView.height;
        CGSize size = [_textLabel.text sea_stringSizeWithFont:_textLabel.font contraintWith:18];
        size.width += 1.0;
        size.height += 1.0;
        _indicatorView.top = (self.height - height) / 2.0;
        
        CGRect frame = _textLabel.frame;
        frame.origin.y = (self.height - size.height) / 2.0;
        frame.size.width = size.width;
        frame.size.height = size.height;
        _textLabel.frame = frame;
    }else{
        CGFloat width = _indicatorView.isAnimating ? _indicatorView.width : 0;
        CGSize size = [_textLabel.text sea_stringSizeWithFont:_textLabel.font contraintWith:self.width - width];
        size.width += 1.0;
        size.height += 1.0;
        _indicatorView.left = (self.width - size.width - width) / 2.0;
        
        CGRect frame = _textLabel.frame;
        frame.origin.x = _indicatorView.left + width + 3.0;
        frame.size.width = self.width - _indicatorView.left - width;
        _textLabel.frame = frame;
    }
}
@end
