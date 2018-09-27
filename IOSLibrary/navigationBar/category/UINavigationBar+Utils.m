//
//  UINavigationBar+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/19.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UINavigationBar+Utils.h"
#import <objc/runtime.h>
#import "SeaBasic.h"

static char SeaExistBackItemKey;

@implementation UINavigationBar (Utils)

+ (void)load
{
    if(@available(iOS 11, *)){
        Method method1 = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method method2 = class_getInstanceMethod(self, @selector(sea_layoutSubviews));
        method_exchangeImplementations(method1, method2);
    }
}

- (void)sea_layoutSubviews
{
    [self sea_layoutSubviews];
    
    CGFloat margin = SeaNavigationBarMargin;
    [self sea_setNavigationItemMargin:UIEdgeInsetsMake(0, margin, 0, margin)];
}

- (void)setSea_existBackItem:(BOOL)sea_existBackItem
{
    objc_setAssociatedObject(self, &SeaExistBackItemKey, @(sea_existBackItem), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)sea_existBackItem
{
    return [objc_getAssociatedObject(self, &SeaExistBackItemKey) boolValue];
}

- (void)sea_setNavigationItemMargin:(UIEdgeInsets)margins
{
    //ios 11适配间距
    if(@available(iOS 11, *)){
        for(UIView *view in self.subviews){
            
            //_UINavigationBarContentView
            if([NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarContentView"]){
                //系统默认为20
                if(self.sea_existBackItem){
                    margins.left = 0;
                }
                view.layoutMargins = margins;
                view.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(0, margins.left, 0, margins.right);
                break;
            }
        }
    }
}

@end
