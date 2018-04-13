//
//  SeaContainer.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/7.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///自动布局 安全区域
typedef NS_OPTIONS(NSUInteger, SeaSafeLayoutGuide){
    
    ///没有
    SeaSafeLayoutGuideNone = 0,
    
    ///上
    SeaSafeLayoutGuideTop = 1 << 0,
    
    ///左
    SeaSafeLayoutGuideLeft = 1 << 1,
    
    ///下
    SeaSafeLayoutGuideBottom = 1 << 2,
    
    ///右
    SeaSafeLayoutGuideRight = 1 << 3,
    
    ///全部
    SeaSafeLayoutGuideAll = SeaSafeLayoutGuideTop | SeaSafeLayoutGuideLeft | SeaSafeLayoutGuideBottom | SeaSafeLayoutGuideRight,
};

///自动布局 loading 范围
typedef NS_OPTIONS(NSUInteger, SeaLoadingOverlayArea){
    
    ///都不遮住 header 和 footer会看到得到
    SeaLoadingOverlayAreaNone = 0,
    
    ///失败视图将遮住header
    SeaLoadingOverlayAreaFailTop = 1 << 0,
    
    ///失败视图将遮住footer
    SeaLoadingOverlayAreaFailBottom = 1 << 1,
    
    ///pageloading视图将遮住header
    SeaLoadingOverlayAreaPageLoadingTop = 1 << 2,
    
    ///pageloading视图将遮住footer
    SeaLoadingOverlayAreaPageLoadingBottom = 1 << 3,
};

/**
 基础容器视图
 */
@interface SeaContainer : UIView

///固定在顶部的视图
@property(nonatomic, strong) UIView *topView;

///顶部视图原始高度
@property(nonatomic, readonly) CGFloat topViewOriginalHeight;

///固定在底部的视图
@property(nonatomic, strong) UIView *bottomView;

///底部视图原始高度
@property(nonatomic, readonly) CGFloat bottomViewOriginalHeight;

///内容视图
@property(nonatomic, strong) UIView *contentView;

///关联的viewController
@property(nonatomic, weak, readonly) UIViewController *viewController;

///自动布局 安全区域 default is 'SeaSafeLayoutGuideTop'
@property(nonatomic, assign) SeaSafeLayoutGuide safeLayoutGuide;

///自动布局 loading 范围
@property(nonatomic, assign) SeaLoadingOverlayArea overlayArea;

///初始化
- (void)initialization;

/**
 通过 UIViewController初始化
 */
- (instancetype)initWithViewController:(UIViewController*) viewController;

/**
 设置顶部视图

 @param topView 顶部视图
 @param height 视图高度，SeaWrapContent 为自适应
 */
- (void)setTopView:(UIView *)topView height:(CGFloat) height;

/**
 设置底部视图
 
 @param bottomView 底部视图
 @param height 视图高度，SeaWrapContent 为自适应
 */
- (void)setBottomView:(UIView *)bottomView height:(CGFloat) height;

/**
 设置顶部视图隐藏 视图必须有高度约束

 @param hidden 是否隐藏
 @param animate 是否动画
 */
- (void)setTopViewHidden:(BOOL) hidden animate:(BOOL) animate;

/**
 设置底部视图隐藏 视图必须有高度约束

 @param hidden 是否隐藏
 @param animate 是否动画
 */
- (void)setBottomViewHidden:(BOOL) hidden animate:(BOOL) animate;


@end
