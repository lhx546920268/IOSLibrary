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


///空视图key
static char SeaEmptyViewKey;

///代理
static char SeaEmptyViewDelegateKey;

@implementation UIView (SeaEmptyView)

- (SeaEmptyView*)sea_emptyView
{
    return objc_getAssociatedObject(self, &SeaEmptyViewKey);
}

- (void)setSea_emptyView:(SeaEmptyView *)sea_emptyView
{
    objc_setAssociatedObject(self, &SeaEmptyViewKey, sea_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

@end
