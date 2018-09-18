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
#import "UIView+SeaLoading.h"
#import "UIView+SeaEmptyView.h"

@interface SeaContainer()

///页面加载中
@property(nonatomic, strong) UIView *pageLoadingView;

///加载失败
@property(nonatomic, strong) UIView *failPageView;

@end

@implementation SeaContainer

- (instancetype)initWithViewController:(UIViewController*) viewController
{
    self = [super init];
    if(self){
        _viewController = viewController;
        [self initialization];
    }
    return self;
}

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
    self.backgroundColor = [UIColor whiteColor];
    self.safeLayoutGuide = SeaSafeLayoutGuideTop;
}

///布局的item
- (id)item
{
    return self.viewController ? self.viewController : self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    !self.layoutSubviewsHandler ?: self.layoutSubviewsHandler();
}

#pragma mark- topView

- (void)setTopView:(UIView *)topView
{
    [self setTopView:topView height:SeaWrapContent];
}

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
   
            if(self.safeLayoutGuide & SeaSafeLayoutGuideTop){
                [_topView sea_topToItem:self.item];
            }else{
                [_topView sea_topToSuperview];
            }
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideLeft){
                [_topView sea_leftToItem:self.item];
            }else{
                [_topView sea_leftToSuperview];
            }
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideRight){
                [_topView sea_rightToItem:self.item];
            }else{
                [_topView sea_rightToSuperview];
            }
            
            if(height != SeaWrapContent){
                [_topView sea_heightToSelf:height];
            }
            
            if(self.contentView){
                self.contentView.sea_topLayoutConstraint.active = NO;
                [self.contentView sea_topToItemBottom:_topView];
            }
            [_topView layoutIfNeeded];
            _topViewOriginalHeight = _topView.bounds.size.height;
        }else{
            _topViewOriginalHeight = 0;
            if(self.safeLayoutGuide & SeaSafeLayoutGuideTop){
                [self.contentView sea_topToItem:self.item];
            }else{
                [self.contentView sea_topToSuperview];
            }
        }
    }
}

#pragma mark- contentView


- (void)setContentView:(UIView *)contentView
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
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideLeft){
                [_contentView sea_leftToItem:self.item];
            }else{
                [_contentView sea_leftToSuperview];
            }
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideRight){
                [_contentView sea_rightToItem:self.item];
            }else{
                [_contentView sea_rightToSuperview];
            }
            
            if(_topView){
                [_contentView sea_topToItemBottom:_topView];
            }else{
                if(self.safeLayoutGuide & SeaSafeLayoutGuideTop){
                    [_contentView sea_topToItem:self.item];
                }else{
                    [_contentView sea_topToSuperview];
                }
            }
            
            if(_bottomView){
                [_contentView sea_bottomToItemTop:_bottomView];
            }else{
                if(self.safeLayoutGuide & SeaSafeLayoutGuideBottom){
                    [_contentView sea_bottomToItem:self.item];
                }else{
                    [_contentView sea_bottomToSuperview];
                }
            }
        }
    }
}

#pragma mark- bottomView

- (void)setBottomView:(UIView *)bottomView
{
    [self setBottomView:bottomView height:SeaWrapContent];
}

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
    
            if(self.safeLayoutGuide & SeaSafeLayoutGuideLeft){
                [_bottomView sea_leftToItem:self.item];
            }else{
                [_bottomView sea_leftToSuperview];
            }
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideRight){
                [_bottomView sea_rightToItem:self.item];
            }else{
                [_bottomView sea_rightToSuperview];
            }
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideBottom){
                [_bottomView sea_bottomToItem:self.item];
            }else{
                [_bottomView sea_bottomToSuperview];
            }
            
            if(height != SeaWrapContent){
                [_bottomView sea_heightToSelf:height];
            }
            
            if(self.contentView){
                self.contentView.sea_bottomLayoutConstraint.active = NO;
                [self.contentView sea_bottomToItemTop:_bottomView];
            }
            [_bottomView layoutIfNeeded];
            _bottomViewOriginalHeight = _bottomView.bounds.size.height;
        }else{
            _bottomViewOriginalHeight = 0;
            if(self.safeLayoutGuide & SeaSafeLayoutGuideBottom){
                [self.contentView sea_bottomToItem:self.item];
            }else{
                [self.contentView sea_bottomToSuperview];
            }
        }
    }
}

- (void)setTopViewHidden:(BOOL) hidden animate:(BOOL) animate
{
    NSLayoutConstraint *constraint = self.topView.sea_bottomLayoutConstraint;
    if(constraint){
        if(!hidden){
            self.topView.hidden = hidden;
        }
        
        WeakSelf(self);
        [UIView animateWithDuration:0.25 animations:^(void){
            
            constraint.constant = hidden ? 0 : -weakSelf.topViewOriginalHeight;
            [weakSelf layoutIfNeeded];
        } completion:^(BOOL finished){
            
            weakSelf.topView.hidden = hidden;
        }];
    }
}

- (void)setBottomViewHidden:(BOOL) hidden animate:(BOOL) animate
{
    NSLayoutConstraint *constraint = self.bottomView.sea_bottomLayoutConstraint;
    if(constraint){
        if(!hidden){
            self.bottomView.hidden = hidden;
        }
        
        WeakSelf(self);
        [UIView animateWithDuration:0.25 animations:^(void){
            
            constraint.constant = !hidden ? 0 : -weakSelf.bottomViewOriginalHeight;
            [weakSelf layoutIfNeeded];
        } completion:^(BOOL finished){
            
            weakSelf.bottomView.hidden = hidden;
        }];
    }
}

#pragma mark emptyView

- (void)layoutEmtpyView
{
    if(self.sea_showEmptyView){
        SeaEmptyView *emptyView = self.sea_emptyView;
        if(emptyView != nil && emptyView.superview == nil){
            id<SeaEmptyViewDelegate> delegate = self.sea_emptyViewDelegate;
            if([delegate respondsToSelector:@selector(emptyViewWillAppear:)]){
                [delegate emptyViewWillAppear:emptyView];
            }
            [self addSubview:emptyView];
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideLeft){
                [emptyView sea_leftToItem:self.item];
            }else{
                [emptyView sea_leftToSuperview];
            }
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideRight){
                [emptyView sea_rightToItem:self.item];
            }else{
                [emptyView sea_rightToSuperview];
            }
            
            if(_topView && !(self.overlayArea & SeaOverlayAreaEmptyViewTop)){
                [emptyView sea_topToItemBottom:_topView];
            }else{
                if(self.safeLayoutGuide & SeaSafeLayoutGuideTop){
                    [emptyView sea_topToItem:self.item];
                }else{
                    [emptyView sea_topToSuperview];
                }
            }
            
            if(_bottomView && !(self.overlayArea & SeaOverlayAreaEmptyViewBottom)){
                [emptyView sea_bottomToItemTop:_bottomView];
            }else{
                if(self.safeLayoutGuide & SeaSafeLayoutGuideBottom){
                    [emptyView sea_bottomToItem:self.item];
                }else{
                    [emptyView sea_bottomToSuperview];
                }
            }
        }
    }
}

#pragma mark fail page

- (UIView*)sea_failPageView
{
    return self.failPageView;
}

- (void)setSea_failPageView:(UIView *)sea_failPageView
{
    if(sea_failPageView == nil){
        [self.failPageView removeFromSuperview];
        self.failPageView = nil;
    }else{
        self.failPageView = sea_failPageView;
        if(!sea_failPageView.superview){
            [self addSubview:sea_failPageView];
            
            [sea_failPageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTapFailPage:)]];
        
            if(self.safeLayoutGuide & SeaSafeLayoutGuideLeft){
                [sea_failPageView sea_leftToItem:self.item];
            }else{
                [sea_failPageView sea_leftToSuperview];
            }
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideRight){
                [sea_failPageView sea_rightToItem:self.item];
            }else{
                [sea_failPageView sea_rightToSuperview];
            }
            
            if(_topView && !(self.overlayArea & SeaOverlayAreaFailTop)){
                [sea_failPageView sea_topToItemBottom:_topView];
            }else{
                if(self.safeLayoutGuide & SeaSafeLayoutGuideTop){
                    [sea_failPageView sea_topToItem:self.item];
                }else{
                    [sea_failPageView sea_topToSuperview];
                }
            }
            
            if(_bottomView && !(self.overlayArea & SeaOverlayAreaFailBottom)){
                [sea_failPageView sea_bottomToItemTop:_bottomView];
            }else{
                if(self.safeLayoutGuide & SeaSafeLayoutGuideBottom){
                    [sea_failPageView sea_bottomToItem:self.item];
                }else{
                    [sea_failPageView sea_bottomToSuperview];
                }
            }
        }
    }
}

#pragma mark page loading

- (UIView*)sea_pageLoadingView
{
    return self.pageLoadingView;
}

- (void)setSea_pageLoadingView:(UIView *)sea_pageLoadingView
{
    if(sea_pageLoadingView == nil){
        [self.pageLoadingView removeFromSuperview];
        self.pageLoadingView = nil;
    }else{
        self.pageLoadingView = sea_pageLoadingView;
        if(!sea_pageLoadingView.superview){
            [self addSubview:sea_pageLoadingView];
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideLeft){
                [sea_pageLoadingView sea_leftToItem:self.item];
            }else{
                [sea_pageLoadingView sea_leftToSuperview];
            }
            
            if(self.safeLayoutGuide & SeaSafeLayoutGuideRight){
                [sea_pageLoadingView sea_rightToItem:self.item];
            }else{
                [sea_pageLoadingView sea_rightToSuperview];
            }
            
            if(_topView && !(self.overlayArea & SeaOverlayAreaPageLoadingTop)){
                [sea_pageLoadingView sea_topToItemBottom:_topView];
            }else{
                if(self.safeLayoutGuide & SeaSafeLayoutGuideTop){
                    [sea_pageLoadingView sea_topToItem:self.item];
                }else{
                    [sea_pageLoadingView sea_topToSuperview];
                }
            }
            
            if(_bottomView && !(self.overlayArea & SeaOverlayAreaPageLoadingBottom)){
                [sea_pageLoadingView sea_bottomToItemTop:_bottomView];
            }else{
                if(self.safeLayoutGuide & SeaSafeLayoutGuideBottom){
                    [sea_pageLoadingView sea_bottomToItem:self.item];
                }else{
                    [sea_pageLoadingView sea_bottomToSuperview];
                }
            }
        }
    }
}

@end
