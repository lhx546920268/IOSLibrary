//
//  SeaToast.h

//

#import <UIKit/UIKit.h>


///提示框位置
typedef NS_ENUM(NSInteger, SeaToastGravity){
    
    ///上
    SeaToastGravityTop = 0,
    
    ///下
    SeaToastGravityBottom,
    
    ///垂直居中
    SeaToastGravityCenterVertical,
};


/**信息提示框
 */
@interface SeaToast : UIView

/**距离父视图的边距
 */
@property(nonatomic,assign) UIEdgeInsets superEdgeInsets;

/**内容边距
 */
@property(nonatomic,assign) UIEdgeInsets contentEdgeInsets;

/**设置文字信息
 */
@property(nonatomic,copy) NSString *text;

/**设置图标
 */
@property(nonatomic,strong) UIImage *icon;

/**位置 default is 'SeaToastGravityCenterVertical'
 */
@property(nonatomic,assign) SeaToastGravity gravity;

/**图标和文字的间距 default is ''5
 */
@property(nonatomic,assign) CGFloat verticalSpace;

/**是否需要移除父视图 当提示框消失后 default is 'YES'
 */
@property(nonatomic,assign) BOOL shouldRemoveOnDismiss;

/**提示隐藏回调
 */
@property(nonatomic,copy) void(^dismissHanlder)(void);

/**最小大小
 */
@property(nonatomic,assign) CGSize minSize;

// 显示提示框 1.5秒后消失
- (void)show;

// 隐藏
- (void)dismiss;

/**显示提示框并设置多少秒后消失
 *@param delay 消失延时时间
 */
- (void)showAndHideDelay:(NSTimeInterval) delay;

@end
