//
//  UIView+SeaLoading.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/8.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UIView+SeaLoading.h"
#import <objc/runtime.h>
#import "SeaPageLoadingView.h"
#import "SeaNetworkActivityView.h"
#import "SeaFailPageView.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaLoadingStyle.h"

static char SeaShowPageLoadingKey;
static char SeaPageLoadingViewKey;
static char SeaShowNetworkActivityKey;
static char SeaNetworkActivityKey;
static char SeaShowFailPageKey;
static char SeaFailPageViewKey;
static char SeaReloadDataHandlerKey;

@implementation UIView (SeaLoading)

#pragma mark- page loading

- (void)setSea_showPageLoading:(BOOL)sea_showPageLoading
{
    if(sea_showPageLoading != self.sea_showPageLoading){
        objc_setAssociatedObject(self, &SeaShowPageLoadingKey, @(sea_showPageLoading), OBJC_ASSOCIATION_RETAIN);
        self.sea_showFailPage = NO;
        if(sea_showPageLoading){
            UIView *pageLoadingView = self.sea_pageLoadingView;
            if(!pageLoadingView){
                self.sea_pageLoadingView = [[SeaLoadingStyle sharedInstance].pageLoadingClass new];
            }
            [self bringSubviewToFront:pageLoadingView];
        }else{
            self.sea_pageLoadingView = nil;
        }
    }
}

- (BOOL)sea_showPageLoading
{
    return [objc_getAssociatedObject(self, &SeaShowPageLoadingKey) boolValue];
}

- (void)setSea_pageLoadingView:(UIView *)sea_pageLoadingView
{
    UIView *pageLoadingView = self.sea_pageLoadingView;
    if(pageLoadingView == sea_pageLoadingView)
        return;
    if(pageLoadingView){
        [pageLoadingView removeFromSuperview];
    }
    objc_setAssociatedObject(self, &SeaPageLoadingViewKey, sea_pageLoadingView, OBJC_ASSOCIATION_RETAIN);
    
    if(sea_pageLoadingView){
        [self addSubview:sea_pageLoadingView];
        [sea_pageLoadingView sea_insetsInSuperview:UIEdgeInsetsZero];
        //scrollView 需要确定滑动范围
        if([self isKindOfClass:[UIScrollView class]]){
            [sea_pageLoadingView sea_widthToItem:self];
            [sea_pageLoadingView sea_heightToItem:self];
        }
    }
}

- (UIView*)sea_pageLoadingView
{
    return objc_getAssociatedObject(self, &SeaPageLoadingViewKey);
}

#pragma mark- network activity

- (void)setSea_showNetworkActivity:(BOOL)sea_showNetworkActivity
{
    if(sea_showNetworkActivity != self.sea_showNetworkActivity){
        if(sea_showNetworkActivity){
            [self sea_showNetworkActivityAfterDelay:0];
        }else{
            objc_setAssociatedObject(self, &SeaShowNetworkActivityKey, @(NO), OBJC_ASSOCIATION_RETAIN);
            self.sea_networkActivity = nil;
        }
    }
}

- (void)sea_showNetworkActivityAfterDelay:(NSTimeInterval) delay
{
    if(self.sea_showNetworkActivity)
        return;
    objc_setAssociatedObject(self, &SeaShowNetworkActivityKey, @(YES), OBJC_ASSOCIATION_RETAIN);
    UIView *networkActivity = self.sea_networkActivity;
    
    if(!networkActivity){
        networkActivity = [[SeaLoadingStyle sharedInstance].networkActivityClass new];
        if([networkActivity isKindOfClass:[SeaNetworkActivityView class]]){
            [(SeaNetworkActivityView*)networkActivity setDelay:delay];
        }
        self.sea_networkActivity = networkActivity;
    }
    if([networkActivity isKindOfClass:[SeaNetworkActivityView class]]){
        [(SeaNetworkActivityView*)networkActivity setDelay:delay];
    }
    [self bringSubviewToFront:networkActivity];
}

- (BOOL)sea_showNetworkActivity
{
    return [objc_getAssociatedObject(self, &SeaShowNetworkActivityKey) boolValue];
}

- (void)setSea_networkActivity:(UIView *)sea_networkActivity
{
    UIView *networkActivity = self.sea_networkActivity;
    if(networkActivity == sea_networkActivity)
        return;
    if(networkActivity){
        [networkActivity removeFromSuperview];
    }
    objc_setAssociatedObject(self, &SeaNetworkActivityKey, sea_networkActivity, OBJC_ASSOCIATION_RETAIN);
    
    if(sea_networkActivity){
        [self addSubview:sea_networkActivity];
        [sea_networkActivity sea_insetsInSuperview:UIEdgeInsetsZero];
        //scrollView 需要确定滑动范围
        if([self isKindOfClass:[UIScrollView class]]){
            [sea_networkActivity sea_widthToItem:self];
            [sea_networkActivity sea_heightToItem:self];
        }
    }
}

- (UIView*)sea_networkActivity
{
    return objc_getAssociatedObject(self, &SeaNetworkActivityKey);
}

#pragma mark- fail page

- (void)setSea_showFailPage:(BOOL)sea_showFailPage
{
    if(sea_showFailPage != self.sea_showFailPage){
        objc_setAssociatedObject(self, &SeaShowFailPageKey, @(sea_showFailPage), OBJC_ASSOCIATION_RETAIN);
        
        if(sea_showFailPage){
            self.sea_showPageLoading = NO;
            UIView *failPageView = self.sea_failPageView;
            if(!failPageView){
                self.sea_failPageView = [[SeaLoadingStyle sharedInstance].failPageClass new];
            }
            [self bringSubviewToFront:failPageView];
        }else{
            self.sea_failPageView = nil;
        }
    }
}

- (BOOL)sea_showFailPage
{
    return [objc_getAssociatedObject(self, &SeaShowFailPageKey) boolValue];
}

- (void)setSea_failPageView:(UIView *)sea_failPageView
{
    UIView *failPageView = self.sea_failPageView;
    if(failPageView == sea_failPageView)
        return;
    if(failPageView){
        [failPageView removeFromSuperview];
    }
    objc_setAssociatedObject(self, &SeaFailPageViewKey, sea_failPageView, OBJC_ASSOCIATION_RETAIN);
    
    if(sea_failPageView){
        [self addSubview:sea_failPageView];
        
        [sea_failPageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTapFailPage:)]];
        [sea_failPageView sea_insetsInSuperview:UIEdgeInsetsZero];
        sea_failPageView.hidden = !self.sea_showFailPage;
        if([self isKindOfClass:[UIScrollView class]]){
            [sea_failPageView sea_widthToItem:self];
            [sea_failPageView sea_heightToItem:self];
        }
    }
}

- (UIView*)sea_failPageView
{
    return objc_getAssociatedObject(self, &SeaFailPageViewKey);
}

#pragma mark- handler

- (void)setSea_reloadDataHandler:(void (^)(void))sea_reloadDataHandler
{
    objc_setAssociatedObject(self, &SeaReloadDataHandlerKey, sea_reloadDataHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))sea_reloadDataHandler
{
    return objc_getAssociatedObject(self, &SeaReloadDataHandlerKey);
}

//点击失败视图
- (void)handlerTapFailPage:(UITapGestureRecognizer*) tap
{
    void(^handler)(void) = self.sea_reloadDataHandler;
    self.sea_showFailPage = NO;
    !handler ?: handler();
}

@end
