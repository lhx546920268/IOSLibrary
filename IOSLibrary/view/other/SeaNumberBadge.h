//
//  SeaNumberBadge.h
//  Sea

//
//

#import <UIKit/UIKit.h>

#define _badgeViewWidth_ 44
#define _badgeViewHeight_ 40

/**视图边缘数字
 */
@interface SeaNumberBadge : UIView

/**内部填充颜色 default is '[UIColor redColor]'
 */
@property(nonatomic,strong) UIColor *fillColor;

/**边界颜色 default is '[UIColor clearColor]'
 */
@property(nonatomic,strong) UIColor *strokeColor;

/**字体颜色 default is '[UIColor whiteColor]'
 */
@property(nonatomic,strong) UIColor *textColor;

/**字体 
 */
@property(nonatomic,strong) UIFont *font;

/**当前要显示的字符
 */
@property(nonatomic,copy) NSString *value;

/**是否隐藏当 value = 0 时, default is 'YES'
 */
@property(nonatomic,assign) BOOL hiddenWhenZero;

/**显示的最大数字 default is '99'
 */
@property(nonatomic,assign) int maxNum;

/**是否是一个点 default is 'NO'
 */
@property(nonatomic,assign) BOOL point;

/**点的位置 default the view's center
 */
@property(nonatomic,assign) CGPoint pointCenter;

/**点的半径 当 point = YES 时有效 default is '5.0'
 */
@property(nonatomic,assign) CGFloat pointRadius;

@end
