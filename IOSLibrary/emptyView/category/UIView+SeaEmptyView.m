//
//  UIView+SeaEmptyView.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/12.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UIView+SeaEmptyView.h"
#import <objc/runtime.h>
#import "SeaWeakObjectContainer.h"
#import "UIView+SeaAutoLayout.h"

///空视图key
static char SeaEmptyViewKey;

///代理
static char SeaEmptyViewDelegateKey;

///显示空视图
static char SeaShowEmptyViewKey;

@implementation UIView (SeaEmptyView)

- (SeaEmptyView*)sea_emptyView
{
    SeaEmptyView *emptyView = objc_getAssociatedObject(self, &SeaEmptyViewKey);
    if(!emptyView)
    {
        emptyView = [[SeaEmptyView alloc] init];
        objc_setAssociatedObject(self, &SeaEmptyViewKey, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return emptyView;
}


- (void)setSea_showEmptyView:(BOOL)sea_showEmptyView
{
    if(sea_showEmptyView != self.sea_showEmptyView){
        objc_setAssociatedObject(self, &SeaShowEmptyViewKey, @(sea_showEmptyView), OBJC_ASSOCIATION_RETAIN);
        SeaEmptyView *emptyView = self.sea_emptyView;
        if(sea_showEmptyView){
            id<SeaEmptyViewDelegate> delegate = self.sea_emptyViewDelegate;
            if([delegate respondsToSelector:@selector(emptyViewWillAppear:)]){
                [delegate emptyViewWillAppear:emptyView];
            }
            [self addSubview:emptyView];
            [self layoutEmtpyView];
        }else{
            [emptyView removeFromSuperview];
        }
    }
}

- (BOOL)sea_showEmptyView
{
    return [objc_getAssociatedObject(self, &SeaShowEmptyViewKey) boolValue];
}

- (void)setSea_emptyViewDelegate:(id<SeaEmptyViewDelegate>)sea_emptyViewDelegate
{
    SeaWeakObjectContainer *container = objc_getAssociatedObject(self, &SeaEmptyViewDelegateKey);
    if(!container)
    {
        container = [[SeaWeakObjectContainer alloc] init];
    }
    
    container.weakObject = sea_emptyViewDelegate;
    objc_setAssociatedObject(self, &SeaEmptyViewDelegateKey, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<SeaEmptyViewDelegate>)sea_emptyViewDelegate
{
    SeaWeakObjectContainer *container = objc_getAssociatedObject(self, &SeaEmptyViewDelegateKey);
    return container.weakObject;
}

///调整emptyView
- (void)layoutEmtpyView
{
    if(self.sea_showEmptyView){
        UIView *emptyView = self.sea_emptyView;
        if(!emptyView.sea_existConstraints){
            [emptyView sea_insetsInSuperview:UIEdgeInsetsZero];
            if([self isKindOfClass:[UIScrollView class]]){
                [emptyView sea_widthToItem:self];
                [emptyView sea_heightToItem:self];
            }
        }
    }
}

@end
