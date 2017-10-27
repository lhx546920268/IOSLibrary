//
//  SeaNetworkActivityView.h

//

#import <UIKit/UIKit.h>

#define SeaNetworkActivityViewWidth 120
#define SeaNetworkActivityViewHeight 120

/**网络加载指示器
 */
@interface SeaNetworkActivityView : UIView

/**提示信息
 */
@property(nonatomic,assign) NSString *msg;

/**开始动画
 */
- (void)stopAnimating;

/**停止动画
 */
- (void)startAnimating;

@end
