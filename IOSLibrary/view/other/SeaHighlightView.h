//
//  SeaHighlightView.h

//

#import <UIKit/UIKit.h>

/**具有点击效果的视图 基类 可继承该类实现相应的效果
 */
@interface SeaHighlightView : UIView

/**高亮显示视图
 */
@property(nonatomic,readonly) UIView *highlightView;

/**开始点击 当手势为UITapGestureRecognizer时，在处理手势的方法中调用该方法
 */
- (void)touchBegan;

/**结束点击 当手势为UITapGestureRecognizer时，在处理手势的方法中调用该方法
 */
- (void)touchEnded;

/**添加单击手势
 */
- (void)addTarget:(id) target action:(SEL) selector;

@end
