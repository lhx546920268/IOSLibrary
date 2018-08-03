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
        
        _showIndicatorView = NO;
        [self setState:SeaDataControlStateNoData];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _indicatorView.top = (self.criticalPoint - _indicatorView.height) / 2;
    _textLabel.top = (self.criticalPoint - _textLabel.height) / 2;
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
    CGFloat width = _indicatorView.isAnimating ? _indicatorView.width : 0;
    CGSize size = [_textLabel.text sea_stringSizeWithFont:_textLabel.font contraintWith:self.width - width];
    _indicatorView.left = (self.width - size.width - width) / 2.0;
    
    CGRect frame = _indicatorView.frame;
    frame.origin.x = _indicatorView.left + width + 3.0;
    frame.size.width = self.width - _indicatorView.left - width;
    _textLabel.frame = frame;
}
@end
