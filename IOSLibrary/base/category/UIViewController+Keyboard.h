//
//  UIViewController+Keyboard.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/4/28.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///键盘
@interface UIViewController (Keyboard)

/**
 键盘是否隐藏
 */
@property(nonatomic,readonly) BOOL keyboardHidden;

/**
 键盘大小
 */
@property(nonatomic,readonly) CGRect keyboardFrame;

/**
 添加键盘监听
 */
- (void)addKeyboardNotification;

/**
 移除键盘监听
 */
- (void)removeKeyboardNotification;

/**
 键盘高度改变
 */
- (void)keyboardWillChangeFrame:(NSNotification*) notification NS_REQUIRES_SUPER;
- (void)keyboardDidChangeFrame:(NSNotification*) notification;

/**
 键盘隐藏
 */
- (void)keyboardWillHide:(NSNotification*) notification NS_REQUIRES_SUPER;

/**
 键盘显示
 */
- (void)keyboardWillShow:(NSNotification*) notification NS_REQUIRES_SUPER;

@end
