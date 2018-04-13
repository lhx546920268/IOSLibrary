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

///旧的视图大小
static char SeaOldSizeKey;

@implementation UIView (SeaEmptyView)

- (SeaEmptyView*)sea_emptyView
{
    return objc_getAssociatedObject(self, &SeaEmptyViewKey);;
}

- (void)setSea_emptyView:(SeaEmptyView *)sea_emptyView
{
    UIView *emptyView = self.sea_emptyView;
    if(emptyView != sea_emptyView){
        [emptyView removeFromSuperview];
        objc_setAssociatedObject(self, &SeaEmptyViewKey, sea_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setSea_showEmptyView:(BOOL)sea_showEmptyView
{
    if(sea_showEmptyView != self.sea_showEmptyView){
        objc_setAssociatedObject(self, &SeaShowEmptyViewKey, @(sea_showEmptyView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if(sea_showEmptyView){
            if(!self.sea_emptyView){
                self.sea_emptyView = [SeaEmptyView new];
            }
            [self layoutEmtpyView];
        }else{
            self.sea_emptyView = nil;
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
        SeaEmptyView *emptyView = self.sea_emptyView;
        if(emptyView != nil && emptyView.superview == nil){
            id<SeaEmptyViewDelegate> delegate = self.sea_emptyViewDelegate;
            if([delegate respondsToSelector:@selector(emptyViewWillAppear:)]){
                [delegate emptyViewWillAppear:emptyView];
            }
            [self addSubview:emptyView];
            [emptyView sea_insetsInSuperview:UIEdgeInsetsZero];
            if([self isKindOfClass:[UIScrollView class]]){
                [emptyView sea_widthToItem:self];
                [emptyView sea_heightToItem:self];
            }
        }
    }
}

- (CGSize)sea_oldSize
{
    NSValue *value = objc_getAssociatedObject(self, &SeaOldSizeKey);
    return !value ? CGSizeZero : [value CGSizeValue];
}

- (void)setSea_oldSize:(CGSize)sea_oldSize
{
    objc_setAssociatedObject(self, &SeaOldSizeKey, [NSValue valueWithCGSize:sea_oldSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
