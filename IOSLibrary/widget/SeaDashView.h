//
//  UBDashView.h

//

#import <UIKit/UIKit.h>

/**虚线
 */
@interface SeaDashView : UIView

/**虚线每段宽度 default is '10.0'
 */
@property(nonatomic,assign) CGFloat dashesLength;

/**虚线间隔宽度 default is '5.0'
 */
@property(nonatomic,assign) CGFloat dashesInterval;

/**虚线颜色 default is 'grayColor'
 */
@property(nonatomic,retain) UIColor *dashesColor;

@end
