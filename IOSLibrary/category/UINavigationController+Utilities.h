//
//  UINavigationController+Utilities.h
//  SeaBasic
//
//  Created by 罗海雄 on 15/11/12.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaNavigationBarAlphaOverlayView;

@interface UINavigationController (Utilities)

#pragma mark- transparent

///导航栏透明视图
@property(nonatomic, strong) SeaNavigationBarAlphaOverlayView *sea_alphaOverlay;

///设置导航栏透明度 范围 0 ~ 1.0
- (void)sea_setNavigationBarAlpha:(CGFloat) alpha;

///恢复导航栏原有状态
- (void)sea_restoreNavigationBar;

///启动导航栏透明功能
- (void)sea_openNavigationBarAlpha;

@end
