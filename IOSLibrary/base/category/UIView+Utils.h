//
//  UIView+Utils.h

//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

/** get and set frame.origin.y
*/
@property (nonatomic) CGFloat top;

/** get and set (frame.origin.y + frame.size.height)
 */
@property (nonatomic) CGFloat bottom;

/** get and set (frame.origin.x + frame.size.width)
 */
@property (nonatomic) CGFloat right;

/** get and set frame.origin.x
 */
@property (nonatomic) CGFloat left;

/** get and set frame.size.width
 */
@property (nonatomic) CGFloat width;

/** get and set frame.size.height
 */
@property (nonatomic) CGFloat height;

/** get and set center.x
 */
@property (nonatomic) CGFloat centerX;

/** get and set center.y
 */
@property (nonatomic) CGFloat centerY;

#pragma mark- 虚线 dash

/** 虚线边框图层
 */
@property (nonatomic, strong) CAShapeLayer *dashBorderLayer;

/**设置边框颜色、圆角、边框粗细
 */
- (void)makeBorderWidth:(CGFloat)width Color:(UIColor *)color CornerRadius:(CGFloat)cornerRadius;

/*添加虚线边框 圆角会根据 视图的圆角来确定
 *@param width 线条宽度
 *@param lineColor 线条颜色
 *@param dashesLength 虚线间隔宽度
 *@param dashesInterval 虚线每段宽度
 */
- (void)addDashBorderWidth:(CGFloat) width lineColor:(UIColor*) lineColor dashesLength:(CGFloat) dashesLength dashesInterval:(CGFloat) dashesInterval;


/**设置部分圆角
 *@param cornerRadius 圆角
 *@param corners 圆角位置
 */
- (void)sea_setCornerRadius:(CGFloat) cornerRadius corners:(UIRectCorner) corners;

/**设置部分圆角
 *@param cornerRadius 圆角
 *@param corners 圆角位置
 *@param rect 视图大小，如果使用autoLayout
 */
- (void)sea_setCornerRadius:(CGFloat) cornerRadius corners:(UIRectCorner) corners rect:(CGRect) rect;

@end
