//
//  SeaDefaultLoadMoreControl.h
//  IOSLibrary
//
//  Created by luohaixiong on 2018/7/20.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaLoadMoreControl.h"

/**
 默认的加载更多控件
 */
@interface SeaDefaultLoadMoreControl : SeaLoadMoreControl

/**
 加载菊花
 */
@property(nonatomic,readonly) UIActivityIndicatorView *activityIndicatorView;

/**
 加载显示的提示信息
 */
@property(nonatomic,readonly) UILabel *remindLabel;

@end
