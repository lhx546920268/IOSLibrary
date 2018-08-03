//
//  SeaDefaultRefreshControl.m
//  IOSLibrary
//
//  Created by luohaixiong on 2018/7/20.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaDefaultRefreshControl.h"
#import "UIView+Utils.h"
#import "SeaBasic.h"
#import "NSString+Utils.h"

@implementation SeaDefaultRefreshControl

- (id)initWithScrollView:(UIScrollView*) scrollView
{
    self = [super initWithScrollView:scrollView];
    if(self){
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indicatorView];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_indicatorView.right, 0, self.width - _indicatorView.right, _indicatorView.height)];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont fontWithName:SeaMainFontName size:13.0f];
        _statusLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _statusLabel.backgroundColor = [UIColor clearColor];
        [_statusLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_statusLabel];
        
        [self updatePosition];
        
        [self setState:SeaDataControlStateNormal];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = (self.criticalPoint - _indicatorView.height) / 2.0;
    
    _indicatorView.top = self.height - _statusLabel.height - margin;
    _statusLabel.top = _indicatorView.top;
}

#pragma mark- super method

- (void)onStateChange:(SeaDataControlState)state
{
    [super onStateChange:state];
    switch (state) {
        case SeaDataControlStatePulling : {
            
            if(!self.animating){
                _statusLabel.text = [self titleForState:state];
                [self updatePosition];
            }
        }
            break;
        case SeaDataControlStateReachCirticalPoint : {
            
            _statusLabel.text = [self titleForState:state];
            [self updatePosition];
        }
            break;
        case SeaDataControlStateNormal : {
            
            if(!self.animating){
                _statusLabel.text = [self titleForState:state];
                [self updatePosition];
            }
        }
            
            break;
        case SeaDataControlStateLoading : {
            
            _statusLabel.text = [self titleForState:state];
            [_indicatorView startAnimating];
            [self updatePosition];
        }
            break;
        case SeaDataControlStateNoData : {
            
        }
            break;
    }
}

- (void)stopLoading
{
    [super stopLoading];
    
    [_indicatorView stopAnimating];
    _statusLabel.text = self.finishText;
    [self updatePosition];
}

///更新位置
- (void)updatePosition
{
    CGFloat width = _indicatorView.isAnimating ? _indicatorView.width : 0;
    CGSize size = [_statusLabel.text sea_stringSizeWithFont:_statusLabel.font contraintWith:self.frame.size.width - width];
    _indicatorView.left = (self.frame.size.width - size.width - width) / 2.0;
    
    CGRect frame = _indicatorView.frame;
    frame.origin.x = _indicatorView.left + width + 3.0;
    frame.size.width = self.frame.size.width - _indicatorView.left - width;
    _statusLabel.frame = frame;
}


@end
