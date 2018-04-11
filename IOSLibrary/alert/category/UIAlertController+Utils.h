//
//  UIAlertController+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/11/1.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///点击回调
typedef void(^UIAlertControllerActionHandler)(int index);

///弹窗工具类
@interface UIAlertController (Utils)

///显示一个弹窗
+ (void)sea_alertWithTitle:(NSString*) title message:(NSString*) message buttonTitles:(NSString*) titles, ... NS_REQUIRES_NIL_TERMINATION;

///显示一个弹窗
+ (void)sea_alertWithTitle:(NSString*) title message:(NSString*) message handler:(UIAlertControllerActionHandler) handler buttonTitles:(NSString*) titles, ... NS_REQUIRES_NIL_TERMINATION;

///显示一个actionSheet 不用增加取消按钮
+ (void)sea_actionSheetWithMessage:(NSString*) message handler:(UIAlertControllerActionHandler) handler buttonTitles:(NSString*) buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

///显示一个弹窗
+ (void)sea_controllerWithTitle:(NSString*) title message:(NSString*) message style:(UIAlertControllerStyle) style handler:(UIAlertControllerActionHandler) handler buttonTitles:(NSString*) buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
