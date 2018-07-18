//
//  SeaNumberBadge.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/15.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 圆形背景显示字符串
 */
@interface SeaNumberBadge : UIView

/**
 是否自动调整大小 default is 'YES'
 */
@property(nonatomic, assign) BOOL shouldAutoAdjustSize;

/**
 内容边距 default is 'UIEdgeInsetsMake(3, 5, 3, 5)'
 */
@property(nonatomic, assign) UIEdgeInsets contentInsets;

/**
 内部填充颜色 default is '[UIColor redColor]'
 */
@property(nonatomic,strong) UIColor *fillColor;

/**
 边界颜色 default is '[UIColor clearColor]'
 */
@property(nonatomic,strong) UIColor *strokeColor;

/**
 字体颜色 default is '[UIColor whiteColor]'
 */
@property(nonatomic,strong) UIColor *textColor;

/**
 字体 default is '16'
 */
@property(nonatomic,strong) UIFont *font;

/**
 当前要显示的字符
 */
@property(nonatomic,copy) NSString *value;

/**
 是否要显示加号 当达到最大值时 default is YES
 */
@property(nonatomic,assign) BOOL shouldDisplayPlusSign;

/**
 是否隐藏当 value = 0 时, default is 'YES'
 */
@property(nonatomic,assign) BOOL hideWhenZero;

/**
 显示的最大数字 default is '99'
 */
@property(nonatomic,assign) int max;

/**
 是否是一个点 default is 'NO'
 */
@property(nonatomic,assign) BOOL point;

/**
 点的半径 当 point = YES 时有效 default is '5.0'
 */
@property(nonatomic,assign) CGFloat pointRadius;

@end

