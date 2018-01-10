//
//  SeaProgressView.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/9.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 进度条样式
 */
typedef NS_ENUM(NSInteger, SeaProgressViewStyle)
{
    ///直线
    SeaProgressViewStyleStraightLine = 0,
    
    ///圆环
    SeaProgressViewStyleCircle = 1,
    
    ///圆饼 从空到满
    SeaProgressViewStyleRoundCakesFromEmpty = 2,
    
    ///圆饼 从满到空
    SeaProgressViewStyleRoundCakesFromFull = 3,
};

/**
 进度条
 */
@interface SeaProgressView : UIView

/**
 是否开启进度条 default is 'YES' 当设置为NO时，将重置 progress
 */
@property(nonatomic,assign) BOOL openProgress;

/**
 当前进度，default is '0.0'，范围 0.0 ~ 1.0 当 openProgress = NO 时，忽略所有设置的值
 */
@property(nonatomic,assign) float progress;

/**
 进度条进度颜色 default is 'greenColor'
 */
@property(nonatomic,strong) UIColor *progressColor;

/**
 进度条轨道颜色 default is '[UIColor colorWithWhite:0.9 alpha:1.0]'
 */
@property(nonatomic,strong) UIColor *trackColor;

/**
 进度条样式
 */
@property(nonatomic,readonly) SeaProgressViewStyle style;

/**
 进度条线条大小，当style = SeaProgressViewStyleCircle，default is '10.0'，当 style = SeaProgressViewStyleRoundCakes，default is '3.0'
 */
@property(nonatomic,assign) CGFloat progressLineWidth;

/**
 是否隐藏 当进度满的时候 default is 'YES'
 */
@property(nonatomic,assign) BOOL hideAfterFinish;

/**
 是否动画隐藏，使用渐变 default is 'YES'
 */
@property(nonatomic,assign) BOOL hideWidthAnimated;

/**
 是否显示百分比 default is 'NO'，只有当style = SeaProgressViewStyleCircle 时 有效
 */
@property(nonatomic,assign) BOOL showPercent;

/**
 百分比label, 显示在圆环中间，只有当style = SeaProgressViewStyleCircle && showPercent = YES 时 有效
 */
@property(nonatomic,readonly) UILabel *percentLabel;


/**
 [self initWithFrame:CGRectZero style:style]
 */
- (instancetype)initWithStyle:(SeaProgressViewStyle) style;

/**
 构造方法
 *@param frame 位置大小
 *@param style 进度条样式
 *@return 一个实例
 */
- (instancetype)initWithFrame:(CGRect)frame style:(SeaProgressViewStyle) style;

@end
