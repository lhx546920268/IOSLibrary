//
//  SeaCheckBox.h

//

#import <UIKit/UIKit.h>

@interface SeaCheckBox : UIButton

/**未选中图片
 */
@property(nonatomic,strong) UIImage *normalImage;

/**选中状态的图片
 */
@property(nonatomic,strong) UIImage *selectedImage;

/**当选中时是否有动画效果 default is 'YES'
 */
@property(nonatomic,assign) BOOL animateWhenSelected;

/**构造方法
 *@param frame 位置大小
 *@param normalImage 未选中图片 如果nil,则使用默认的图片
 *@param selectedImage 选中状态的图片 如果nil,则使用默认的图片
 *@return 已初始化的 SeaCheckBox
 */
- (id)initWithFrame:(CGRect)frame normalImage:(UIImage*) normalImage selectedImage:(UIImage*) selectedImage;



@end
