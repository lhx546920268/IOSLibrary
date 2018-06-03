//
//  UIView+SeaToast.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/13.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UIView+SeaToast.h"
#import "SeaToast.h"
#import <objc/runtime.h>
#import "SeaBasic.h"
#import "UIView+SeaAutoLayout.h"

static char SeaToastkey;

@implementation UIView (SeaToast)

///显示提示信息
- (void)sea_alertMessage:(NSString*) message
{
    [self sea_alertMessage:message icon:nil];
}

///显示提示信息
- (void)sea_alertMessage:(NSString*) message icon:(UIImage*) icon
{
    [self sea_alertMessage:message icon:icon shouldRemoveOnDismiss:YES];
}

///显示提示信息
- (void)sea_alertMessage:(NSString*) message icon:(UIImage*) icon shouldRemoveOnDismiss:(BOOL) flag
{
    SeaToast *toast = [self sea_toast];
    toast.shouldRemoveOnDismiss = flag;
    
    WeakSelf(self);
    toast.dismissHanlder = ^(void){
        if(flag){
            [weakSelf setSea_Toaset:nil];
        }
    };
    toast.text = message;
    toast.icon = icon;
    [toast show];
}

- (SeaToast*)sea_toast
{
    SeaToast *toast = objc_getAssociatedObject(self, &SeaToastkey);
    if(!toast){
        toast = [SeaToast new];
        [self addSubview:toast];
        [toast sea_insetsInSuperview:UIEdgeInsetsZero];
        [self setSea_Toaset:toast];
    }
    
    return toast;
}

- (void)setSea_Toaset:(SeaToast*) toast
{
    objc_setAssociatedObject(self, &SeaToastkey, toast, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
