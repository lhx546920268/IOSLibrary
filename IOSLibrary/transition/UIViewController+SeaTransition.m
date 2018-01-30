//
//  UIViewController+SeaTransition.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/30.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UIViewController+SeaTransition.h"
#import <objc/runtime.h>
#import "UIViewController+Utils.h"
#import "SeaPartialPresentTransitionDelegate.h"

@implementation UIViewController (SeaTransition)

+ (void)load
{
    SEL selectors[] = {
        
        @selector(presentViewController:animated:completion:)
    };
    
    int count = sizeof(selectors) / sizeof(SEL);
    for(int i = 0;i < count;i ++){
        SEL selector1 = selectors[i];
        SEL selector2 = NSSelectorFromString([NSString stringWithFormat:@"sea_%@", NSStringFromSelector(selector1)]);
        Method method1 = class_getInstanceMethod(self, selector1);
        Method method2 = class_getInstanceMethod(self, selector2);
        
        method_exchangeImplementations(method1, method2);
    }
}

- (void)sea_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    //主要用于 当使用 SeaPartialPresentTransitionDelegate 部分显示某个UIViewController A时，在A中 preset UIViewController B，B dismiss时，A会变成全屏，设置UIModalPresentationCustom将不影响 A的大小
    UIViewController *viewController = self;
    if(self.parentViewController){
        viewController = self.parentViewController;
    }
    if([viewController.sea_transitioningDelegate isKindOfClass:[SeaPartialPresentTransitionDelegate class]]){
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    }
    [self sea_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
