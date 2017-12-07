//
//  SeaBadNetworkRemindView.h

//

#import <UIKit/UIKit.h>

/**当第一次获取数据失败时的提示框
 */
@interface SeaBadNetworkRemindView : UIView

/**重新加载回调
 */
@property(nonatomic, copy) void(^reloadDataHandler)(void);

@end
