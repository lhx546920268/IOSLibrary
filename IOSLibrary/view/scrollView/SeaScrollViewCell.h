//
//  SeaScrollViewCell.h

//

#import <UIKit/UIKit.h>

/**可复用的scrollView 的cell基类
 */
@interface SeaScrollViewCell : UIView

/**是否有点击事件 defalut is 'NO'
 */
@property(nonatomic,assign) BOOL enableGesture;

/**点击手势
 */
@property(nonatomic,readonly) UITapGestureRecognizer *tapGesture;

/**添加点击事件
 */
- (void)addTarget:(id) target action:(SEL)action;

/**移除点击事件
 */
- (void)removeTarget:(id) target action:(SEL)action;

@end
