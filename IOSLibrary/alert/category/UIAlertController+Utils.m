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

+ (void)sea_alertWithTitle:(NSString*) title message:(NSString*) message buttonTitles:(NSArray<NSString *> *)titles
{
    [self sea_controllerWithTitle:title message:message style:UIAlertControllerStyleAlert handler:nil buttonTitles:titles];
}

+ (void)sea_alertWithTitle:(NSString*) title message:(NSString*) message handler:(UIAlertControllerActionHandler) handler buttonTitles:(NSArray<NSString *> *)titles
{
    [self sea_controllerWithTitle:title message:message style:UIAlertControllerStyleAlert handler:handler buttonTitles:titles];
}

+ (void)sea_actionSheetWithMessage:(NSString*) message handler:(UIAlertControllerActionHandler) handler buttonTitles:(NSArray<NSString *> *)titles
{
    [self sea_controllerWithTitle:nil message:message style:UIAlertControllerStyleActionSheet handler:handler buttonTitles: titles];
}

///显示一个弹窗
+ (void)sea_controllerWithTitle:(NSString*) title message:(NSString*) message style:(UIAlertControllerStyle) style handler:(UIAlertControllerActionHandler) handler buttonTitles:(NSArray<NSString *> *)titles
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];

    int index = 0;
    for(NSString *title in titles){
        [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            !handler ?: handler(index);
        }]];
        index ++;
    }
    
    if(style == UIAlertControllerStyleActionSheet){
        //添加取消按钮
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            !handler ?: handler(index);
        }]];
    }
    
    [[[UIApplication sharedApplication].keyWindow.rootViewController sea_topestPresentedViewController] presentViewController:controller animated:YES completion:nil];
}

@end
