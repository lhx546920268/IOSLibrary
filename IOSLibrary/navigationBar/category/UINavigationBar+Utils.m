//
//  UINavigationBar+Utils.m
//  AutoLayoutDemo
//
//  Created by 罗海雄 on 2017/12/19.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UINavigationBar+Utils.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Utils)

+ (void)load
{
    Method method1 = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method method2 = class_getInstanceMethod(self, @selector(sea_layoutSubviews));
    method_exchangeImplementations(method1, method2);
}

- (void)sea_layoutSubviews
{
    [self sea_layoutSubviews];
    
    //ios 11适配间距
    if(@available(iOS 11, *)){
        for(UIView *view in self.subviews){
            
            //_UINavigationBarContentView
            if([NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarContentView"]){
                CGFloat margin = 10; //系统默认为20
                view.layoutMargins = UIEdgeInsetsMake(0, margin, 0, margin);
                view.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(0, margin, 0, margin);
                break;
            }
        }
    }
}

@end
