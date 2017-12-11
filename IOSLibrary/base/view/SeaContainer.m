//
//  SeaContainer.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/7.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaContainer.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaBasic.h"

@implementation SeaContainer

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialization];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialization];
    }
    return self;
}

///初始化
- (void)initialization
{
    
}

#pragma mark- topView

- (void)setTopView:(UIView *)topView
{
    [self setTopView:topView height:SeaWrapContent];
}

/**
 设置顶部视图
 
 @param topView 顶部视图
 @param height 视图高度，SeaWrapContent 为自适应
 */
- (void)setTopView:(UIView *)topView height:(CGFloat) height
{
    if(_topView != topView){
        
        if(_topView){
            [_topView removeFromSuperview];
        }
        
        _topView = topView;
        if(_topView){
            if(_topView.superview != self){
                [_topView removeFromSuperview];
                [self addSubview:_topView];
            }
            
            [_topView sea_topToSuperview];
            [_topView sea_leftToSuperview];
            [_topView sea_rightToSuperview];
            
            if(height != SeaWrapContent){
                [_topView sea_heightToSelf:height];
            }
            
            if(self.contentView){
                self.contentView.sea_topLayoutConstraint.priority = UILayoutPriorityDefaultLow;
                [self.contentView sea_topToItemBottom:_topView].priority = UILayoutPriorityDefaultHigh;
            }
        }
    }
}

#pragma mark- contentView

- (void)setContentView:(UIView *)contentView
{
    [self setContentView:contentView height:SeaWrapContent];
}

/**
 设置内容视图

 @param contentView 内容视图
 @param height 视图高度
 */
- (void)setContentView:(UIView *)contentView height:(CGFloat) height
{
    if(_contentView != contentView){
        if(_contentView){
            [_contentView removeFromSuperview];
        }
        
        _contentView = contentView;
        if(_contentView){
            if(_contentView.superview != self){
                [_contentView removeFromSuperview];
                [self addSubview:_contentView];
            }
            
            [_contentView sea_leftToSuperview];
            [_contentView sea_rightToSuperview];
            [_contentView sea_topToSuperview].priority = UILayoutPriorityDefaultLow;
            [_contentView sea_bottomToSuperview].priority = UILayoutPriorityDefaultLow;
            
            if(_topView){
                [_contentView sea_topToItemBottom:_topView].priority = UILayoutPriorityDefaultHigh;
            }
            
            if(_bottomView){
                [_contentView sea_bottomToItemTop:_bottomView].priority = UILayoutPriorityDefaultHigh;
            }
        }
    }
}

#pragma mark- bottomView

- (void)setBottomView:(UIView *)bottomView
{
    [self setBottomView:bottomView height:SeaWrapContent];
}

/**
 设置底部视图
 
 @param bottomView 底部视图
 @param height 视图高度，SeaWrapContent 为自适应
 */
- (void)setBottomView:(UIView *)bottomView height:(CGFloat) height
{
    if(_bottomView != bottomView){
        
        if(_bottomView){
            [_bottomView removeFromSuperview];
        }
        
        _bottomView = bottomView;
        if(_bottomView){
            if(_bottomView.superview != self){
                [_bottomView removeFromSuperview];
                [self addSubview:_bottomView];
            }
    
            [_bottomView sea_leftToSuperview];
            [_bottomView sea_rightToSuperview];
            [_bottomView sea_bottomToSuperview];
            
            if(height != SeaWrapContent){
                [_bottomView sea_heightToSelf:height];
            }
            
            if(self.contentView){
                self.contentView.sea_bottomLayoutConstraint.priority = UILayoutPriorityDefaultLow;
                [self.contentView sea_bottomToItemTop:_bottomView].priority = UILayoutPriorityDefaultHigh;
            }
        }
    }
}

@end
