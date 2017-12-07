//
//  SeaNavigationController.h

//
//

#import <UIKit/UIKit.h>

/**用于不同颜色的导航条间的切换，presentViewController, 状态栏样式的改变
 */
@interface SeaNavigationController : UINavigationController

/**想要显示的状态栏样式
 */
@property(nonatomic,assign) UIStatusBarStyle targetStatusBarStyle;

@end
