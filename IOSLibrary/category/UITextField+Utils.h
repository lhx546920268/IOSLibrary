//
//  UITextField+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Utils.h"

@interface UITextField (Utils)

#pragma mark- 内嵌视图

/**
 设置输入框左边图标
 *@param imageName 图标名称
 *@param padding 图标与文字的间距
 */
- (void)sea_setLeftViewWithImageName:(NSString*) imageName padding:(CGFloat) padding;

/**
 设置输入框右边图标
 *@param imageName 图标名称
 *@param padding 图标与文字的间距
 */
- (void)sea_setRightViewWithImageName:(NSString*) imageName padding:(CGFloat) padding;

/**
 设置默认分割线
 */
- (UIView*)sea_setDefaultSeparator;

/**
 底部分割线
 *@param color 分割线颜色
 *@param height 分割线高度
 *@return 分割线 使用autoLayout
 */
- (UIView*)sea_setSeparatorWithColor:(UIColor*) color height:(CGFloat) height;

/**
 设置默认的附加视图
 */
- (void)setDefaultInputAccessoryView;

/**在textField的代理中调用
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param interval 格式化间隔，如4个字符空一格
 *@param count 输入框最大可输入字数
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string formatTextWithInterval:(int) interval limitCount:(NSInteger) count;

/**固定电话格式化
 *@param range 文本变化的范围
 *@param string 替换的文字
 */
- (BOOL)telPhoneNumberShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

#pragma mark- 文本限制

/** 用于 sea_extraString
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 */
- (BOOL)sea_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 输入最大长度 default is 'NSUIntegerMax' 没有限制
 */
@property(nonatomic, assign) NSUInteger sea_maxLength;

/**
 输入类型 default is 'SeaTextTypeAll'
 */
@property(nonatomic, assign) SeaTextType sea_textType;

/**
 额外字符串 放在文字后面 需要配合 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 一起使用
 */
@property(nonatomic, copy) NSString *sea_extraString;

/**
 禁止的方法列表，如复制，粘贴，通过 NSStringFromSelector 把需要禁止的方法传进来，如禁止粘贴，可传 NSStringFromSelector(paste:) default is 'nil'
 */
@property(nonatomic,strong) NSArray<NSString*> *sea_forbiddenActions;

/**
 光标位置
 */
@property(nonatomic,assign) NSRange sea_selectedRange;


@end
