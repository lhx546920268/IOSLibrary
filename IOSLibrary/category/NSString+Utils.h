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

/**判断字符串是否为空，会去掉 空格 \n \r
 */
+ (BOOL)isEmpty:(NSString*) str;

/**判断字符串是否为空,字符串可以为空格
 */
+ (BOOL)isNull:(NSString*) str;

#pragma mark- encode

/**编码，使用 NSUTF8StringEncoding
 *@param str 要编码的字符串
 *@return 编码后的字符串
 */
+ (NSString*)sea_encodeStringWithUTF8:(NSString*) str;

/**编码
 *@param str 要编码的字符串
 *@param stringEncoding 编码方式
 *@return 编码后的字符串
 */
+ (NSString*)sea_encodeString:(NSString*) str stringEncoding:(NSStringEncoding) stringEncoding;

/**编码，使用 NSUTF8StringEncoding
 *@return 编码后的字符串
 */
- (NSString*)sea_encodeWithUTF8;

/**编码
 *@param stringEncoding 编码方式
 *@return 编码后的字符串
 */
- (NSString*)sea_encodeWithStringEncoding:(NSStringEncoding) stringEncoding;

#pragma mark- 获取

/**第一个字符
 */
- (char)sea_firstCharacter;

/**最后一个字符
 */
- (char)sea_lastCharacter;

/**从后面的字符串开始，获取对应字符的下标
 *@return 如果没有，返回NSNotFound
 */
- (NSInteger)sea_lastIndexOfCharacter:(char) c;

/**把中文字符成两个字符的字符串长度
 */
- (NSUInteger)lengthWithChineseAsTwoChar;

/**获取字符串所占位置大小
 *@param font 字符串要显示的字体
 *@param width 每行最大宽度
 *@return 字符串大小
 */
- (CGSize)stringSizeWithFont:(UIFont*) font contraintWith:(CGFloat) width;

///删除中文
- (NSString*)stringByRemoveChinese;

@end
