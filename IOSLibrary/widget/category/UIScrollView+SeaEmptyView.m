//
//  UIScrollView+SeaEmptyView.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/12.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UIScrollView+SeaEmptyView.h"
#import "UIView+SeaEmptyView.h"
#import <objc/runtime.h>
#import "UIView+Utils.h"
#import "UIScrollView+SeaDataControl.h"

///是否显示空视图kkey
static char SeaShouldShowEmptyViewKey;

///偏移量
static char SeaEmptyViewInsetsKey;

@implementation UIScrollView (SeaEmptyView)


- (void)setSea_shouldShowEmptyView:(BOOL)sea_shouldShowEmptyView
{
    if(self.sea_shouldShowEmptyView != sea_shouldShowEmptyView)
    {
        objc_setAssociatedObject(self, &SeaShouldShowEmptyViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if(sea_shouldShowEmptyView)
        {
            [self layoutEmtpyView];
        }
        else
        {
            [self.sea_emptyView removeFromSuperview];
            self.sea_emptyView = nil;
        }
    }
}

- (BOOL)sea_shouldShowEmptyView
{
    return [objc_getAssociatedObject(self, &SeaShouldShowEmptyViewKey) boolValue];
}

- (void)setSea_emptyViewInsets:(UIEdgeInsets)sea_emptyViewInsets
{
    UIEdgeInsets insets = self.sea_emptyViewInsets;
    if(!UIEdgeInsetsEqualToEdgeInsets(insets, sea_emptyViewInsets))
    {
        objc_setAssociatedObject(self, &SeaEmptyViewInsetsKey, [NSValue valueWithUIEdgeInsets:sea_emptyViewInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self layoutEmtpyView];
    }
}

- (UIEdgeInsets)sea_emptyViewInsets
{
    return [objc_getAssociatedObject(self, &SeaEmptyViewInsetsKey) UIEdgeInsetsValue];
}



///调整emptyView
- (void)layoutEmtpyView
{
    if(!self.sea_shouldShowEmptyView)
        return;
    
    if([self isEmptyData])
    {
        SeaEmptyView *emptyView = self.sea_emptyView;
        if(!emptyView)
        {
            emptyView = [[SeaEmptyView alloc] init];
            self.sea_emptyView = emptyView;
        }
        
        [self layoutIfNeeded];
        UIEdgeInsets insets = self.sea_emptyViewInsets;
        
        emptyView.frame = CGRectMake(insets.left, insets.top, self.width - insets.left - insets.right, self.height - insets.top - insets.bottom);
        emptyView.hidden = NO;
        
        id<SeaEmptyViewDelegate> delegate = self.sea_emptyViewDelegate;
        if([delegate respondsToSelector:@selector(emptyViewWillAppear:)])
        {
            [delegate emptyViewWillAppear:emptyView];
        }
        
        if(!emptyView.superview)
        {
            if(self.loadMoreControl)
            {
                [self insertSubview:emptyView aboveSubview:self.loadMoreControl];
            }
            else
            {
                [self insertSubview:emptyView atIndex:0];
            }
        }
    }
    else
    {
        [self.sea_emptyView removeFromSuperview];
    }
}

///当前是空数据 UIScrollView 一定是空的，其他的不一定
- (BOOL)isEmptyData
{
    return YES;
}

@end
