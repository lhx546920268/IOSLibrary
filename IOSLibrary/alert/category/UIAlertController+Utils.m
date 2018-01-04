//
//  UIAlertController+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/11/1.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UIAlertController+Utils.h"
#import "UIViewController+Utils.h"

@implementation UIAlertController (Utils)

+ (void)sea_alertWithTitle:(NSString*) title message:(NSString*) message buttonTitles:(NSString*) titles, ... NS_REQUIRES_NIL_TERMINATION
{
    [self sea_controllerWithTitle:title message:message style:UIAlertControllerStyleAlert handler:nil buttonTitles:titles, nil];
}

+ (void)sea_alertWithTitle:(NSString*) title message:(NSString*) message handler:(UIAlertControllerActionHandler) handler buttonTitles:(NSString*) titles, ... NS_REQUIRES_NIL_TERMINATION
{
    [self sea_controllerWithTitle:title message:message style:UIAlertControllerStyleAlert handler:handler buttonTitles:titles, nil];
}

///显示一个弹窗
+ (void)sea_controllerWithTitle:(NSString*) title message:(NSString*) message style:(UIAlertControllerStyle) style handler:(UIAlertControllerActionHandler) handler buttonTitles:(NSString*) buttonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    void(^actionHandler)(UIAlertAction *action) = ^(UIAlertAction *action){
        
    };
    va_list list;
    va_start(list, buttonTitles);
    NSString *args;
    do
    {
        args = va_arg(list, NSString*);
        if(args)
        {
            [controller addAction:[UIAlertAction actionWithTitle:args style:UIAlertActionStyleDefault handler:actionHandler]];
        }
        
    }while(args != nil);
    
    va_end(list);
    
    [[[UIApplication sharedApplication].keyWindow.rootViewController sea_topestPresentedViewController] presentViewController:controller animated:YES completion:nil];
}

@end
