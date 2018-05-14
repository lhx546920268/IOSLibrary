#import <UIKit/UIKit.h>

/**
 获取拼音的筛选方式
 */
typedef NS_OPTIONS(NSInteger, SeaPinyinFilter){
    
    ///全拼
    SeaPinyinFilterWhole = 1 << 1,
    
    ///拼音声母(每个字的声母)
    SeaPinyinFilterInitials = 1 << 2,
    
    ///拼音数组
    SeaPinyinFilterArray = 1 << 3,
    
    ///全部
    SeaPinyinFilterAll = SeaPinyinFilterWhole | SeaPinyinFilterInitials | SeaPinyinFilterArray,
};

/**
 中文转拼音
 */
@interface ChineseToPinyin : NSObject 

/**
 获取全拼 如 ‘输入’ 返回 ‘shuru’
 @param string 要获取拼音的字符串
 @return 全拼
 */
+ (NSString*)pinyinWholeFromChiniseString:(NSString *)string;

/**
 获取拼音声母(首字母)组合 如 ‘输入’ 返回 ‘sr’
 @param string 要获取拼音的字符串
 @return 全拼
 */
+ (NSString*)pinyinInitialsFromChiniseString:(NSString *)string;

/**
 获取每个字拼音数组
 @param string 要获取拼音的字符串
 @return 拼音数组
 */
+ (NSArray<NSString*>*)pinyinArrayFromChiniseString:(NSString *)string;

/**
 获取拼音数据
 @return 通过 objectForKey:@(SeaPinyinFilter) 获取对应数据
 */
+ (NSDictionary*)pinyinFromChiniseString:(NSString *)string filter:(SeaPinyinFilter) filter;

/**
 获取拼音的首字母
 @param string 要获取拼音的字符串
 @return 首字母，大写
 */
+ (char)sortSectionTitle:(NSString *)string; 

@end
