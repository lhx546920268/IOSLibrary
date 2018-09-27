//
//  SeaTools.h
//  Sea

//

#import <UIKit/UIKit.h>

/**实用工具
 */

/**获取圆上的坐标点
 *@param center 圆心坐标
 *@param radius 圆半径
 *@param arc 要获取坐标的弧度 0 - 360
 */
UIKIT_EXTERN CGPoint pointInCircle(CGPoint center, CGFloat radius, CGFloat arc);

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
 *@param mobiles 电话号码
 *@param flag 是否有弹窗提示 没弹窗显示只拨打第一个
 */
UIKIT_EXTERN void makePhoneCall(NSArray<NSString*> *mobiles, BOOL flag);

/**
 判断某个多边形是否包含某个点
 */
UIKIT_EXTERN BOOL polygonContainsPoint(NSArray<NSValue*> *points, CGPoint point);

/**
 判断两条线是否相交
 */
UIKIT_EXTERN BOOL areIntersecting(CGPoint point1, CGPoint point2, CGPoint point3, CGPoint point4);
