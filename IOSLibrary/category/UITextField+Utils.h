//
//  UITextField+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

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

#pragma mark- 文本限制

/**在textField的代理中调用
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param count 输入框最大可输入字数
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitedCount:(NSInteger) count;

/**在textField的代理中调用,把中文当成两个字符
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param count 输入框最大可输入字数
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitedCountChinesseAsTwoChar:(NSInteger) count;

/**设置默认的附加视图
 *@param target 方法执行者
 *@param action 方法
 */
- (void)setDefaultInputAccessoryViewWithTarget:(id) target action:(SEL) action;

/**在textField的代理中调用，限制只能输入一个小数点，并且第一个输入不能是小数点，无法输入除了数字和.以外的字符
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param limitedNum 输入框可输入的最大值
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitedNum:(double) limitedNum;

/**添加文本变化通知，用于中文输入限制，因为输入中文的时候 textField的代理是没有调用的
 */
- (void)addTextDidChangeNotification;

#pragma mark- 格式化

/**在textField的代理中调用
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param interval 格式化间隔，如4个字符空一格
 *@param count 输入框最大可输入字数
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string formatTextWithInterval:(int) interval limitCount:(NSInteger) count;


/**在textField的代理中调用，限制只能输入一个小数点，并且可补全字符串
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param limitedNum 输入框可输入的最大值
 *@param repairString 补全字符
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitedNum:(double) limitedNum repairString:(NSString*) repairString;

/**固定电话格式化
 *@param range 文本变化的范围
 *@param string 替换的文字
 */
- (BOOL)telPhoneNumberShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

#pragma mark- property

/**禁止的方法列表，如复制，粘贴，通过 NSStringFromSelector 把需要禁止的方法传进来，如禁止粘贴，可传 NSStringFromSelector(paste:) default is 'nil'
 */
@property(nonatomic,strong) NSArray *forbidSelectors;

///光标位置
@property(nonatomic,assign) NSRange selectedRange;

///输入限制时是否把中文当成两个字符 default is 'NO'
@property(nonatomic,assign) BOOL chineseAsTwoCharWhenInputLimit;

///最大输入限制 default is '0'，无输入限制
@property(nonatomic,assign) NSInteger inputLimitMax;

///输入改变前的文本
@property(nonatomic,copy) NSString *previousText;

///是否禁止输入中文 和 chineseAsTwoCharWhenInputLimit 不兼容
@property(nonatomic,assign) BOOL forbidInputChinese;


@end
