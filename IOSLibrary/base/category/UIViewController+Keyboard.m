//
//  UIViewController+Keyboard.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/4/28.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UIViewController+Keyboard.h"
#import <objc/runtime.h>

static char SeaKeyboardHiddenKey;
static char SeaKeyboardFrameKey;

@implementation UIViewController (Keyboard)

#pragma mark property

- (void)setKeyboardHidden:(BOOL)keyboardHidden
{
    objc_setAssociatedObject(self, &SeaKeyboardHiddenKey, @(keyboardHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)keyboardHidden
{
    return objc_getAssociatedObject(self, &SeaKeyboardHiddenKey);
}

- (void)setKeyboardFrame:(CGRect)keyboardFrame
{
    objc_setAssociatedObject(self, &SeaKeyboardFrameKey, [NSValue valueWithCGRect:keyboardFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)keyboardFrame
{
    return [objc_getAssociatedObject(self, &SeaKeyboardFrameKey) CGRectValue];
}

- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification*) notification
{
    if(!self.keyboardHidden){
        self.keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    }else{
        self.keyboardFrame = CGRectZero;
    }
}

- (void)keyboardDidChangeFrame:(NSNotification*) notification
{
    
}

//键盘隐藏
- (void)keyboardWillHide:(NSNotification*) notification
{
    self.keyboardHidden = YES;
    [self keyboardWillChangeFrame:notification];
}

//键盘显示
- (void)keyboardWillShow:(NSNotification*) notification
{
    self.keyboardHidden = NO;
    [self keyboardWillChangeFrame:notification];
}

@end
