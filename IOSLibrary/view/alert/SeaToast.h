//
//  SeaToast.h

//

#import <UIKit/UIKit.h>

/**信息提示框
 */
@interface SeaToast : UIView

/**是否正在动画中
 */
@property(nonatomic,readonly) BOOL isAnimating;

/**是否要移除当提示框隐藏时，default is 'YES'
 */
@property(nonatomic,assign) BOOL removeFromSuperViewAfterHidden;

/**距离父视图的边距
 */
@property(nonatomic,assign) UIEdgeInsets superEdgeInsets;

/**内容边距
 */
@property(nonatomic,assign) UIEdgeInsets contentEdgeInsets;

/**设置文字信息
 */
@property(nonatomic,copy) NSString *text;

/**显示提示框并设置多少秒后消失
 *@param delay 消失延时时间
 */
- (void)showAndHideDelay:(NSTimeInterval) delay;

@end
