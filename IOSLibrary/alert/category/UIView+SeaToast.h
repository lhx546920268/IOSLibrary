//
//  UIView+SeaToast.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/13.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///显示提示信息
@interface UIView (SeaToast)

///显示提示信息
- (void)sea_alertMessage:(NSString*) message;

///显示提示信息
- (void)sea_alertMessage:(NSString*) message icon:(UIImage*) icon;

///显示提示信息
- (void)sea_alertMessage:(NSString*) message icon:(UIImage*) icon shouldRemoveOnDismiss:(BOOL) flag;

@end
