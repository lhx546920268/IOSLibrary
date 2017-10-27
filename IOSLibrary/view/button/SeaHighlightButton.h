//
//  SeaHighlightButton.h

//

#import "SeaHighlightView.h"

/**点击高亮效果按钮
 */
@interface SeaHighlightButton : SeaHighlightView

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**选中颜色 default is 'nil'
 */
@property(nonatomic,strong) UIColor *selectedColor;

/**正常颜色 default is [UIColor blackColor]
 */
@property(nonatomic,strong) UIColor *normalColor;

/**是否选中
 */
@property(nonatomic,assign) BOOL selected;

@end
