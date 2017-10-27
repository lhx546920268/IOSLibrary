//
//  NSString+customString.h

//

#import <UIKit/UIKit.h>

@interface NSString (Utilities)

#pragma mark- 空判断

/**判断字符串是否为空，如果字符串为空格也会判断为空
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
+ (NSString*)encodeString:(NSString*) str;

/**编码
 *@param str 要编码的字符串
 *@param stringEncoding 编码方式
 *@return 编码后的字符串
 */
+ (NSString*)encodeString:(NSString*) str stringEncoding:(NSStringEncoding) stringEncoding;

/**编码，使用 NSUTF8StringEncoding
 *@return 编码后的字符串
 */
- (NSString*)encodeWithUTF8;

/**编码
 *@param stringEncoding 编码方式
 *@return 编码后的字符串
 */
- (NSString*)encodeWithStringEncoding:(NSStringEncoding) stringEncoding;

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

#pragma mark- 百度

/**百度搜索链接
 */
+ (NSString*)baiduURLForKey:(NSString*) key;

#pragma mark- md5

/**md5加密
 */
- (NSString*)md5;

#pragma mark- 验证合法性

/**判断是否是是手机号码
 */
- (BOOL)isMobileNumber;

/**特殊字符验证
 */
- (BOOL)isIncludeSpecialCharacter;

/**邮政编码验证
 */
- (BOOL)isZipCode;

/**验证固定电话
 */
- (BOOL)isTelPhoneNumber;

/**验证邮箱
 */
- (BOOL)isEmail;

/**是否是身份证号码
 */
- (BOOL)isCardId;

/**是否是网址
 */
- (BOOL)isURL;

/**是否是中文
 */
- (BOOL)isChinese;

/**判断是不是纯数字
 */
- (BOOL)isNumText;

/**判断是否是整数
 */
- (BOOL)isPureInt;

/**是否是纯字母
 */
- (BOOL)isLetterText;

/**是否是字母和数字组合
 */
- (BOOL)isLetterAndNumberText;

/**是否是银行卡
 */
- (BOOL)isBankCard;

#pragma mark- 格式化

///固定电话格式化
- (NSString*)formatTelPhoneNumber;


@end

@interface NSMutableString (Utilities)

/**移除最后一个字符
 */
- (void)removeLastCharacter;

/**通过给定字符串，移除最后一个字符串
 */
- (void)removeLastStringWithString:(NSString*) str;

@end
