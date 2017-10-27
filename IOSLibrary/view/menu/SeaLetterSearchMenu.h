//
//  SeaLetterSearchMenu.h

//

#import <UIKit/UIKit.h>

//菜单宽度
#define _SeaLetterSearchMenuWidth_ 30

/**字母搜索菜单
 */
@interface SeaLetterSearchMenu : UIView

/**选中的标题
 */
@property(nonatomic,strong) NSString *toucheString;

/**字体颜色
 */
@property(nonatomic,strong) UIColor *titleColor;

/**菜单按钮标题  数组元素是 NSString, 如果标题的长度大于1，只取第一个字符
 */
@property(nonatomic,strong) NSArray *titles;

//选择方法
@property(nonatomic,weak) id target;
@property(nonatomic,assign) SEL selector;

/**添加字母选择方法
 */
- (void)addTarget:(id) target action:(SEL)action;


/**构造方法
 *@param titles 标题信息 数组元素是 NSString
 */
- (id)initWithFrame:(CGRect)frame menuTitles:(NSArray*) titles;

@end
