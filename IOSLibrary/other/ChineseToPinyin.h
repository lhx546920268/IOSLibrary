#import <UIKit/UIKit.h>

/**中文转拼音
 */
@interface ChineseToPinyin : NSObject {
    
}

/**获取全拼 如 ‘输入’ 返回 ‘shuru’
 *@param string 要获取拼音的字符串
 *@return 全拼
 */
+ (NSString *) pinyinFromChiniseString:(NSString *)string;

/**获取拼音的首字母
 *@param string 要获取拼音的字符串
 *@return 首字母，大写
 */
+ (char) sortSectionTitle:(NSString *)string; 

@end