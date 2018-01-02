//
//  NSString+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/29.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Utils)

#pragma mark- 空判断

/**
 判断字符串是否为空，会去掉 空格 \n \r
 */
+ (BOOL)isEmpty:(NSString*) str;

/**
 判断字符串是否为空,字符串可以为空格
 */
+ (BOOL)isNull:(NSString*) str;

#pragma mark- encode

/**
 编码，使用 NSUTF8StringEncoding
 *@param str 要编码的字符串
 *@return 编码后的字符串
 */
+ (NSString*)sea_encodeStringWithUTF8:(NSString*) str;

/**
 编码
 *@param str 要编码的字符串
 *@param stringEncoding 编码方式
 *@return 编码后的字符串
 */
+ (NSString*)sea_encodeString:(NSString*) str stringEncoding:(NSStringEncoding) stringEncoding;

/**
 编码，使用 NSUTF8StringEncoding
 *@return 编码后的字符串
 */
- (NSString*)sea_encodeWithUTF8;

/**
 编码
 *@param stringEncoding 编码方式
 *@return 编码后的字符串
 */
- (NSString*)sea_encodeWithStringEncoding:(NSStringEncoding) stringEncoding;

#pragma mark- 获取

/**
 第一个字符
 */
- (char)sea_firstCharacter;

/**
 最后一个字符
 */
- (char)sea_lastCharacter;

/**
 从后面的字符串开始，获取对应字符的下标
 *@return 如果没有，返回NSNotFound
 */
- (NSInteger)sea_lastIndexOfCharacter:(char) c;

/**
 获取字符串所占位置大小
 *@param font 字符串要显示的字体
 *@param width 每行最大宽度
 *@return 字符串大小
 */
- (CGSize)sea_stringSizeWithFont:(UIFont*) font contraintWith:(CGFloat) width;

#pragma mark- chinese

/**
 把中文字符成 n 个字符的字符串长度
 */
- (NSUInteger)sea_lengthWithChineseAs:(int) numberOfChar;

/**
 删除中文
 */
- (NSString*)sea_stringByRemoveChinese;

#pragma mark- 百度

/**
 百度搜索链接
 */
+ (NSString*)sea_baiduURLForKey:(NSString*) key;

#pragma mark- md5

/**
 md5加密
 */
- (NSString*)seaMD5String;

#pragma mark- 验证合法性

/**
 是否是是手机号码
 */
- (BOOL)isMobile;

/**
 是否包含特殊字符
 */
- (BOOL)isContainSpecialCharacter;

/**
 是否是固定电话
 */
- (BOOL)isTelphone;

/**
 是否是邮箱
 */
- (BOOL)isEmail;

/**
 是否是身份证号码
 */
- (BOOL)isCardId;

/**
 是否是网址
 */
- (BOOL)isURL;

/**
 是否是中文
 */
- (BOOL)isChinese;

/**
 是否是纯数字
 */
- (BOOL)isDigitalOnly;

/**
 判断是否是整数
 */
- (BOOL)isInteger;

/**
 是否是纯字母
 */
- (BOOL)isAlphabetOnly;

/**
 是否是字母和数字组合
 */
- (BOOL)isConsistOfAlphabetOrDigital;

/**
 是否是银行卡
 */
- (BOOL)isBankCard;

#pragma mark- 正则

/**
 正则表达式验证

 @param format 正则表达式
 @return 验证结果
 */
- (BOOL)sea_evaluateWithFormat:(NSString*) format;

#pragma mark- 格式化

/**
 固定电话格式化
 */
- (NSString*)sea_formatTelphone;

@end

@interface NSMutableString (Utils)

/**
 移除最后一个字符
 */
- (void)sea_removeLastCharacter;

/**
 通过给定字符串，移除最后一个字符串
 */
- (void)sea_removeLastString:(NSString*) str;

@end
