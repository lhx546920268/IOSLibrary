//
//  UBDashView.h

//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

/**虚线
 */
@interface SeaDashView : UIView

/**虚线每段宽度 default is '10.0'
 */
@property(nonatomic,assign) IBInspectable CGFloat dashesLength;

/**虚线间隔宽度 default is '5.0'
 */
@property(nonatomic,assign) IBInspectable CGFloat dashesInterval;

/**虚线颜色 default is 'grayColor'
 */
@property(nonatomic,strong) IBInspectable UIColor *dashesColor;

@end
