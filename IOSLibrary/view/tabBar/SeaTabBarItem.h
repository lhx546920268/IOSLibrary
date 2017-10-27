//
//  SeaTabBarItem.h

//

#import <UIKit/UIKit.h>

#define _SeaTabBarItemTextHeight_ 18.0

/**选项卡按钮
 */
@interface SeaTabBarItem : UIControl

/**标题
 */
@property(nonatomic,readonly) UILabel *textLabel;

/**边缘数值
 */
@property(nonatomic,copy) NSString *badgeValue;

/**构造方法
 *@param frame 位置大小
 *@param normalImage 未选中的图片
 *@param selectedImage 选中的图片
 *@param title 标题 如果为nil，图片占满 否则标题高 18.0
 *@return 返回一个 实例
 */
- (id)initWithFrame:(CGRect) frame normalImage:(UIImage*) normalImage selectedImage:(UIImage*) selectedImage title:(NSString*) title;

@end
