//
//  SeaToast.h

//

#import <UIKit/UIKit.h>


///提示框位置
typedef NS_ENUM(NSInteger, SeaToastGravity){
    
    ///上
    SeaToastGravityTop = 1 << 0,
    
    ///下
    SeaToastGravityBottom = 1 << 1,
    
    ///垂直居中
    SeaToastGravityCenterVertical = 1 << 2,
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

// 显示提示框 2秒后消失
- (void)show;

/**显示提示框并设置多少秒后消失
 *@param delay 消失延时时间
 */
- (void)showAndHideDelay:(NSTimeInterval) delay;

@end
