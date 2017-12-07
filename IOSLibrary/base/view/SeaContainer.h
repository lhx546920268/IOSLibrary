//
//  SeaContainer.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/7.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 基础容器视图
 */
@interface SeaContainer : UIView

///固定在顶部的视图
@property(nonatomic, strong) UIView *topView;

///固定在底部的视图
@property(nonatomic, strong) UIView *bottomView;

///内容视图
@property(nonatomic, strong) UIView *contentView;

///初始化
- (void)initialization;


/**
 设置顶部视图

 @param topView 顶部视图
 @param height 视图高度，SeaWrapContent 为自适应
 */
- (void)setTopView:(UIView *)topView height:(CGFloat) height;

/**
 设置内容视图
 
 @param contentView 内容视图
 @param height 视图高度
 */
- (void)setContentView:(UIView *)contentView height:(CGFloat) height;

@end
