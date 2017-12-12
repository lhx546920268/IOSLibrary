//
//  SeaImageTitleMenuItem.h

//

#import "SeaHighlightView.h"

/**图片和文字组成的菜单按钮，图片在上，文字在下
 */
@interface SeaImageTitleMenuItem : SeaHighlightView

/**图片
 */
@property(nonatomic,readonly) UIImageView *imageView;

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**正常显示的图片
 */
@property(nonatomic,strong) UIImage *normalImage;

/**选中的图片
 */
@property(nonatomic,strong) UIImage *selectedImage;

/**是否选中
 */
@property(nonatomic,assign) BOOL selected;

/**菜单按钮下标
 */
@property(nonatomic,assign) NSInteger index;

/**构造方法
 *@param image 正常显示的图片
 *@param title 标题
 *@param insets 边距
 *@return 一个初始化的 SeaImageTitleMenuItem 对象
 */
- (id)initWithFrame:(CGRect)frame image:(UIImage*) image title:(NSString*) title insets:(UIEdgeInsets) insets;

@end
