//
//  SeaNetworkActivityView.h

//

#import <UIKit/UIKit.h>

/**网络加载指示器
 */
@interface SeaNetworkActivityView : UIView

/**提示信息
 */
@property(nonatomic,copy) NSString *msg;

/**开始动画
 */
- (void)stopAnimating;

/**停止动画
 */
- (void)startAnimating;

@end
