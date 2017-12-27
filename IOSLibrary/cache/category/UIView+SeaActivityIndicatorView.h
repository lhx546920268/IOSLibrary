//
//  UIView+SeaActivityIndicatorView.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SeaActivityIndicatorView)

/**
 显示 加载指示器
 */
@property(nonatomic, assign) BOOL sea_showActivityIndicator;

/**
 当前加载指示器
 */
@property(nonatomic, readonly) UIActivityIndicatorView *sea_activityIndicatorView;

@end
