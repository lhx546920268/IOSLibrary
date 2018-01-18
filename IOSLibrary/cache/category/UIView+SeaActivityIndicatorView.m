//
//  UIView+SeaActivityIndicatorView.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UIView+SeaActivityIndicatorView.h"
#import <objc/runtime.h>
#import "UIView+SeaAutoLayout.h"

///显示加载指示器
static char SeaShowActivityIndicatorKey;

///当前加载指示器
static char SeaActivityIndicatorViewKey;

@implementation UIView (SeaActivityIndicatorView)

- (void)setSea_showActivityIndicator:(BOOL)sea_showActivityIndicator
{
    if(sea_showActivityIndicator != self.sea_showActivityIndicator){
        objc_setAssociatedObject(self, &SeaShowActivityIndicatorKey, @(sea_showActivityIndicator), OBJC_ASSOCIATION_RETAIN);
        
        if(sea_showActivityIndicator){
            [self.sea_activityIndicatorView startAnimating];
        }else{
            [self.sea_activityIndicatorView stopAnimating];
        }
    }
}

- (BOOL)sea_showActivityIndicator
{
    return [objc_getAssociatedObject(self, &SeaShowActivityIndicatorKey) boolValue];
}

- (UIActivityIndicatorView*)sea_activityIndicatorView
{
    UIActivityIndicatorView *view = objc_getAssociatedObject(self, &SeaActivityIndicatorViewKey);
    if(!view){
        view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:view];
        
        [view sea_centerInSuperview];
        objc_setAssociatedObject(self, &SeaActivityIndicatorViewKey, view, OBJC_ASSOCIATION_RETAIN);
    }
    
    return view;
}

@end
