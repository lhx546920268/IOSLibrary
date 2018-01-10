//
//  UITextView+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/8.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UITextView+Utils.h"
#import "UIView+SeaAutoLayout.h"

@implementation UITextView (Utils)

- (void)setDefaultInputAccessoryView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35.0)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleTapInputAccessoryView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [button sea_rightToSuperview];
    [button sea_topToSuperview];
    [button sea_bottomToSuperview];
    [button sea_widthToSelf:60];
    
    self.inputAccessoryView = view;
    
}

- (void)handleTapInputAccessoryView:(id) sender
{
    [self resignFirstResponder];
}

@end
