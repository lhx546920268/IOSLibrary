//
//  UISearchBar+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (Utils)

///输入框
@property(nonatomic,readonly) UITextField *sea_searchedTextField;

///取消按钮
@property(nonatomic,readonly) UIButton *sea_searchedCancelButton;

@end
