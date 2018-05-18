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

/**内容视图是否延迟显示 0 不延迟
 */
@property(nonatomic,assign) NSTimeInterval delay;

@end
