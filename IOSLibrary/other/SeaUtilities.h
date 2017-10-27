//
//  SeaUtilities.h
//  Sea

//

#import <UIKit/UIKit.h>

/**实用工具
 */

/**获取圆上的坐标点
 *@param center 圆心坐标
 *@param radius 圆半径
 *@param arc 要获取坐标的弧度
 */
UIKIT_EXTERN CGPoint PointInCircle(CGPoint center, CGFloat radius, CGFloat arc);

/**获取app名称
 */
UIKIT_EXTERN NSString* appName(void);

/**获取app图标
 */
UIKIT_EXTERN UIImage* appIcon(void);

/**当前app版本
 */
UIKIT_EXTERN NSString* appVersion(void);

/**注册推送通知
 */
UIKIT_EXTERN void registerRemoteNotification(void);

/**取消注册推送通知
 */
UIKIT_EXTERN void unregisterRemoteNotification(void);

/**打开系统设置
 */
UIKIT_EXTERN void openSystemSettings(void);


/**拨打电话
 *@param phoneNumber 电话号码
 *@param flag 是否有弹窗提示
 */
UIKIT_EXTERN void makePhoneCall(NSString *phoneNumber, BOOL flag);

/**商品价格格式化
 */
UIKIT_EXTERN NSString* formatFloatPrice(float price);

/**商品价格格式化
 */
UIKIT_EXTERN NSString* formatStringPrice(NSString* price);

/**从格式化的价格中获取商品价格
 */
UIKIT_EXTERN NSString* priceFromFormatStringPrice(NSString* price);

/**前往商城首页
 */
UIKIT_EXTERN void goToMallHome(void);
